#!/bin/bash
# Script to quickly create a PR for the current branch

set -e

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Check if on main
if [ "$CURRENT_BRANCH" = "main" ]; then
  echo "Error: Cannot create PR from main branch"
  exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "Warning: You have uncommitted changes"
  read -p "Do you want to commit them now? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    read -p "Commit message: " COMMIT_MSG
    git commit -m "$COMMIT_MSG"
  else
    echo "Please commit your changes before creating a PR"
    exit 1
  fi
fi

# Push current branch
echo "Pushing ${CURRENT_BRANCH} to origin..."
git push origin "${CURRENT_BRANCH}" --set-upstream

# Check if PR already exists
if gh pr view > /dev/null 2>&1; then
  echo "PR already exists for this branch:"
  gh pr view
  read -p "Do you want to open it in browser? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh pr view --web
  fi
  exit 0
fi

# Extract issue number from branch name if present
ISSUE_NUMBER=$(echo "$CURRENT_BRANCH" | grep -oE '[0-9]+' | head -n1 || echo "")

# Create PR
echo "Creating pull request..."

if [ -n "$ISSUE_NUMBER" ]; then
  # If issue number found, use it to populate PR
  ISSUE_TITLE=$(gh issue view "$ISSUE_NUMBER" --json title --jq '.title' 2>/dev/null || echo "")
  if [ -n "$ISSUE_TITLE" ]; then
    gh pr create --title "$ISSUE_TITLE" --body "Closes #${ISSUE_NUMBER}" --web
  else
    gh pr create --web
  fi
else
  # Interactive PR creation
  gh pr create --web
fi

echo "✅ Pull request created successfully"
