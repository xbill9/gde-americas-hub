# How to Write a Blog Post

This guide explains how to create and publish blog posts on the GDE Americas Hub.

## How to Create a Blog Post

### 1. File Naming Convention

Blog posts must follow this naming pattern:

```
YYYY-MM-DD-post-slug.md
```

Examples:
- `2026-01-23-getting-started-android.md`
- `2026-02-15-firebase-tips-tricks.md`
- `2026-03-10-cloud-run-tutorial.md`

### 2. Post Front Matter

Each post must have YAML front matter at the top:

```yaml
---
draft: false                    # Set to true to hide from production
date: 2026-01-23               # Publication date
authors:                       # List of author IDs from .authors.yml
  - your_author_id
categories:                    # Pick from allowed categories
  - Android
  - Firebase
  - Google Cloud
  - Flutter
  - AI & ML
  - Web
  - Maps
  - Ads
  - Workspace
  - General
tags:                          # Optional tags
  - kotlin
  - tutorial
  - beginner
---
```

### 3. Post Content Structure

```markdown
# Your Post Title

A brief introduction to your post (1-2 sentences).

<!-- more -->

The `<!-- more -->` comment creates a "Read more" separator for the excerpt.

## Section 1

Your content here...

## Section 2

More content...

## Conclusion

Wrap up your post.
```

### 4. Adding Yourself as an Author

Edit `docs/blog/.authors.yml`:

```yaml
authors:
  your_github_username:
    name: Your Name
    description: GDE for [Technology]
    avatar: https://github.com/your_username.png
    url: https://your-website.com
    twitter: your_handle  # Optional
```

### 5. Example Full Post

See `posts/2026-01-23-welcome.md` for a complete example.

### 6. Preview Your Post

```bash
# Install dependencies
pip install -r requirements.txt

# Run local server
mkdocs serve

# Visit http://127.0.0.1:8000/gde-americas-hub/blog/
```

## Categories

Allowed categories (configured in `mkdocs.yml`):

- **Android**: Android development, Kotlin, Jetpack
- **Firebase**: Backend services, authentication, databases
- **Google Cloud**: GCP, Cloud Run, Kubernetes, DevOps
- **Flutter**: Cross-platform mobile development
- **AI & ML**: Generative AI, TensorFlow, ML Kit
- **Web**: Web development, PWAs, Web Vitals
- **Maps**: Google Maps Platform, location services
- **Ads**: AdMob, Google Ads, monetization
- **Workspace**: Apps Script, Workspace APIs
- **General**: Community updates, announcements

## Best Practices

1. **Use descriptive titles** - Clear, specific titles help readers find your content
2. **Add code examples** - Include working code snippets when relevant
3. **Include images** - Place images in `/docs/assets/images/blog/`
4. **Link to resources** - Reference official docs and related articles
5. **Proofread** - Check spelling and grammar before submitting
6. **Test locally** - Always preview your post before submitting a PR

## File Structure

```
docs/blog/
├── .authors.yml              # Author definitions
├── index.md                  # Blog homepage (customized)
├── HOW_TO_POST.md           # This guide
└── posts/
    └── 2026-01-23-welcome.md # Your posts go here
```

## Questions?

- Check the [Contributing Guidelines](../CONTRIBUTING.md)
- Open an issue on GitHub
- Ask in the community forums

---

Happy blogging! 📝
