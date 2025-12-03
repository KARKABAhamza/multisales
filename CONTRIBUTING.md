# Contributing to MultiSales

Thank you for your interest in contributing to MultiSales! This guide will help you get started with the development workflow using GitHub CLI.

## Prerequisites

- Flutter SDK (latest stable)
- Firebase CLI
- GitHub CLI (`gh`)
- Git
- Android Studio / VS Code with Flutter plugin

## Getting Started

### 1. Fork and Clone the Repository

Using GitHub CLI:
```bash
# Fork the repository
gh repo fork KARKABAhamza/multisales --clone

# Or clone if you already have access
gh repo clone KARKABAhamza/multisales
cd multisales
```

### 2. Set Up Development Environment

```bash
# Install dependencies
flutter pub get

# Configure Firebase
flutterfire configure --project=multisales-18e57

# Verify setup
flutter doctor
```

## Development Workflow with GitHub CLI

### Working on Issues

```bash
# View open issues
gh issue list

# View a specific issue
gh issue view <issue-number>

# Create a new branch for your work
git checkout -b feature/issue-<number>-description

# Assign yourself to an issue
gh issue develop <issue-number> --checkout
```

### Creating Pull Requests

```bash
# Commit your changes
git add .
git commit -m "feat: your descriptive commit message"

# Push to your fork
git push origin <branch-name>

# Create a pull request
gh pr create --title "feat: Your PR Title" --body "Description of changes"

# Or create with interactive prompts
gh pr create --web
```

### Reviewing Pull Requests

```bash
# List all PRs
gh pr list

# View a specific PR
gh pr view <pr-number>

# Checkout a PR locally for testing
gh pr checkout <pr-number>

# Add a review
gh pr review <pr-number> --approve
gh pr review <pr-number> --request-changes --body "Please fix..."
gh pr review <pr-number> --comment --body "Nice work!"

# Merge a PR
gh pr merge <pr-number> --squash
```

### Working with CI/CD

```bash
# View workflow runs
gh run list

# Watch a workflow run in real-time
gh run watch

# View details of a specific run
gh run view <run-id>

# Re-run failed jobs
gh run rerun <run-id> --failed

# View logs
gh run view <run-id> --log
```

## Code Style and Standards

### Flutter Code

- Follow the [Flutter style guide](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#style)
- Run `flutter analyze` before committing
- Run `flutter format .` to format code
- Ensure all tests pass: `flutter test`

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View test results in browser
gh pr checks
```

## Useful GitHub CLI Commands

### Repository Management

```bash
# View repository info
gh repo view

# Clone with all branches
gh repo clone KARKABAhamza/multisales -- --recurse-submodules

# Open repository in browser
gh repo view --web
```

### Release Management

```bash
# List releases
gh release list

# Create a new release
gh release create v1.0.0 --title "Version 1.0.0" --notes "Release notes"

# Download release assets
gh release download v1.0.0
```

### Issue Management

```bash
# Create an issue
gh issue create --title "Bug: Description" --body "Details..." --label bug

# Close an issue
gh issue close <issue-number>

# Reopen an issue
gh issue reopen <issue-number>
```

## Quick Reference Scripts

We've included helper scripts in the `scripts/` directory:

```bash
# Create and switch to a new feature branch
./scripts/new-feature.sh <feature-name>

# Sync your fork with upstream
./scripts/sync-fork.sh

# Quick PR creation for current branch
./scripts/quick-pr.sh
```

## Getting Help

```bash
# GitHub CLI help
gh help

# Specific command help
gh pr help
gh issue help
gh workflow help

# Open project discussions
gh repo view --web
```

## Code Review Process

1. **Create PR** using `gh pr create`
2. **Request Reviews** from maintainers
3. **Address Feedback** - push additional commits
4. **CI Checks** must pass (Flutter CI, Codacy, Trivy)
5. **Approval** from at least one maintainer
6. **Merge** via `gh pr merge` or web interface

## Additional Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Project Architecture](docs/ARCHITECTURE.md)

## Questions?

- Check existing issues: `gh issue list`
- Start a discussion: `gh repo view --web` → Discussions tab
- Contact maintainers via PR comments

---

Thank you for contributing to MultiSales! 🚀
