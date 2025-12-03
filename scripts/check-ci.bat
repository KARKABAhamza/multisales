@echo off
REM Script to check CI status for current branch

setlocal

REM Get current branch
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

echo Checking CI status for branch: %CURRENT_BRANCH%
echo.

REM Check if there's a PR for current branch
gh pr view >nul 2>&1
if not errorlevel 1 (
  echo === Pull Request Status ===
  gh pr view
  echo.
  echo === CI Checks ===
  gh pr checks
  echo.
  
  REM Ask if user wants to watch the workflow
  set /p WATCH_CHOICE="Do you want to watch the latest workflow run? (y/N): "
  if /i "!WATCH_CHOICE!"=="y" (
    gh run watch
  )
) else (
  echo No PR found for current branch
  echo.
  echo === Recent Workflow Runs ===
  gh run list --branch %CURRENT_BRANCH% --limit 5
  echo.
  echo Tip: Create a PR with: gh pr create
)

endlocal
