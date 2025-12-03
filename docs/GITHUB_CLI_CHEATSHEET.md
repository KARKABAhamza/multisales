# GitHub CLI Quick Reference for MultiSales

## One-Line Commands for Daily Development

### Quick Setup
```bash
# Fork, clone, and set up in one go
gh repo fork KARKABAhamza/multisales --clone && cd multisales && flutter pub get
```

### Daily Workflow
```bash
# Start work on an issue
gh issue develop 42 --checkout

# Quick commit and PR
git add . && git commit -m "feat: add feature" && git push && gh pr create

# Check if CI passed
gh pr checks

# Approve and merge
gh pr review --approve && gh pr merge --squash --delete-branch
```

### Issue Management
```bash
# Create bug report
gh issue create --title "Bug: login fails" --label bug --body "Steps: 1. Open app 2. Click login"

# Assign to yourself
gh issue develop 42

# Close with reference
gh issue close 42 --comment "Fixed in PR #45"
```

### PR Operations
```bash
# Create PR linking to issue
gh pr create --title "Fix login" --body "Closes #42"

# Review PR
gh pr review 45 --approve --body "LGTM! 🚀"
gh pr review 45 --request-changes --body "Please fix tests"

# Merge PR
gh pr merge 45 --squash --delete-branch
```

### Workflow Management
```bash
# Watch CI in real-time
gh run watch

# Re-run failed jobs
gh run rerun --failed

# Download build artifacts
gh run download
```

### Code Review Flow
```bash
# Get PR for review
gh pr checkout 45

# Test locally
flutter test

# Leave review
gh pr review --approve

# Or request changes
gh pr review --request-changes --body "See inline comments"
```

### Release Management
```bash
# Create release
gh release create v1.0.0 --generate-notes

# Upload assets
gh release upload v1.0.0 ./build/app.apk ./build/app.ipa
```

## Useful Aliases

Add these to your shell config:
```bash
# Add to ~/.bashrc or ~/.zshrc
alias ghprc='gh pr create'
alias ghprv='gh pr view'
alias ghprl='gh pr list'
alias ghil='gh issue list'
alias ghrw='gh run watch'
alias ghrl='gh run list'
```

Or create GitHub CLI aliases:
```bash
gh alias set prc 'pr create'
gh alias set prv 'pr view'
gh alias set prl 'pr list'
gh alias set il 'issue list'
gh alias set rw 'run watch'
gh alias set rl 'run list'
```

## Common Scenarios

### Scenario: Fix a bug reported in an issue
```bash
gh issue view 42                          # Read the issue
gh issue develop 42 --checkout            # Create branch
# ... make changes ...
git add . && git commit -m "fix: resolve login bug"
git push
gh pr create --body "Closes #42"          # Link to issue
gh pr checks --watch                      # Watch CI
```

### Scenario: Review someone's PR
```bash
gh pr list                                # See open PRs
gh pr view 45                             # Read details
gh pr checkout 45                         # Test locally
flutter test                              # Verify tests
gh pr review 45 --approve                 # Approve if good
```

### Scenario: Create a new feature
```bash
./scripts/new-feature.sh auth-system 123  # Create branch
# ... implement feature ...
./scripts/quick-pr.sh                     # Create PR
./scripts/check-ci.sh                     # Monitor CI
```

### Scenario: CI failed
```bash
gh run list --status failure              # Find failed run
gh run view <id> --log                    # Check logs
# ... fix issue ...
git push                                  # Will trigger rerun
gh run watch                              # Watch new run
```

## Advanced Tips

### JSON + jq for power users
```bash
# List PRs by you that are open
gh pr list --author @me --json number,title | jq '.[] | "\(.number): \(.title)"'

# Find failed workflow runs (recent, limit 10 for cross-platform compatibility)
gh run list --status failure --limit 10 --json databaseId,name,conclusion

# Get PR review status
gh pr view 45 --json reviewDecision,reviews | jq '.reviewDecision'
```

### Bulk Operations
```bash
# Close multiple stale issues
gh issue list --state open --label stale --json number --jq '.[].number' | xargs -I {} gh issue close {}

# Re-run all failed workflows
gh run list --status failure --json databaseId --jq '.[].databaseId' | xargs -I {} gh run rerun {}
```

### Integration with other tools
```bash
# Open PR in VS Code
gh pr checkout 45 && code .

# Run lint before creating PR
flutter analyze && git push && gh pr create

# Auto-approve PRs from Dependabot (with caution!)
gh pr list --author app/dependabot --json number --jq '.[].number' | xargs -I {} gh pr review {} --approve
```

## Environment Variables

```bash
# Set these in your ~/.bashrc or ~/.zshrc

# Default repository
export GH_REPO="KARKABAhamza/multisales"

# Use SSH for git operations
export GH_PROTOCOL="ssh"

# Custom editor for PR descriptions
export GH_EDITOR="code --wait"

# Pager for output
export GH_PAGER="less -R"
```

## Troubleshooting One-Liners

```bash
# Check auth
gh auth status

# Re-login
gh auth logout && gh auth login

# Refresh repo cache
gh repo sync

# Check rate limit
gh api rate_limit | jq '.rate'

# Verify webhook deliveries
gh api repos/KARKABAhamza/multisales/hooks
```

## Helpful Scripts

### Wait for CI to complete
```bash
#!/bin/bash
# wait-for-ci.sh
while true; do
  STATUS=$(gh pr checks --json state --jq '.[].state' | sort -u)
  if echo "$STATUS" | grep -q "PENDING"; then
    echo "Waiting for CI..."
    sleep 30
  else
    echo "CI complete!"
    gh pr checks
    break
  fi
done
```

### Auto-merge when approved
```bash
#!/bin/bash
# auto-merge.sh <pr-number>
gh pr view $1 --json reviewDecision --jq '.reviewDecision' | \
  grep -q "APPROVED" && gh pr merge $1 --squash --delete-branch
```

## Resources

- Full guide: [docs/GITHUB_CLI_GUIDE.md](GITHUB_CLI_GUIDE.md)
- Contributing: [../CONTRIBUTING.md](../CONTRIBUTING.md)
- Official docs: https://cli.github.com/manual/

---

💡 **Pro Tip**: Run `gh help` for any command to see all available options!
