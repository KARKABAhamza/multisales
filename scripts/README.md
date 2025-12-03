# Helper Scripts

This directory contains helper scripts for common development workflows using GitHub CLI.

## Available Scripts

### 1. new-feature (`new-feature.sh` / `new-feature.bat`)

Create a new feature branch and optionally link it to an issue.

**Usage:**
```bash
# Linux/macOS
./scripts/new-feature.sh <feature-name> [issue-number]

# Windows
scripts\new-feature.bat <feature-name> [issue-number]

# Example
./scripts/new-feature.sh user-authentication 42
```

**What it does:**
- Syncs with main branch
- Creates a new feature branch
- Optionally links to an issue
- Provides next steps guidance

### 2. quick-pr (`quick-pr.sh` / `quick-pr.bat`)

Quickly create a pull request for the current branch.

**Usage:**
```bash
# Linux/macOS
./scripts/quick-pr.sh

# Windows
scripts\quick-pr.bat
```

**What it does:**
- Checks for uncommitted changes
- Pushes current branch
- Creates PR (opens browser for details)
- Links to issue if branch follows naming convention

### 3. sync-fork (`sync-fork.sh` / `sync-fork.bat`)

Sync your fork with the upstream repository.

**Usage:**
```bash
# Linux/macOS
./scripts/sync-fork.sh

# Windows
scripts\sync-fork.bat
```

**What it does:**
- Fetches latest changes from origin
- Updates main branch
- Optionally rebases current branch

### 4. check-ci (`check-ci.sh` / `check-ci.bat`)

Check CI status for current branch.

**Usage:**
```bash
# Linux/macOS
./scripts/check-ci.sh

# Windows
scripts\check-ci.bat
```

**What it does:**
- Shows PR status if exists
- Displays CI check results
- Lists recent workflow runs
- Optionally watches workflow in real-time

## PowerShell Scripts

The following PowerShell scripts are also available for asset management:

- `copy_hero_bg.ps1` - Copy hero background images
- `copy_logos.ps1` - Copy logo assets
- `copy_services.ps1` - Copy service icons
- `replace_hero_image.ps1` - Replace hero image

## Prerequisites

All GitHub CLI scripts require:
- Git installed and configured
- GitHub CLI (`gh`) installed and authenticated
- Proper repository access

## Authentication

Before using these scripts, authenticate with GitHub CLI:

```bash
gh auth login
```

Follow the prompts to authenticate.

## Tips

1. **Make scripts executable** (Linux/macOS):
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Add scripts to PATH** for global access (optional):
   ```bash
   # Add to ~/.bashrc or ~/.zshrc
   export PATH="$PATH:/path/to/multisales/scripts"
   ```

3. **Create aliases** for frequently used commands:
   ```bash
   alias new-feat='./scripts/new-feature.sh'
   alias pr='./scripts/quick-pr.sh'
   alias sync='./scripts/sync-fork.sh'
   alias ci='./scripts/check-ci.sh'
   ```

4. **VS Code Integration**: Use the Command Palette (Ctrl/Cmd+Shift+P) and run "Tasks: Run Task" to access GitHub CLI tasks.

## Common Workflows

### Starting a new feature
```bash
# 1. Create feature branch
./scripts/new-feature.sh my-feature 123

# 2. Make changes
git add .
git commit -m "feat: add my feature"

# 3. Create PR
./scripts/quick-pr.sh

# 4. Check CI
./scripts/check-ci.sh
```

### Syncing before starting work
```bash
# 1. Sync fork
./scripts/sync-fork.sh

# 2. Start new feature
./scripts/new-feature.sh new-feature

# Make changes...
```

## Troubleshooting

### Permission denied (Linux/macOS)
```bash
chmod +x scripts/*.sh
```

### Command not found
Make sure GitHub CLI is installed:
```bash
# Check installation
gh --version

# Install if needed
# See: https://cli.github.com/manual/installation
```

### Authentication issues
```bash
# Check auth status
gh auth status

# Re-authenticate
gh auth logout
gh auth login
```

## Documentation

For more detailed information:
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Full contributing guide
- [GITHUB_CLI_GUIDE.md](../docs/GITHUB_CLI_GUIDE.md) - Comprehensive GitHub CLI reference
- [GITHUB_CLI_CHEATSHEET.md](../docs/GITHUB_CLI_CHEATSHEET.md) - Quick reference

## Support

If you encounter issues:
1. Check the [troubleshooting](#troubleshooting) section
2. Review [GitHub CLI documentation](https://cli.github.com/manual/)
3. Open an issue in the repository

---

Happy coding! 🚀
