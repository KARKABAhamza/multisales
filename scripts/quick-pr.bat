@echo off
REM Script to quickly create a PR for the current branch

setlocal enabledelayedexpansion

REM Get current branch
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

REM Check if on main
if "%CURRENT_BRANCH%"=="main" (
  echo Error: Cannot create PR from main branch
  exit /b 1
)

REM Check for uncommitted changes
git diff-index --quiet HEAD -- 2>nul
if errorlevel 1 (
  echo Warning: You have uncommitted changes
  set /p COMMIT_CHOICE="Do you want to commit them now? (y/N): "
  if /i "!COMMIT_CHOICE!"=="y" (
    git add .
    set /p COMMIT_MSG="Commit message: "
    git commit -m "!COMMIT_MSG!"
  ) else (
    echo Please commit your changes before creating a PR
    exit /b 1
  )
)

REM Push current branch
echo Pushing %CURRENT_BRANCH% to origin...
git push origin %CURRENT_BRANCH% --set-upstream

REM Check if PR already exists
gh pr view >nul 2>&1
if not errorlevel 1 (
  echo PR already exists for this branch:
  gh pr view
  set /p OPEN_BROWSER="Do you want to open it in browser? (y/N): "
  if /i "!OPEN_BROWSER!"=="y" (
    gh pr view --web
  )
  exit /b 0
)

REM Create PR
echo Creating pull request...
gh pr create --web

echo ✅ Pull request created successfully

endlocal
