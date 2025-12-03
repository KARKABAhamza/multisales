# GitHub CLI Usage Guide for MultiSales

This guide provides comprehensive examples of using GitHub CLI (`gh`) for the MultiSales project.

## Installation

### Linux/macOS
```bash
# Install via package manager
# Debian/Ubuntu
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh

# macOS
brew install gh
```

### Windows
```powershell
# Using winget
winget install --id GitHub.cli

# Using Chocolatey
choco install gh
```

### Verify Installation
```bash
gh --version
```

## Authentication

```bash
# Login to GitHub
gh auth login

# Check auth status
gh auth status

# Login with a token
gh auth login --with-token < token.txt
```

## Repository Operations

### Cloning and Forking
```bash
# Clone the repository
gh repo clone KARKABAhamza/multisales

# Fork and clone
gh repo fork KARKABAhamza/multisales --clone

# View repository info
gh repo view KARKABAhamza/multisales

# Open repository in browser
gh repo view --web
```

### Repository Settings
```bash
# Set default repository (run from repo directory)
gh repo set-default KARKABAhamza/multisales

# View repository topics
gh api repos/KARKABAhamza/multisales/topics
```

## Issue Management

### Creating and Managing Issues
```bash
# List all issues
gh issue list

# Filter by state
gh issue list --state open
gh issue list --state closed

# Filter by label
gh issue list --label bug
gh issue list --label enhancement

# Filter by assignee
gh issue list --assignee @me

# View issue details
gh issue view 42

# View issue in browser
gh issue view 42 --web

# Create a new issue
gh issue create --title "Add user authentication" --body "Need to implement Firebase auth"

# Create issue with labels
gh issue create --title "Fix login bug" --body "Users can't login" --label bug,priority-high

# Assign issue to yourself
gh issue develop 42 --checkout

# Close an issue
gh issue close 42 --comment "Fixed in PR #45"

# Reopen an issue
gh issue reopen 42
```

### Searching Issues
```bash
# Search issues with keywords
gh issue list --search "authentication"

# Search with filters
gh issue list --search "is:open label:bug"

# Search by author
gh issue list --author username
```

## Pull Request Workflow

### Creating Pull Requests
```bash
# Create PR with interactive prompts
gh pr create

# Create PR with title and body
gh pr create --title "feat: Add login screen" --body "Implements user authentication UI"

# Create PR from current branch to specific base
gh pr create --base main --head feature/login

# Create draft PR
gh pr create --draft

# Create PR and open in browser
gh pr create --web

# Link to an issue
gh pr create --title "Fix auth bug" --body "Closes #42"
```

### Managing Pull Requests
```bash
# List all PRs
gh pr list

# Filter PRs
gh pr list --state open
gh pr list --state merged
gh pr list --author @me
gh pr list --label bug

# View PR details
gh pr view 45

# View PR diff
gh pr diff 45

# View PR in browser
gh pr view 45 --web

# Checkout a PR locally
gh pr checkout 45

# Edit PR
gh pr edit 45 --title "New title" --body "New description"

# Mark as ready (remove draft status)
gh pr ready 45
```

### Reviewing Pull Requests
```bash
# Review a PR
gh pr review 45 --approve
gh pr review 45 --request-changes --body "Please fix the formatting"
gh pr review 45 --comment --body "Looks good overall, minor suggestion"

# List reviews on a PR
gh pr view 45 --json reviews

# Request review from specific users
gh pr edit 45 --add-reviewer username1,username2

# Request review from team
gh pr edit 45 --add-reviewer org/team-name
```

### Merging Pull Requests
```bash
# Merge PR (creates merge commit)
gh pr merge 45

# Squash merge
gh pr merge 45 --squash

# Rebase merge
gh pr merge 45 --rebase

# Auto-merge (merge when checks pass)
gh pr merge 45 --auto --squash

# Delete branch after merge
gh pr merge 45 --delete-branch
```

### PR Status and Checks
```bash
# View PR checks
gh pr checks

# View checks for specific PR
gh pr checks 45

# Watch PR checks in real-time
gh pr checks 45 --watch
```

## Workflow/Actions Management

### Viewing Workflows
```bash
# List workflow runs
gh run list

# Filter by workflow
gh run list --workflow "Flutter CI"

# Filter by branch
gh run list --branch main

# Filter by status
gh run list --status failure

# View specific run
gh run view 12345

# View run with log
gh run view 12345 --log

# View in browser
gh run view 12345 --web
```

### Managing Workflow Runs
```bash
# Watch a workflow run
gh run watch

# Watch specific run
gh run watch 12345

# Download artifacts from a run
gh run download 12345

# Download specific artifact
gh run download 12345 --name artifact-name

# Re-run a workflow
gh run rerun 12345

# Re-run only failed jobs
gh run rerun 12345 --failed

# Cancel a workflow run
gh run cancel 12345
```

### Triggering Workflows
```bash
# Trigger workflow_dispatch event
gh workflow run flutter-ci.yml

# Trigger with inputs
gh workflow run flutter-ci.yml --field environment=staging

# List available workflows
gh workflow list

# View workflow details
gh workflow view flutter-ci.yml

# Enable/disable workflow
gh workflow enable flutter-ci.yml
gh workflow disable flutter-ci.yml
```

## Release Management

### Creating Releases
```bash
# List releases
gh release list

# View release details
gh release view v1.0.0

# Create a new release
gh release create v1.0.0 --title "Version 1.0.0" --notes "Initial release"

# Create release with auto-generated notes
gh release create v1.0.0 --generate-notes

# Create pre-release
gh release create v1.0.0-beta --prerelease

# Upload assets to release
gh release create v1.0.0 --notes "Release notes" ./build/app.apk ./build/app.ipa

# Create draft release
gh release create v1.0.0 --draft
```

### Managing Releases
```bash
# Download release assets
gh release download v1.0.0

# Download specific asset
gh release download v1.0.0 --pattern "*.apk"

# Edit release
gh release edit v1.0.0 --notes "Updated release notes"

# Delete release
gh release delete v1.0.0

# Upload additional assets
gh release upload v1.0.0 ./new-file.zip
```

## Code Search and Navigation

### Searching Code
```bash
# Search code in repository
gh search code "firebase" --repo KARKABAhamza/multisales

# Search with language filter
gh search code "auth" --repo KARKABAhamza/multisales --language dart

# Search in specific path
gh search code "provider" --repo KARKABAhamza/multisales --path "lib/core/providers/"
```

### Searching Repositories
```bash
# Search repositories
gh search repos "multisales"

# Search with filters
gh search repos "flutter firebase" --language dart --stars ">100"
```

## Project Management

### Working with Projects (Beta)
```bash
# List projects
gh project list --owner KARKABAhamza

# View project
gh project view 1 --owner KARKABAhamza

# Create project item
gh project item-create 1 --owner KARKABAhamza --title "New task"
```

## Advanced Commands

### Using GitHub API
```bash
# Make API request
gh api repos/KARKABAhamza/multisales

# Get repository statistics
gh api repos/KARKABAhamza/multisales/stats/contributors

# List repository languages
gh api repos/KARKABAhamza/multisales/languages

# Get workflow runs via API
gh api repos/KARKABAhamza/multisales/actions/runs
```

### Aliases
```bash
# Create aliases for common commands
gh alias set pv 'pr view'
gh alias set pc 'pr create'
gh alias set il 'issue list'

# Use alias
gh pv 45

# List aliases
gh alias list

# Delete alias
gh alias delete pv
```

### Configuration
```bash
# Set default editor
gh config set editor vim

# Set default git protocol
gh config set git_protocol ssh

# View configuration
gh config list
```

## Common Workflows

### Daily Development Flow
```bash
# 1. Start new feature
./scripts/new-feature.sh user-profile 123

# 2. Make changes, commit
git add .
git commit -m "feat: add user profile screen"

# 3. Push and create PR
./scripts/quick-pr.sh

# 4. Check CI status
./scripts/check-ci.sh

# 5. Merge when approved
gh pr merge --squash --delete-branch
```

### Reviewing PRs
```bash
# 1. List open PRs
gh pr list

# 2. Checkout PR locally
gh pr checkout 45

# 3. Test changes
flutter test

# 4. Leave review
gh pr review 45 --approve --body "LGTM! Nice work 🚀"
```

### Debugging CI Failures
```bash
# 1. Check failed runs
gh run list --status failure

# 2. View failure logs
gh run view <run-id> --log

# 3. Download artifacts for analysis
gh run download <run-id>

# 4. Re-run after fix
gh run rerun <run-id>
```

## Tips and Best Practices

1. **Set default repository**: Run `gh repo set-default` in your local repo to avoid typing repo name repeatedly

2. **Use aliases**: Create shortcuts for frequently used commands

3. **Browser integration**: Add `--web` flag to open items in browser for complex operations

4. **JSON output**: Use `--json` flag with `jq` for advanced filtering:
   ```bash
   gh pr list --json number,title,author | jq '.[] | select(.author.login=="username")'
   ```

5. **Combine with git**: GitHub CLI works alongside git commands:
   ```bash
   git commit -m "fix: typo" && git push && gh pr create
   ```

6. **Watch workflows**: Use `gh run watch` during development to see CI results in real-time

## Troubleshooting

### Authentication Issues
```bash
# Re-authenticate
gh auth logout
gh auth login

# Check auth status
gh auth status

# Use different account
gh auth login --hostname github.com
```

### Command Not Found
```bash
# Refresh PATH
source ~/.bashrc  # or ~/.zshrc

# Verify installation
which gh
gh --version
```

### Rate Limiting
```bash
# Check rate limit status
gh api rate_limit
```

## Resources

- [Official GitHub CLI Documentation](https://cli.github.com/manual/)
- [GitHub CLI Repository](https://github.com/cli/cli)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [Contributing Guide](CONTRIBUTING.md)

---

For project-specific workflows, see [CONTRIBUTING.md](CONTRIBUTING.md)
