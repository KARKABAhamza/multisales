#!/bin/bash
# Script to create a new feature branch and optionally link it to an issue

set -e

if [ -z "$1" ]; then
  echo "Usage: ./new-feature.sh <feature-name> [issue-number]"
  echo "Example: ./new-feature.sh user-authentication 42"
  exit 1
fi

FEATURE_NAME=$1
ISSUE_NUMBER=$2

# Create branch name
if [ -n "$ISSUE_NUMBER" ]; then
  BRANCH_NAME="feature/issue-${ISSUE_NUMBER}-${FEATURE_NAME}"
  echo "Creating branch linked to issue #${ISSUE_NUMBER}..."
else
  BRANCH_NAME="feature/${FEATURE_NAME}"
  echo "Creating feature branch..."
fi

# Ensure we're on main and up to date
echo "Syncing with main..."
git checkout main
git pull origin main

# Create and checkout new branch
echo "Creating branch: ${BRANCH_NAME}"
git checkout -b "${BRANCH_NAME}"

# If issue number provided, assign to yourself
if [ -n "$ISSUE_NUMBER" ]; then
  echo "Assigning issue #${ISSUE_NUMBER} to you..."
  gh issue develop "${ISSUE_NUMBER}" --name "${BRANCH_NAME}" 2>/dev/null || echo "Note: Could not auto-assign issue (you may need to assign manually)"
fi

echo "✅ Branch created successfully: ${BRANCH_NAME}"
echo ""
echo "Next steps:"
echo "  1. Make your changes"
echo "  2. Commit: git commit -m 'feat: description'"
echo "  3. Push: git push origin ${BRANCH_NAME}"
echo "  4. Create PR: gh pr create"
