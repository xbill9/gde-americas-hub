author: Gerardo Lopez Falcon
summary: Learn how to create interactive codelabs for the GDE Americas Hub
id: how-to-create-a-codelab
categories: meta,tutorial,contributing
environments: Web
status: Published
feedback link: https://github.com/gde-americas/gde-americas-hub/issues
analytics account: 0

# How to Create a Codelab

## Overview
Duration: 0:02:00

### What You'll Learn

In this codelab, you'll learn how to create your own interactive codelabs for the GDE Americas Hub using Google's `claat` tool.

By the end of this tutorial, you'll be able to:

- ✅ Install and set up the claat tool
- ✅ Clone and configure the GDE Americas Hub repository
- ✅ Write a codelab in markdown format
- ✅ **Use our automated script to export and publish** (the easy way!)
- ✅ Preview your codelab locally
- ✅ Submit your codelab via Pull Request

### The Workflow is Simple

1. Write your codelab in markdown
2. Run one command: `./scripts/export-codelab.sh your-file.md category`
3. Preview and test
4. Commit and create PR

**That's it!** Our script handles all the heavy lifting.

### Prerequisites

Before you begin, make sure you have:

- Basic knowledge of Markdown
- Git installed on your machine
- A GitHub account
- A text editor (VS Code, Sublime, etc.)

Positive
: **Tip:** This entire codelab was created using the same process you're about to learn!

## Install Claat Tool
Duration: 0:05:00

### What is Claat?

**Claat** (Codelabs as a Thing) is a command-line tool that converts markdown files into interactive HTML tutorials. It's the same tool Google uses for their official codelabs.

### Installation Options

#### Option 1: Download Pre-built Binary (Recommended)

1. Visit the [Claat Releases page](https://github.com/googlecodelabs/tools/releases)

2. Download the binary for your operating system:
   - **macOS**: `claat-darwin-amd64` or `claat-darwin-arm64` (Apple Silicon)
   - **Linux**: `claat-linux-amd64`
   - **Windows**: `claat-windows-amd64.exe`

3. Rename and make it executable:

   **macOS/Linux:**
   ```bash
   # Rename the binary
   mv claat-darwin-amd64 claat

   # Make it executable
   chmod +x claat

   # Move to PATH (optional)
   sudo mv claat /usr/local/bin/
   ```

   **Windows:**
   ```bash
   # Rename to claat.exe and add to PATH
   ```

4. Verify installation:
   ```bash
   claat version
   ```

#### Option 2: Build from Source

If you have Go installed:

```bash
go install github.com/googlecodelabs/tools/claat@latest
```

Negative
: **Note:** Building from source requires Go 1.16 or higher and takes longer than downloading the pre-built binary.

### Verify Installation

Run this command to confirm claat is installed:

```bash
claat -h
```

You should see the help menu with available commands.

Positive
: **Success!** You now have claat installed and ready to use.

## Clone the GDE Americas Hub Repo
Duration: 0:05:00

### Fork the Repository

1. Go to the [GDE Americas Hub repository](https://github.com/gde-americas/gde-americas-hub)

2. Click the **Fork** button in the top-right corner

3. This creates a copy of the repo in your GitHub account

### Clone Your Fork

Clone your forked repository to your local machine:

```bash
# Replace YOUR_USERNAME with your GitHub username
git clone https://github.com/YOUR_USERNAME/gde-americas-hub.git

# Navigate into the directory
cd gde-americas-hub
```

### Set Up Python Environment

The hub uses MkDocs for the website:

```bash
# Create virtual environment
python3 -m venv .venv

# Activate it
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Create a Branch

Create a new branch for your codelab:

```bash
git checkout -b codelab/my-awesome-tutorial
```

Positive
: **Tip:** Use descriptive branch names like `codelab/android-jetpack-compose` or `codelab/firebase-authentication`.

## Understand Codelab Structure
Duration: 0:03:00

### Directory Structure

Codelabs in the hub are organized as follows:

```
docs/codelabs/
├── source/                    # Source markdown files
│   ├── how-to-create-a-codelab.md
│   └── your-codelab.md       # Your source file
├── android/
│   └── your-codelab/         # Generated HTML (from claat)
│       ├── index.html
│       └── codelab.json
├── firebase/
└── cloud/
```

### Codelab Metadata

Every codelab starts with metadata at the top of the markdown file:

```markdown
author: Your Name
summary: Brief description of what you'll learn
id: unique-codelab-identifier
categories: android,kotlin,beginner
environments: Web
status: Published
feedback link: https://github.com/gde-americas/gde-americas-hub/issues
analytics account: 0
```

**Key Fields:**

- **author**: Your name (as it appears in `.authors.yml`)
- **summary**: One-sentence description
- **id**: Unique identifier (lowercase, hyphens, no spaces)
- **categories**: Comma-separated list (android, firebase, cloud, etc.)
- **status**: `Published`, `Draft`, or `Hidden`

### Section Format

Sections use `##` (H2) headers with optional duration:

```markdown
## Step Title
Duration: 0:05:00

Your content here...
```

### Special Callouts

**Positive callouts** (green):
```markdown
Positive
: This is a helpful tip!
```

**Negative callouts** (yellow):
```markdown
Negative
: This is a warning or important note.
```

## Write Your First Codelab
Duration: 0:10:00

### Create the Source File

Create a new markdown file in `docs/codelabs/source/`:

```bash
touch docs/codelabs/source/my-first-codelab.md
```

### Basic Template Structure

Every codelab should follow this structure. Start with the metadata header:

```markdown
author: Your Name
summary: Your codelab summary
id: my-first-codelab
categories: android
environments: Web
status: Draft
feedback link: https://github.com/gde-americas/gde-americas-hub/issues
```

Then add your main title and overview section:

```markdown
# My First Codelab

Overview section here (use double hash for sections)
Duration: 0:02:00
```

Add your content sections with durations:

```markdown
Your Section Title Here
Duration: 0:05:00

Instructions and content...
```

Include code examples:

```kotlin
fun hello() {
    println("Hello, Codelab!")
}
```

End with a conclusion section summarizing what was learned.

### Writing Tips

1. **Use clear titles** - Each section should have a descriptive title
2. **Add durations** - Help users estimate time commitment
3. **Include code blocks** - Use triple backticks with language
4. **Add images** - Use `![alt text](image-url)` format
5. **Use callouts** - Highlight important information

Positive
: **Pro Tip:** Keep sections between 5-10 minutes for better pacing.

### Example Code Block

```kotlin
// Android example
class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
```

## Export Your Codelab
Duration: 0:03:00

### Use the Helper Script (Recommended!)

The easiest way to export your codelab is using our helper script:

```bash
# From the repository root
./scripts/export-codelab.sh docs/codelabs/source/my-first-codelab.md android
```

**That's it!** The script automatically:

✅ Exports your markdown using claat
✅ Moves the source file to `docs/codelabs/source/`
✅ Moves generated HTML to the correct category folder
✅ **Adds your codelab to the category index page**
✅ Shows you next steps

### What the Script Does

```
ℹ Exporting codelab...
ℹ   Source: docs/codelabs/source/my-first-codelab.md
ℹ   Category: android

ℹ Running claat export...
ok    my-first-codelab
✓ Codelab generated: my-first-codelab
✓ Moved to: docs/codelabs/android/my-first-codelab/
✓ Added to: docs/codelabs/android/index.md

🎉 Codelab exported successfully!
```

### Manual Export (Alternative)

If you prefer to export manually:

```bash
cd docs/codelabs/source
claat export my-first-codelab.md
mv my-first-codelab ../android/
```

Then manually update `docs/codelabs/android/index.md` to add your codelab.

Positive
: **Pro Tip:** The script saves you time and prevents errors. Use it!

## Preview Locally
Duration: 0:03:00

### Preview the Full Site (Recommended)

```bash
# From the repo root
mkdocs serve
```

Then visit your codelab:
- Homepage: `http://127.0.0.1:8000/gde-americas-hub/`
- Your category: `http://127.0.0.1:8000/gde-americas-hub/codelabs/android/`
- Your codelab will be listed there! ✨

### Quick Preview (Just the Codelab)

```bash
cd docs/codelabs/android/my-first-codelab
python3 -m http.server 8080
```

Visit: `http://127.0.0.1:8080/`

### Test Checklist

Go through your codelab as a user would:

- ✅ All links work correctly
- ✅ Code examples are accurate and tested
- ✅ Images display properly
- ✅ Navigation between steps works
- ✅ Durations match actual time
- ✅ No typos or grammar errors

Positive
: **Your codelab is already in the UI!** Thanks to the export script, it's automatically added to the category page.

## Verify It's in the UI
Duration: 0:02:00

### Automatic Addition! 🎉

Good news! **The export script already added your codelab** to the category index automatically.

### Check the Category Page

When you run `mkdocs serve`, navigate to:

```
http://127.0.0.1:8000/gde-americas-hub/codelabs/android/
```

You should see your codelab listed with:
- Title
- Duration and difficulty
- Description
- "Start Codelab" button

### What Happened Behind the Scenes

The script extracted metadata from `codelab.json` and added an entry like this:

```markdown
### [My First Codelab](my-first-codelab/)
**Duration**: ~24 minutes | **Difficulty**: Beginner

Brief description of what users will learn.

[:octicons-arrow-right-24: Start Codelab](my-first-codelab/){ .md-button }
```

Positive
: **No manual work needed!** The script handles everything automatically.

## Submit Your Codelab
Duration: 0:05:00

### Commit Your Changes

```bash
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "Add codelab: My First Codelab

- Created Android codelab about [topic]
- Covers [concepts]
- Target audience: [beginners/intermediate/advanced]"

# Push to your fork
git push origin codelab/my-awesome-tutorial
```

### Create Pull Request

1. Go to your fork on GitHub
2. Click **"Compare & pull request"**
3. Fill in the PR template:
   - **Title**: `Add codelab: My First Codelab`
   - **Description**:
     - What the codelab teaches
     - Target audience
     - Prerequisites
     - Related issues (if any)

4. Click **"Create pull request"**

### PR Checklist

Before submitting, ensure:

- ✅ Source `.md` file is in `docs/codelabs/source/`
- ✅ Generated HTML is in correct category folder
- ✅ Category index page is updated
- ✅ All links and images work
- ✅ Code examples are tested
- ✅ No typos or grammar errors
- ✅ Follows [Contributing Guidelines](https://github.com/gde-americas/gde-americas-hub/blob/main/CONTRIBUTING.md)

### Wait for Review

A reviewer will:

1. Test your codelab
2. Check for quality and accuracy
3. Suggest improvements (if needed)
4. Approve and merge

Positive
: **Tip:** Be responsive to feedback! Most codelabs go through 1-2 revision rounds.

## Conclusion
Duration: 0:02:00

### Congratulations! 🎉

You now know how to create and publish codelabs for the GDE Americas Hub!

### What You Learned

- ✅ Installing and using the claat tool
- ✅ Writing codelabs in markdown format
- ✅ **Using the export script to automate everything**
- ✅ Previewing codelabs locally
- ✅ Contributing to the GDE Americas Hub
- ✅ Following the PR process

### The Magic Command

Remember, creating a codelab is now as simple as:

```bash
./scripts/export-codelab.sh docs/codelabs/source/your-codelab.md category
```

That's it! Everything else is automated. ✨

### Next Steps

**Create Your First Codelab!** Ideas:

- Tutorial on a technology you know well
- Deep dive into an advanced topic
- Getting started guide for beginners
- Best practices and patterns
- Real-world implementation examples

### Resources

- [Google Codelabs Tools](https://github.com/googlecodelabs/tools)
- [Sample Codelab Markdown](https://github.com/googlecodelabs/tools/blob/main/sample/codelab.md)
- [GDE Americas Contributing Guide](https://github.com/gde-americas/gde-americas-hub/blob/main/CONTRIBUTING.md)
- [Codelab Formatting Guide](https://github.com/googlecodelabs/tools/tree/master/claat/parser/md)

### Join the Community

- GitHub: [gde-americas/gde-americas-hub](https://github.com/gde-americas/gde-americas-hub)
- Create issues for questions or suggestions
- Join community discussions

Positive
: **Thank you** for contributing to the GDE Americas community! 🌎

Happy coding!
