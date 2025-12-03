#!/bin/bash
# Script to check CI status for current branch

set -e

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

echo "Checking CI status for branch: ${CURRENT_BRANCH}"
echo ""

# Check if there's a PR for current branch
if gh pr view > /dev/null 2>&1; then
  echo "=== Pull Request Status ==="
  gh pr view
  echo ""
  echo "=== CI Checks ==="
  gh pr checks
  echo ""
  
  # Ask if user wants to watch the workflow
  read -p "Do you want to watch the latest workflow run? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh run watch
  fi
else
  echo "No PR found for current branch"
  echo ""
  echo "=== Recent Workflow Runs ==="
  gh run list --branch "${CURRENT_BRANCH}" --limit 5
  echo ""
  echo "Tip: Create a PR with: gh pr create"
fi
