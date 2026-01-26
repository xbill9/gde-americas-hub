"""
MkDocs hook to copy codelab HTML directories to the site output.

This hook ensures that generated codelab HTML directories (which are not
processed by MkDocs as markdown) are copied to the final site build.
"""

import os
import shutil
import logging
from pathlib import Path

log = logging.getLogger(f"mkdocs.plugins.{__name__}")


def on_post_build(config, **kwargs):
    """
    Copy codelab HTML directories to site after build completes.

    This runs after MkDocs finishes building the site and copies all
    codelab subdirectories from docs/codelabs/ to site/codelabs/.
    """
    docs_dir = Path(config["docs_dir"])
    site_dir = Path(config["site_dir"])

    codelabs_docs = docs_dir / "codelabs"
    codelabs_site = site_dir / "codelabs"

    if not codelabs_docs.exists():
        log.warning(f"Codelabs directory not found: {codelabs_docs}")
        return

    log.info(f"Copying codelab HTML directories to {codelabs_site}")

    # Categories to process
    categories = [
        "android", "firebase", "cloud", "flutter",
        "ai-ml", "web", "maps", "ads", "workspace", "general"
    ]

    copied_count = 0

    for category in categories:
        category_docs = codelabs_docs / category
        category_site = codelabs_site / category

        if not category_docs.exists():
            continue

        # Ensure category directory exists in site
        category_site.mkdir(parents=True, exist_ok=True)

        # Copy each codelab subdirectory
        for item in category_docs.iterdir():
            if item.is_dir():
                # This is a codelab directory (e.g., how-to-create-a-codelab/)
                dest = category_site / item.name

                # Remove existing if present
                if dest.exists():
                    shutil.rmtree(dest)

                # Copy the entire codelab directory
                shutil.copytree(item, dest)
                log.info(f"  Copied: {category}/{item.name}/")
                copied_count += 1

    if copied_count > 0:
        log.info(f"✓ Successfully copied {copied_count} codelab(s)")
    else:
        log.warning("No codelab directories found to copy")
