# Scripts - GDE Americas Hub

Helper scripts for managing the GDE Americas Hub.

## Available Scripts

### export-codelab.sh

**Purpose:** Export a single codelab from markdown and organize it into the correct category.

**Usage:**

```bash
# Basic usage (will prompt for category)
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md

# Specify category directly
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md android

# Available categories:
# android, firebase, cloud, flutter, ai-ml, web, maps, ads, workspace, general
```

**What it does:**

1. ✅ Validates claat is installed
2. ✅ Exports the markdown file to HTML using claat
3. ✅ Moves source file to `docs/codelabs/source/` (if not already there)
4. ✅ Moves generated files to `docs/codelabs/{category}/{codelab-id}/`
5. ✅ **Automatically adds the codelab to the category index page**
6. ✅ Provides next steps for testing and committing

**Prerequisites:**

- claat tool installed ([installation guide](https://github.com/googlecodelabs/tools))
- Run from repository root directory

**Use this when:** You're developing locally and want to preview a single codelab.

---

### export-all-codelabs.sh

**Purpose:** Export codelabs from the source directory. Supports both incremental (changed files only) and full builds.

**Usage:**

```bash
# Incremental build (default) - only exports changed codelabs
./scripts/export-all-codelabs.sh

# Full build - exports ALL codelabs
./scripts/export-all-codelabs.sh --all
```

**What it does:**

**Incremental mode (default):**
1. ✅ Detects which `.md` files changed (via git diff)
2. ✅ Exports ONLY changed codelabs
3. ✅ Fast builds (~10-30 seconds for 1-5 codelabs)

**Full build mode (--all flag):**
1. ✅ Finds ALL `.md` files in `docs/codelabs/source/`
2. ✅ Exports every codelab (useful for full regeneration)
3. ✅ Takes longer but ensures consistency

**Both modes:**
- ✅ Determines category from codelab metadata
- ✅ Exports using claat
- ✅ Organizes into correct category directories
- ✅ Reports summary of successes/failures

**Prerequisites:**

- claat tool installed
- Run from repository root directory

**Use this when:**
- **Incremental**: Daily development, testing PRs (fast)
- **Full build**: Production deploys, after claat updates, troubleshooting

**Performance:**
- Incremental: ~5-10 sec per codelab
- Full build with 50 codelabs: ~5-8 minutes
- Full build with 100 codelabs: ~10-15 minutes

---

## Build Process

### Local Development

When developing locally:

```bash
# 1. Create/edit your codelab source
vim docs/codelabs/source/my-codelab.md

# 2. Export it locally to preview
./scripts/export-codelab.sh docs/codelabs/source/my-codelab.md android

# 3. Preview with MkDocs
mkdocs serve

# 4. Commit ONLY the source file
git add docs/codelabs/source/my-codelab.md
git add docs/codelabs/android/index.md  # If updated
git commit -m "Add codelab: My Awesome Tutorial"
```

**Important:** Do NOT commit the generated HTML files. They are git-ignored and generated during CI/CD.

### CI/CD Build (Netlify)

When you push to GitHub:

**Pull Requests & Branches (Incremental):**
```bash
# Netlify automatically runs:
1. go install claat
2. ./scripts/export-all-codelabs.sh      # Only changed codelabs (FAST)
3. mkdocs build --strict                 # Builds the site
4. Deploy to preview URL
```

**Production (main branch - Full Build):**
```bash
# Netlify automatically runs:
1. go install claat
2. ./scripts/export-all-codelabs.sh --all  # ALL codelabs (slower but complete)
3. mkdocs build --strict                    # Builds the site
4. Deploy to production
```

**Why different?**
- **PRs**: Fast feedback (~1-2 min builds) - only regenerates changed codelabs
- **Production**: Full consistency (~5-8 min) - regenerates everything to ensure no issues

### What Gets Committed

✅ **DO commit:**
- `docs/codelabs/source/*.md` (source files)
- `docs/codelabs/*/index.md` (category indexes)
- `scripts/*.sh` (build scripts)

❌ **DO NOT commit:**
- `docs/codelabs/**/*/` (generated HTML directories)
- `site/` (MkDocs build output)

These are automatically generated during deployment.

---

## Contributing

If you create a useful script, please:

1. Add it to this directory
2. Make it executable (`chmod +x script-name.sh`)
3. Document it in this README
4. Follow bash best practices
5. Include error handling

---

**Questions?** Open an issue or check the [Contributing Guidelines](../CONTRIBUTING.md).
