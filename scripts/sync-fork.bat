@echo off
REM Script to sync your fork with the upstream repository

setlocal enabledelayedexpansion

echo Syncing fork with upstream...

REM Get current branch
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

REM Fetch from upstream (origin)
echo Fetching from origin...
git fetch origin

REM Switch to main
echo Switching to main branch...
git checkout main

REM Pull latest changes
echo Pulling latest changes from origin/main...
git pull origin main

REM Switch back to original branch if it wasn't main
if not "%CURRENT_BRANCH%"=="main" (
  echo Switching back to %CURRENT_BRANCH%...
  git checkout %CURRENT_BRANCH%
  
  REM Offer to rebase on main
  set /p REBASE_CHOICE="Do you want to rebase %CURRENT_BRANCH% on main? (y/N): "
  if /i "!REBASE_CHOICE!"=="y" (
    echo Rebasing %CURRENT_BRANCH% on main...
    git rebase main
    echo ✅ Rebase complete
  )
)

echo ✅ Fork synced successfully

endlocal
