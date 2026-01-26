# Deployment Guide - GDE Americas Hub

This document explains how the GDE Americas Hub is deployed and how to set it up.

## 🚀 Deployment Platform: Netlify

The hub is deployed using **Netlify** with automatic continuous deployment from GitHub.

### Why Netlify?

- ✅ **Deploy Previews**: Every PR gets a unique preview URL for easy review
- ✅ **Fast Builds**: 2-3 minute build times
- ✅ **Global CDN**: Fast content delivery worldwide
- ✅ **Free for Open Source**: 300 build minutes/month, sufficient for this project
- ✅ **Simple Setup**: Zero configuration after initial setup

---

## 📋 Initial Setup (One-time)

### Prerequisites

- Admin access to the `gde-americas/gde-americas-hub` GitHub repository
- A Netlify account (free)

### Step 1: Create Netlify Account

1. Go to [netlify.com](https://netlify.com)
2. Click "Sign up" and choose "GitHub" as the login method
3. Authorize Netlify to access your GitHub account

### Step 2: Import the Repository

1. In Netlify dashboard, click "Add new site" → "Import an existing project"
2. Choose "GitHub" as your Git provider
3. Search for and select `gde-americas/gde-americas-hub`
4. Netlify will automatically detect the `netlify.toml` configuration

### Step 3: Configure Build Settings (should be auto-detected)

If not auto-detected, configure:

- **Build command**: (see `netlify.toml` - includes claat installation and export)
- **Publish directory**: `site`
- **Production branch**: `main`

### Step 4: Deploy

Click "Deploy site" and Netlify will:

1. Install Go and Python dependencies
2. Install `claat` tool
3. Run `./scripts/export-all-codelabs.sh` to generate all codelabs
4. Run `mkdocs build` to build the site
5. Deploy to a Netlify URL (e.g., `gde-americas-hub.netlify.app`)

### Step 5: Custom Domain (Optional)

If you have a custom domain:

1. Go to Site settings → Domain management
2. Add custom domain
3. Configure DNS settings as instructed by Netlify
4. Enable HTTPS (automatic with Netlify)

---

## 🔄 Continuous Deployment

Once set up, deployment is automatic:

### Production Deployments (main branch)

```
Push to main → Netlify builds → Deploys to production
```

**Trigger**: Any push to the `main` branch

**What happens**:
1. Netlify clones the repository
2. Installs `claat` via Go
3. Exports all codelabs from source markdown
4. Builds MkDocs site
5. Deploys to production URL

**Time**: ~3-5 minutes

### Deploy Previews (Pull Requests)

```
Open PR → Netlify builds → Comments with preview URL
```

**Trigger**: Any pull request

**What happens**:
1. Netlify builds the PR branch
2. **Generates ONLY changed codelabs** (incremental build - fast!)
3. Creates a unique preview URL
4. Comments on the PR with the URL

**Benefits**:
- ✅ Reviewers can see changes live without running locally
- ✅ Perfect for reviewing codelabs visually
- ✅ Each PR has isolated preview environment
- ✅ **Fast builds (~1-2 min)** thanks to incremental export

**URL format**: `deploy-preview-{PR-number}--gde-americas-hub.netlify.app`

**Build time:**
- Changed 1-3 codelabs: ~1-2 minutes
- Changed 5-10 codelabs: ~2-3 minutes
- Changed 20+ codelabs: ~5+ minutes

### Branch Deployments

**Trigger**: Push to any branch (other than main)

**What happens**: Creates a branch-specific deployment

**URL format**: `{branch-name}--gde-americas-hub.netlify.app`

---

## 🛠️ Build Process

### What Gets Built

The build process (`netlify.toml`) varies by context:

**Production (main branch):**
```bash
# Full build - ensures complete consistency
go install github.com/googlecodelabs/tools/claat@latest
./scripts/export-all-codelabs.sh --all  # Exports ALL codelabs
mkdocs build --strict
```

**Deploy Previews (PRs) & Branch Deploys:**
```bash
# Incremental build - faster for development
go install github.com/googlecodelabs/tools/claat@latest
./scripts/export-all-codelabs.sh  # Exports ONLY changed codelabs
mkdocs build --strict
```

**Why Different?**
- **Production**: Slower but guarantees all codelabs are up-to-date (~5-8 min)
- **Previews**: Fast feedback for contributors (~1-3 min)
- **Result**: Best of both worlds - speed for development, reliability for production

### What's in Git vs. What's Generated

**Committed to Git**:
- ✅ `docs/codelabs/source/*.md` - Source markdown files
- ✅ `docs/codelabs/*/index.md` - Category index pages
- ✅ `scripts/` - Build scripts
- ✅ `netlify.toml` - Build configuration
- ✅ All other documentation and content

**Generated during build** (NOT in Git):
- ❌ `docs/codelabs/**/*/` - HTML codelab directories
- ❌ `site/` - MkDocs build output
- ❌ `.cache/` - Build cache

**Why?** This approach:
- Keeps the repository clean and small
- Prevents merge conflicts on generated files
- Ensures consistency (always built from source)
- Follows industry best practices

---

## 🔍 Monitoring & Logs

### View Build Logs

1. Go to Netlify dashboard
2. Click on your site
3. Go to "Deploys" tab
4. Click on any deploy to see detailed logs

### Build Status

You can see build status in:
- Netlify dashboard
- GitHub commit checks
- GitHub PR comments (for deploy previews)

### Common Build Issues

**Issue**: `claat: command not found`
- **Solution**: Check that Go is installed in build environment
- **Check**: `netlify.toml` includes `go install` command

**Issue**: Codelab export fails
- **Solution**: Check source markdown syntax
- **Check**: Run `./scripts/export-all-codelabs.sh` locally first

**Issue**: MkDocs build fails
- **Solution**: Check `mkdocs.yml` syntax
- **Check**: Run `mkdocs build --strict` locally first

---

## 📊 Build Environment

### Installed in Netlify Build

- **Python**: 3.11 (specified in `netlify.toml`)
- **Go**: Latest (for claat installation)
- **Node.js**: Latest LTS (Netlify default)
- **Python packages**: From `requirements.txt`

### Environment Variables

Currently, no environment variables are needed. The build is fully configured via:
- `netlify.toml` - Build configuration
- `requirements.txt` - Python dependencies
- `mkdocs.yml` - Site configuration

---

## 🧪 Testing Locally

To test the full build process locally:

```bash
# 1. Install claat
go install github.com/googlecodelabs/tools/claat@latest

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Export all codelabs
./scripts/export-all-codelabs.sh

# 4. Build MkDocs site
mkdocs build --strict

# 5. Serve locally
cd site
python -m http.server 8000
```

Or use the MkDocs development server:

```bash
# Just for development (doesn't build codelabs)
mkdocs serve
```

---

## 🔐 Security & Performance

### Security Headers

Configured in `netlify.toml`:
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `X-Content-Type-Options: nosniff`
- `Referrer-Policy: strict-origin-when-cross-origin`

### Caching

Aggressive caching for static assets:
- CSS/JS files: 1 year cache
- Images: 1 year cache
- HTML: No cache (always fresh)

### Performance

- Global CDN distribution
- Automatic asset optimization
- HTTP/2 enabled by default
- Automatic HTTPS with Let's Encrypt

---

## 📝 Maintenance

### Updating Dependencies

**Python packages**:
```bash
# Update requirements.txt
pip install --upgrade mkdocs-material
pip freeze > requirements.txt
git commit -m "Update dependencies"
```

**Claat tool**:
- Always uses latest version via `@latest`
- No manual updates needed

### Rebuild All Codelabs

To force a rebuild without code changes:

1. Go to Netlify dashboard
2. Click "Trigger deploy" → "Deploy site"
3. Or push an empty commit:
   ```bash
   git commit --allow-empty -m "Trigger rebuild"
   git push
   ```

---

## 🆘 Troubleshooting

### Deploy Failed

1. Check Netlify build logs
2. Test locally: `./scripts/export-all-codelabs.sh && mkdocs build`
3. Check for syntax errors in markdown/config files
4. Verify all source files are committed

### Deploy Preview Not Appearing

1. Check that Netlify has PR comment permissions
2. Verify the PR is from a branch in the same repository
3. Check Netlify deploy log for errors

### Codelab Not Appearing

1. Verify source file is in `docs/codelabs/source/`
2. Check metadata is valid (especially `id` field)
3. Ensure category index is updated
4. Check build logs for export errors

---

## 📚 Resources

- [Netlify Documentation](https://docs.netlify.com/)
- [Netlify Build Configuration](https://docs.netlify.com/configure-builds/file-based-configuration/)
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- [Google Codelabs Tools](https://github.com/googlecodelabs/tools)

---

## 💡 Tips

1. **Always test locally** before pushing
2. **Use deploy previews** to review changes
3. **Check build logs** if something goes wrong
4. **Keep source files clean** - don't commit generated HTML
5. **Update category indexes** when adding codelabs

---

For questions or issues, please open an issue in the repository or contact the maintainers.
