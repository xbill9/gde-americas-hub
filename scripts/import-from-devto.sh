#!/bin/bash

# GDE Americas Hub - Import Blog Post from dev.to
# This script imports a blog post from dev.to and converts it to the correct format

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

# Check if running from repo root
if [ ! -f "mkdocs.yml" ]; then
    print_error "Please run this script from the repository root directory"
fi

# Usage
if [ $# -lt 1 ]; then
    echo "Usage: $0 <dev.to-url> [author-slug]"
    echo ""
    echo "Simply copy the URL from your browser and paste it here!"
    echo ""
    echo "Examples:"
    echo "  $0 https://dev.to/username/my-post-title-abc123"
    echo "  $0 https://dev.to/username/my-post-title-abc123 john_doe"
    echo ""
    echo "The author-slug should match an entry in docs/blog/.authors.yml"
    echo "If not provided, will prompt for it."
    echo ""
    echo "Requirements: Python3"
    exit 1
fi

DEVTO_URL=$1
AUTHOR_SLUG=$2

# Extract username and slug from URL
# Accepts any dev.to URL format: https://dev.to/username/article-slug
if [[ $DEVTO_URL =~ dev\.to/([^/]+)/([^/]+) ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    ARTICLE_SLUG="${BASH_REMATCH[2]}"
    print_info "Fetching article from dev.to..."

    # Detect if URL has numeric ID (long number) or hash suffix
    # If it ends with a long number (6+ digits), it's an ID -> use /api/articles/{id}
    # Otherwise it's a slug with hash -> use /api/articles/{username}/{slug}
    if [[ $ARTICLE_SLUG =~ -([0-9]{6,})$ ]]; then
        # URL has numeric ID (e.g., -3158567)
        ARTICLE_ID="${BASH_REMATCH[1]}"
        API_URL="https://dev.to/api/articles/${ARTICLE_ID}"
    else
        # URL has hash or no special suffix (e.g., -4ceh or just slug)
        API_URL="https://dev.to/api/articles/${USERNAME}/${ARTICLE_SLUG}"
    fi
else
    print_error "Invalid dev.to URL format. Expected: https://dev.to/username/article-slug"
fi

# Fetch with curl
ARTICLE_JSON=$(curl -s "$API_URL")

# Check if response is empty or is an actual API error (has "status" field with error code)
if [ -z "$ARTICLE_JSON" ] || [[ "$ARTICLE_JSON" == *'"status"'* ]] || [[ "$ARTICLE_JSON" == *'"error":'* ]]; then
    print_error "Failed to fetch article. Check the URL and try again."
fi

# Extract metadata using Python (more reliable than sed for JSON parsing)
# Python is available on virtually all systems and handles JSON properly
PARSED_DATA=$(python3 -c "
import json
import sys

try:
    data = json.loads(sys.stdin.read())
    print('TITLE=' + data.get('title', ''))
    print('|||TITLE_END|||')
    print('DESCRIPTION=' + data.get('description', ''))
    print('|||DESCRIPTION_END|||')
    print('PUBLISHED_AT=' + data.get('published_at', ''))
    print('|||PUBLISHED_AT_END|||')
    print('CANONICAL_URL=' + data.get('canonical_url', ''))
    print('|||CANONICAL_URL_END|||')
    print('TAG_LIST=' + ','.join(data.get('tag_list', [])))
    print('|||TAG_LIST_END|||')
    print('BODY_MARKDOWN_START|||')
    print(data.get('body_markdown', ''))
    print('|||BODY_MARKDOWN_END')
except Exception as e:
    print('ERROR: ' + str(e), file=sys.stderr)
    sys.exit(1)
" <<< "$ARTICLE_JSON")

if [ $? -ne 0 ]; then
    print_error "Failed to parse JSON. Is Python3 installed?"
fi

# Extract fields from parsed data
TITLE=$(echo "$PARSED_DATA" | sed -n '/^TITLE=/,/|||TITLE_END|||/p' | head -1 | sed 's/^TITLE=//')
DESCRIPTION=$(echo "$PARSED_DATA" | sed -n '/^DESCRIPTION=/,/|||DESCRIPTION_END|||/p' | head -1 | sed 's/^DESCRIPTION=//')
PUBLISHED_AT=$(echo "$PARSED_DATA" | sed -n '/^PUBLISHED_AT=/,/|||PUBLISHED_AT_END|||/p' | head -1 | sed 's/^PUBLISHED_AT=//')
CANONICAL_URL=$(echo "$PARSED_DATA" | sed -n '/^CANONICAL_URL=/,/|||CANONICAL_URL_END|||/p' | head -1 | sed 's/^CANONICAL_URL=//')
TAG_LIST=$(echo "$PARSED_DATA" | sed -n '/^TAG_LIST=/,/|||TAG_LIST_END|||/p' | head -1 | sed 's/^TAG_LIST=//')
BODY_MARKDOWN=$(echo "$PARSED_DATA" | sed -n '/BODY_MARKDOWN_START|||/,/|||BODY_MARKDOWN_END/p' | sed '1d;$d')

if [ -z "$TITLE" ]; then
    print_error "Failed to parse article data. The article might be private or the API response format changed."
fi

print_success "Article fetched: $TITLE"

# Extract date from published_at (format: 2026-01-27T12:00:00Z)
POST_DATE=$(echo "$PUBLISHED_AT" | cut -d'T' -f1)

# Convert tags to categories
# TAG_LIST is already a comma-separated list from Python parsing
CATEGORIES=""
if [ -n "$TAG_LIST" ]; then
    # Map common dev.to tags to our categories
    for tag in $(echo "$TAG_LIST" | tr ',' '\n'); do
        tag=$(echo "$tag" | xargs) # trim whitespace
        case "${tag,,}" in # lowercase for comparison
            android)
                CATEGORIES="${CATEGORIES}Android, "
                ;;
            firebase)
                CATEGORIES="${CATEGORIES}Firebase, "
                ;;
            gcp|cloud|googlecloud)
                CATEGORIES="${CATEGORIES}Google Cloud, "
                ;;
            flutter)
                CATEGORIES="${CATEGORIES}Flutter, "
                ;;
            ai|ml|machinelearning|artificialintelligence|adk|mcp|a2a|llm|genai)
                CATEGORIES="${CATEGORIES}AI & ML, "
                ;;
            web|javascript|webdev)
                CATEGORIES="${CATEGORIES}Web, "
                ;;
            maps|googlemaps)
                CATEGORIES="${CATEGORIES}Maps, "
                ;;
            ads|admob)
                CATEGORIES="${CATEGORIES}Ads, "
                ;;
            workspace|gsuite)
                CATEGORIES="${CATEGORIES}Workspace, "
                ;;
        esac
    done
fi

# If no categories mapped, use General
if [ -z "$CATEGORIES" ]; then
    CATEGORIES="General"
    print_warning "No matching categories found. Using 'General' as default."
else
    # Remove trailing comma and space
    CATEGORIES=$(echo "$CATEGORIES" | sed 's/, $//')
fi

# Get author slug
if [ -z "$AUTHOR_SLUG" ]; then
    echo ""
    print_info "Available authors in .authors.yml:"
    if [ -f "docs/blog/.authors.yml" ]; then
        grep "^[[:space:]]*[a-z_]*:" docs/blog/.authors.yml | sed 's/:$//' | sed 's/^[[:space:]]*//' | sed 's/^/  - /'
    fi
    echo ""
    read -p "Enter author slug (from .authors.yml): " AUTHOR_SLUG
fi

# Verify author exists
if [ -f "docs/blog/.authors.yml" ]; then
    if ! grep -q "^[[:space:]]*${AUTHOR_SLUG}:" docs/blog/.authors.yml; then
        print_warning "Author '$AUTHOR_SLUG' not found in .authors.yml"
        echo ""
        read -p "Continue anyway? (y/n): " CONTINUE
        if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
            print_error "Aborted. Please add the author to docs/blog/.authors.yml first."
        fi
    fi
fi

# Create filename (date-slug.md)
# Remove dev.to suffix if present:
# - Hash suffix (4-5 chars alphanumeric like -4ceh)
# - Numeric ID suffix (6+ digits like -3158567)
CLEAN_SLUG="$ARTICLE_SLUG"
if [[ $ARTICLE_SLUG =~ ^(.+)-([a-z0-9]{4,5}|[0-9]{6,})$ ]]; then
    CLEAN_SLUG="${BASH_REMATCH[1]}"
fi
FILENAME="${POST_DATE}-${CLEAN_SLUG}.md"
OUTPUT_PATH="docs/blog/posts/${FILENAME}"

# Check if file already exists
if [ -f "$OUTPUT_PATH" ]; then
    print_warning "File already exists: $OUTPUT_PATH"
    read -p "Overwrite? (y/n): " OVERWRITE
    if [[ ! "$OVERWRITE" =~ ^[Yy]$ ]]; then
        print_error "Aborted"
    fi
fi

# Create the blog post file
cat > "$OUTPUT_PATH" << EOF
---
draft: false
date: ${POST_DATE}
authors:
  - ${AUTHOR_SLUG}
categories:
  - ${CATEGORIES}
---

# ${TITLE}

${DESCRIPTION}

<!-- more -->

${BODY_MARKDOWN}

---

*Originally published at [dev.to](${CANONICAL_URL})*
EOF

print_success "Blog post created: $OUTPUT_PATH"
echo ""
print_info "Next steps:"
echo "  1. Review the generated file:"
echo "     cat $OUTPUT_PATH"
echo ""
echo "  2. Edit if needed (especially check date format and categories)"
echo ""
echo "  3. Validate the post:"
echo "     ./scripts/validate-blog-posts.sh $OUTPUT_PATH"
echo ""
echo "  4. Preview locally:"
echo "     mkdocs serve"
echo ""
echo "  5. Commit and push:"
echo "     git add $OUTPUT_PATH"
echo "     git commit -m \"Add blog post: ${TITLE}\""
echo "     git push"
echo ""
print_success "Import complete! 🎉"
