#!/bin/bash
# Script to sync your fork with the upstream repository

set -e

echo "Syncing fork with upstream..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Fetch from upstream (origin)
echo "Fetching from origin..."
git fetch origin

# Switch to main
echo "Switching to main branch..."
git checkout main

# Pull latest changes
echo "Pulling latest changes from origin/main..."
git pull origin main

# Switch back to original branch if it wasn't main
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Switching back to ${CURRENT_BRANCH}..."
  git checkout "${CURRENT_BRANCH}"
  
  # Offer to rebase on main
  read -p "Do you want to rebase ${CURRENT_BRANCH} on main? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebasing ${CURRENT_BRANCH} on main..."
    git rebase main
    echo "✅ Rebase complete"
  fi
fi

echo "✅ Fork synced successfully"
