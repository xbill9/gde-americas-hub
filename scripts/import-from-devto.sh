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
    echo "Examples:"
    echo "  $0 https://dev.to/username/my-post-title-123"
    echo "  $0 https://dev.to/username/my-post-title-123 john_doe"
    echo ""
    echo "The author-slug should match an entry in docs/blog/.authors.yml"
    echo "If not provided, will prompt for it."
    exit 1
fi

DEVTO_URL=$1
AUTHOR_SLUG=$2

# Extract article ID from URL
if [[ $DEVTO_URL =~ dev\.to/[^/]+/([^/]+)-([0-9]+) ]]; then
    ARTICLE_SLUG="${BASH_REMATCH[1]}"
    ARTICLE_ID="${BASH_REMATCH[2]}"
elif [[ $DEVTO_URL =~ dev\.to/[^/]+/([^-]+) ]]; then
    ARTICLE_SLUG="${BASH_REMATCH[1]}"
    ARTICLE_ID=""
else
    print_error "Invalid dev.to URL format"
fi

print_info "Fetching article from dev.to..."

# Fetch article using dev.to API
if [ -n "$ARTICLE_ID" ]; then
    API_URL="https://dev.to/api/articles/${ARTICLE_ID}"
else
    print_error "Could not extract article ID from URL. Please use the full article URL."
fi

# Fetch with curl
ARTICLE_JSON=$(curl -s "$API_URL")

if [ -z "$ARTICLE_JSON" ] || [[ "$ARTICLE_JSON" == *"error"* ]]; then
    print_error "Failed to fetch article. Check the URL and try again."
fi

# Extract metadata using grep and sed (works without jq)
TITLE=$(echo "$ARTICLE_JSON" | grep -o '"title":"[^"]*"' | head -1 | sed 's/"title":"\(.*\)"/\1/')
DESCRIPTION=$(echo "$ARTICLE_JSON" | grep -o '"description":"[^"]*"' | head -1 | sed 's/"description":"\(.*\)"/\1/')
PUBLISHED_AT=$(echo "$ARTICLE_JSON" | grep -o '"published_at":"[^"]*"' | head -1 | sed 's/"published_at":"\(.*\)"/\1/')
TAGS=$(echo "$ARTICLE_JSON" | grep -o '"tag_list":\[[^\]]*\]' | head -1)
CANONICAL_URL=$(echo "$ARTICLE_JSON" | grep -o '"canonical_url":"[^"]*"' | head -1 | sed 's/"canonical_url":"\(.*\)"/\1/')
BODY_MARKDOWN=$(echo "$ARTICLE_JSON" | sed -n 's/.*"body_markdown":"\(.*\)","created_at".*/\1/p' | sed 's/\\n/\n/g' | sed 's/\\"/"/g')

if [ -z "$TITLE" ]; then
    print_error "Failed to parse article data. The article might be private or the API response format changed."
fi

print_success "Article fetched: $TITLE"

# Extract date from published_at (format: 2026-01-27T12:00:00Z)
POST_DATE=$(echo "$PUBLISHED_AT" | cut -d'T' -f1)

# Convert tags to categories
# Extract tag names from JSON array
CATEGORIES=""
if [ -n "$TAGS" ]; then
    # Parse tag_list array
    TAGS_CLEAN=$(echo "$TAGS" | sed 's/"tag_list":\[//; s/\]//; s/"//g')

    # Map common dev.to tags to our categories
    for tag in $(echo "$TAGS_CLEAN" | tr ',' '\n'); do
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
            ai|ml|machinelearning|artificialintelligence)
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
        grep "^[a-z_]*:" docs/blog/.authors.yml | sed 's/:$//' | sed 's/^/  - /'
    fi
    echo ""
    read -p "Enter author slug (from .authors.yml): " AUTHOR_SLUG
fi

# Verify author exists
if [ -f "docs/blog/.authors.yml" ]; then
    if ! grep -q "^${AUTHOR_SLUG}:" docs/blog/.authors.yml; then
        print_warning "Author '$AUTHOR_SLUG' not found in .authors.yml"
        echo ""
        read -p "Continue anyway? (y/n): " CONTINUE
        if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
            print_error "Aborted. Please add the author to docs/blog/.authors.yml first."
        fi
    fi
fi

# Create filename (date-slug.md)
FILENAME="${POST_DATE}-${ARTICLE_SLUG}.md"
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
