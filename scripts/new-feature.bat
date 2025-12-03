@echo off
REM Script to create a new feature branch and optionally link it to an issue

setlocal enabledelayedexpansion

if "%~1"=="" (
  echo Usage: new-feature.bat ^<feature-name^> [issue-number]
  echo Example: new-feature.bat user-authentication 42
  exit /b 1
)

set FEATURE_NAME=%~1
set ISSUE_NUMBER=%~2

REM Create branch name
if not "%ISSUE_NUMBER%"=="" (
  set BRANCH_NAME=feature/issue-%ISSUE_NUMBER%-%FEATURE_NAME%
  echo Creating branch linked to issue #%ISSUE_NUMBER%...
) else (
  set BRANCH_NAME=feature/%FEATURE_NAME%
  echo Creating feature branch...
)

REM Ensure we're on main and up to date
echo Syncing with main...
git checkout main
git pull origin main

REM Create and checkout new branch
echo Creating branch: !BRANCH_NAME!
git checkout -b !BRANCH_NAME!

REM If issue number provided, assign to yourself
if not "%ISSUE_NUMBER%"=="" (
  echo Assigning issue #%ISSUE_NUMBER% to you...
  gh issue develop %ISSUE_NUMBER% --name !BRANCH_NAME! 2>nul
  if errorlevel 1 (
    echo Note: Could not auto-assign issue. Possible reasons:
    echo   - Issue #%ISSUE_NUMBER% doesn't exist
    echo   - You don't have permissions
    echo   - GitHub CLI is not authenticated (run 'gh auth login'^)
  )
)

echo.
echo ✅ Branch created successfully: !BRANCH_NAME!
echo.
echo Next steps:
echo   1. Make your changes
echo   2. Commit: git commit -m "feat: description"
echo   3. Push: git push origin !BRANCH_NAME!
echo   4. Create PR: gh pr create

endlocal
