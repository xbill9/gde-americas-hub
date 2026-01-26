#!/bin/bash

# GDE Americas Hub - Codelab Export Helper Script
# This script helps export codelabs using claat and organize them correctly

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

print_info() {
    echo -e "ℹ $1"
}

# Check if claat is installed
if ! command -v claat &> /dev/null; then
    print_error "claat is not installed. Please install it first:"
    echo ""
    echo "Visit: https://github.com/googlecodelabs/tools/releases"
    echo "Or run: go install github.com/googlecodelabs/tools/claat@latest"
    exit 1
fi

# Check if running from repo root
if [ ! -f "mkdocs.yml" ]; then
    print_error "Please run this script from the repository root directory"
fi

# Usage
if [ $# -lt 1 ]; then
    echo "Usage: $0 <codelab-source-file.md> [category]"
    echo ""
    echo "Examples:"
    echo "  $0 my-codelab.md android"
    echo "  $0 docs/codelabs/source/my-codelab.md firebase"
    echo "  $0 my-codelab.md           # Will prompt for category"
    echo ""
    echo "Available categories:"
    echo "  - android"
    echo "  - firebase"
    echo "  - cloud"
    echo "  - flutter"
    echo "  - ai-ml"
    echo "  - web"
    echo "  - maps"
    echo "  - ads"
    echo "  - workspace"
    exit 1
fi

SOURCE_FILE=$1
CATEGORY=$2

# Validate source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    print_error "Source file not found: $SOURCE_FILE"
fi

# Extract just the filename
SOURCE_BASENAME=$(basename "$SOURCE_FILE")

# If no category provided, prompt user
if [ -z "$CATEGORY" ]; then
    echo ""
    print_info "Select a category for your codelab:"
    echo "  1) android"
    echo "  2) firebase"
    echo "  3) cloud"
    echo "  4) flutter"
    echo "  5) ai-ml"
    echo "  6) web"
    echo "  7) maps"
    echo "  8) ads"
    echo "  9) workspace"
    echo " 10) general"
    echo ""
    read -p "Enter category number (1-10): " CATEGORY_NUM

    case $CATEGORY_NUM in
        1) CATEGORY="android";;
        2) CATEGORY="firebase";;
        3) CATEGORY="cloud";;
        4) CATEGORY="flutter";;
        5) CATEGORY="ai-ml";;
        6) CATEGORY="web";;
        7) CATEGORY="maps";;
        8) CATEGORY="ads";;
        9) CATEGORY="workspace";;
        10) CATEGORY="general";;
        *) print_error "Invalid selection";;
    esac
fi

# Validate category
VALID_CATEGORIES=("android" "firebase" "cloud" "flutter" "ai-ml" "web" "maps" "ads" "workspace" "general")
if [[ ! " ${VALID_CATEGORIES[@]} " =~ " ${CATEGORY} " ]]; then
    print_error "Invalid category: $CATEGORY. Must be one of: ${VALID_CATEGORIES[*]}"
fi

echo ""
print_info "Exporting codelab..."
print_info "  Source: $SOURCE_FILE"
print_info "  Category: $CATEGORY"
echo ""

# Create temporary directory for export
TEMP_DIR=$(mktemp -d)

# Save the absolute path to the source directory
SOURCE_DIR_PATH="$(cd "$(dirname "$SOURCE_FILE")" && pwd)"
cd "$SOURCE_DIR_PATH"

# Export the codelab
print_info "Running claat export..."
claat export "$SOURCE_BASENAME" || print_error "claat export failed"

# Find the generated directory (claat creates it based on the 'id' field)
GENERATED_DIR=$(find . -maxdepth 1 -type d -newer "$TEMP_DIR" ! -path . | head -1)

if [ -z "$GENERATED_DIR" ]; then
    print_error "Could not find generated codelab directory"
fi

CODELAB_ID=$(basename "$GENERATED_DIR")
print_success "Codelab generated: $CODELAB_ID"

# Save the absolute path to the generated directory before changing directories
GENERATED_PATH="$SOURCE_DIR_PATH/$CODELAB_ID"

# Return to repo root to work with absolute paths
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
cd "$REPO_ROOT"

# Move source file to source directory if not already there
SOURCE_DIR="docs/codelabs/source"
if [[ "$(dirname "$SOURCE_FILE")" != *"codelabs/source"* ]]; then
    print_info "Moving source file to $SOURCE_DIR/"
    mkdir -p "$SOURCE_DIR"
    mv "$SOURCE_FILE" "$SOURCE_DIR/" 2>/dev/null || true
fi

# Move generated directory to category
CATEGORY_DIR="docs/codelabs/$CATEGORY"
mkdir -p "$CATEGORY_DIR"

TARGET_PATH="$CATEGORY_DIR/$CODELAB_ID"

# Check if target already exists
if [ -d "$TARGET_PATH" ]; then
    print_warning "Codelab already exists at $TARGET_PATH. Overwriting..."
    rm -rf "$TARGET_PATH"
fi

# Move the generated codelab
if [ -d "$GENERATED_PATH" ]; then
    mv "$GENERATED_PATH" "$TARGET_PATH"
    print_success "Moved to: $TARGET_PATH/"
else
    print_error "Could not find generated codelab directory at: $GENERATED_PATH"
fi

# Extract metadata from codelab.json
CODELAB_JSON="docs/codelabs/$CATEGORY/$CODELAB_ID/codelab.json"
if [ -f "$CODELAB_JSON" ]; then
    CODELAB_TITLE=$(grep '"title"' "$CODELAB_JSON" | head -1 | sed 's/.*: "\(.*\)",/\1/')
    CODELAB_SUMMARY=$(grep '"summary"' "$CODELAB_JSON" | head -1 | sed 's/.*: "\(.*\)",/\1/')
    CODELAB_DURATION=$(grep '"duration"' "$CODELAB_JSON" | head -1 | sed 's/.*: \(.*\),/\1/')

    # Calculate duration in minutes
    DURATION_MIN=$((CODELAB_DURATION))

    # Update category index
    INDEX_FILE="docs/codelabs/$CATEGORY/index.md"

    # Check if codelab already exists in index
    if grep -q "$CODELAB_ID" "$INDEX_FILE" 2>/dev/null; then
        print_warning "Codelab already exists in $INDEX_FILE. Skipping index update."
    else
        print_info "Adding codelab to $INDEX_FILE..."

        # Create the entry
        CODELAB_ENTRY="
### [$CODELAB_TITLE]($CODELAB_ID/)
**Duration**: ~${DURATION_MIN} minutes | **Difficulty**: Beginner

$CODELAB_SUMMARY

[:octicons-arrow-right-24: Start Codelab]($CODELAB_ID/){ .md-button .md-button--primary }

---
"

        # Insert after "## Available Codelabs" or before "---"
        if grep -q "## Available Codelabs" "$INDEX_FILE"; then
            # Find line number and insert after it
            LINE_NUM=$(grep -n "## Available Codelabs" "$INDEX_FILE" | head -1 | cut -d: -f1)
            TEMP_FILE=$(mktemp)
            head -n $((LINE_NUM)) "$INDEX_FILE" > "$TEMP_FILE"
            echo "$CODELAB_ENTRY" >> "$TEMP_FILE"
            tail -n +$((LINE_NUM + 1)) "$INDEX_FILE" >> "$TEMP_FILE"
            mv "$TEMP_FILE" "$INDEX_FILE"
            print_success "Added codelab to category index!"
        else
            print_warning "Could not find '## Available Codelabs' section in $INDEX_FILE"
            print_info "Please add the codelab manually to the index"
        fi
    fi
fi

# Clean up
rm -rf "$TEMP_DIR"

echo ""
print_success "🎉 Codelab exported successfully!"
echo ""
print_success "✓ Source: docs/codelabs/source/$SOURCE_BASENAME"
print_success "✓ Generated: docs/codelabs/$CATEGORY/$CODELAB_ID/"
print_success "✓ Added to: docs/codelabs/$CATEGORY/index.md"
echo ""
print_info "Next steps:"
echo "  1. Preview your codelab:"
echo "     mkdocs serve"
echo "     Visit: http://127.0.0.1:8000/gde-americas-hub/codelabs/$CATEGORY/"
echo ""
echo "  2. Or preview just the codelab:"
echo "     cd docs/codelabs/$CATEGORY/$CODELAB_ID"
echo "     python3 -m http.server 8080"
echo ""
echo "  3. Test and commit:"
echo "     git add docs/codelabs/"
echo "     git commit -m \"Add codelab: $CODELAB_TITLE\""
echo "     git push origin your-branch-name"
echo ""
print_success "Your codelab is ready! 🚀"
