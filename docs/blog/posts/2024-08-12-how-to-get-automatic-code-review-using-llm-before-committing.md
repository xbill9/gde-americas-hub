---
draft: false
date: 2024-08-12
authors:
  - gelopfalcon
categories:
  - Google Cloud
  - AI & ML
---

# How to Get Automatic Code Review Using LLM Before Committing

Traditional code reviews can be time-consuming and prone to human error. To streamline this process...


Traditional code reviews can be time-consuming and prone to human error. To streamline this process and enhance code quality, developers are increasingly turning to AI-powered solutions. In this blog post, you'll explore how to leverage Code Llama, a cutting-edge AI model for code analysis, in conjunction with Docker to create an efficient and automated code review workflow. By integrating Code Llama into your local development environment, you can catch potential issues early in the development cycle, reduce the burden on human reviewers, and ultimately deliver higher-quality code. This guide is designed for developers of all levels who want to improve their coding practices.

<!-- more -->

Currently, developers spend a significant amount of time reviewing code written by their peers, which can become a bottleneck for software delivery. Sometimes, code reviews are not conducted promptly, delaying the continuous integration and continuous deployment (CI/CD) process. Moreover, reviewing a Pull Request (PR) or a Merge Request (MR) is not always easy, as it requires a well-defined set of rules, as well as knowledge and expertise in the specific technology.

## Challenges in Traditional Code Review Processes

- Lack of Consistency: Code reviews can be inconsistent, as different reviewers may have different standards and approaches.
- Review Delays: Developers may take time to review code due to heavy workloads, impacting delivery speed.
- Lack of Experience: Not all reviewers may have the same level of knowledge or expertise, leading to important omissions or insufficient problem detection.
- Performance Bottlenecks: The manual nature of code reviews can lead to delays, especially when multiple reviews are needed before a merge.

## How Can AI Help?

Artificial Intelligence (AI) can provide a preliminary code review before a commit, which can alleviate many of these problems. Here are some ways AI can help:

- Automatic Code Analysis: AI can perform static code analysis to identify common issues such as syntax errors, style problems, security vulnerabilities, and deprecated code patterns.
Tools like Codacy, SonarQube, and DeepCode are already using advanced AI techniques to analyze code and provide feedback.

- Improvement Recommendations: AI can suggest code improvements based on best practices and industry standards.
Using deep learning models, AI can recommend changes to improve code efficiency, readability, and maintainability.

- Anomaly Detection: AI can learn from previous code patterns and detect anomalies that might indicate potential problems.
This is especially useful for identifying code that doesn't align with the team's coding style and practices.

- Facilitating Peer Review: By providing a preliminary review, AI can reduce the workload for human reviewers, allowing them to focus on more complex and contextual aspects of the code.
AI can highlight areas that need special attention, making the review process more efficient.

## Example of AI in Code Review

Let's assume we're using an AI tool to review our code before committing. Here's an example of how it might work:

### Integration with Version Control System

When attempting to commit, the AI tool activates and automatically analyzes the code.
The tool provides a detailed report of any issues found and suggestions for improvements.

### Contextual Analysis
The tool analyzes not only the current code but also the commit history and project context to offer more accurate recommendations.
For instance, it may suggest changes to maintain consistency with existing code or highlight areas where similar errors have been introduced in the past.

### Report and Recommended Actions
The generated report may include refactoring suggestions, vulnerability detection, style recommendations, and more.
The developer can review these suggestions and make the necessary changes before proceeding with the commit.

##LLMs and Codellama

Large Language Models (LLMs) are advanced machine learning models trained on vast amounts of text data. They have the ability to understand, generate, and interact with human language, making them powerful tools for a variety of applications, including code analysis. LLMs are capable of:

- Syntax and Semantics Understanding: LLMs can parse and understand the structure and meaning of code, which allows them to identify syntax errors, suggest improvements, and ensure that the code adheres to best practices.

- Code Generation: LLMs can generate new code snippets based on natural language descriptions or partial code inputs. This capability is useful for automating repetitive coding tasks, prototyping, and even exploring new programming paradigms.

- Bug Detection and Correction: By understanding the intent behind code, LLMs can identify potential bugs or issues and suggest corrections. They can detect common programming mistakes, such as off-by-one errors, and provide recommendations for resolving them.

- Code Refactoring: LLMs can suggest ways to improve code readability, maintainability, and efficiency. This includes recommending changes to variable names, restructuring code blocks, and optimizing algorithms.

Code Llama is a specialized version of an LLM, fine-tuned specifically for understanding and generating code. As an AI model trained on a diverse set of programming languages and coding tasks, Code Llama excels in:

- Language-Agnostic Code Understanding: Code Llama can work with multiple programming languages, providing analysis and suggestions regardless of the specific syntax or semantics.

- Contextual Code Suggestions: It offers context-aware recommendations, making it an invaluable tool for suggesting code completions, improvements, and bug fixes that are relevant to the specific programming scenario.

- Detailed Code Reviews: Code Llama can conduct in-depth code reviews, pointing out areas for optimization, highlighting code smells, and suggesting best practices. It can generate comprehensive feedback that helps maintain high code quality.

- Custom Prompt Responses: By using custom prompts, developers can guide Code Llama to focus on specific aspects of the code, such as security vulnerabilities, performance enhancements, or stylistic consistency.

- Efficient Code Documentation: Code Llama can automatically generate documentation for codebases, including function descriptions, parameter explanations, and usage examples, streamlining the documentation process.

In summary, LLMs, and specifically Code Llama, provide a powerful suite of tools for enhancing the software development process. They not only assist in writing and reviewing code but also help in ensuring code quality, consistency, and maintainability across projects.

## Docker's role

Docker allows developers to create isolated, consistent environments for code testing by using containers. These containers encapsulate an application's code, dependencies, and runtime environment, ensuring that tests are run in the same conditions regardless of the underlying host system. This isolation eliminates the "works on my machine" problem and makes it easier to manage and replicate testing environments.

### Benefits of Combining Docker and Code Llama

Combining Docker with Code Llama offers several benefits:

- Consistency: Docker ensures that Code Llama runs in a consistent environment, eliminating issues related to different configurations or dependencies.
- Scalability: Docker makes it easy to scale the use of Code Llama across different projects or teams by simply sharing a container image.
- Automation: By using Docker, you can automate the setup and execution of code reviews, integrating Code Llama seamlessly into your CI/CD pipeline.

### Integrating Code Llama with Code Editors or IDEs

To integrate Code Llama into your preferred code editor or IDE, you can set up a language server or use a plugin that interfaces with Code Llama's API. Many editors like VSCode, PyCharm, or Sublime Text support external tools through extensions or plugins. You can configure these tools to send code to Code Llama for analysis, review, or refactoring.

## Architecture

This project sets up "llama" to run via a Docker container and integrates a "pre-commit" hook. Whenever someone modifies or commits a Python file, the hook triggers a code review using the codellama model. The review is then saved into a "review.md" file, allowing developers to compare their code against the review feedback. It's important to note that AI models can take varying amounts of time to process, depending on the computer's CPU and memory. In my experience, the review process typically takes between 2 to 5 minutes, which is comparable to the time a human might spend conducting a thorough review.


![Image description](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gzly16ozdkn6ap9y911e.png)

## Prerequisites

- Download and install the latest version of Docker
- Have git tool installed in the computer.


## Getting Started

### Step 1. Clone the repository

`git clone https://github.com/dockersamples/codellama-python`

### Step 2: Start the Ollama container
Change the directory to codellama-python and run the following command:
`sh start-ollama.sh`

### Step 3. Create the following file .git/hooks/pre-commit
Copy the content below and put it in the right directory:
```
  #!/bin/sh

# Find all modified Python files
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.py$')

if [ -z "$FILES" ]; then
  echo "No Python files to check."
  exit 0
fi

# Clean the review.md file before starting
> review.md

# Review each modified Python file
for FILE in $FILES; do
  content=$(cat "$FILE")
  prompt="\n Review this code, provide suggestions for improvement, coding best practices, improve readability, and maintainability. Remove any code smells and anti-patterns. Provide code examples for your suggestion. Respond in markdown format. If the file does not have any code or does not need any changes, say 'No changes needed'."
  
  # get model review suggestions
  suggestions=$(docker exec ollama ollama run codellama "Code: $content $prompt")
  
  # Añadir el prefijo del nombre del archivo y las sugerencias al archivo review.md
  echo "## Review for $FILE" >> review.md
  echo "" >> review.md
  echo "$suggestions" >> review.md
  echo "" >> review.md
  echo "---" >> review.md
  echo "" >> review.md
done

echo "All Python files were applied the code review."
exit 0
```

The provided shell script automates the code review process by finding all modified Python files, cleaning the review.md file, and iterating through each file to generate suggestions using the Ollama model. The suggestions are then appended to the review.md file, providing developers with immediate feedback on their code changes.

### Step 4. Proper permission to execute
`chmod +x .git/hooks/pre-commit`

### Step 5. Add or modify the python files
Go ahead and make changes to the Python files.

### Step 6. Apply the changes
```
git add .
git commit -m "Test code review in pre-commit hook"
```

### Results
Apply a commit message and wait for the review. You might see something like

pulling manifest
pulling 3a43f93b78ec... 100% ▕████████████████▏ 3.8 GB
pulling 8c17c2ebb0ea...   0% ▕                ▏    0 B
pulling 590d74a5569b...   0% ▕                ▏    0 B
pulling 2e0493f67d0c... 100% ▕████████████████▏   59 B
pulling 7f6a57943a88... 100% ▕████████████████▏  120 B
pulling 316526ac7323...   0% ▕                ▏    0 B
verifying sha256 digest
writing manifest
removing any unused layers
success

It might take some minutes, but the final result is a review.md with all suggestions.

# Conclusion

Integrating Docker and Code Llama into your development workflow offers a seamless and powerful way to automate code reviews. By triggering Code Llama on every commit, developers can ensure that their code is peer-reviewed instantly, catching potential issues early in the process. This not only enhances code quality but also fosters a culture of continuous improvement and collaboration. As development teams increasingly adopt AI-driven tools, the combination of Docker’s isolated environments and Code Llama’s intelligent insights becomes an invaluable asset, enabling developers to focus on innovation while maintaining robust code standards. Give it a try in your next project, and see the difference it makes!

---

*Originally published at [dev.to](https://dev.to/docker/how-to-get-automatic-code-review-using-llm-before-committing-3nkj)*
