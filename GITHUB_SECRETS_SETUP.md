# GitHub Secrets Setup Guide

This document explains how to set up the required GitHub secrets for the MultiSales repository workflows.

## Required Secrets

The following secrets need to be configured in the repository:

1. **CODACY_API_TOKEN** - API token for Codacy integration
2. **FIREBASE_SERVICE_ACCOUNT** - Full Firebase service account JSON for deployment
3. **FIREBASE_PROJECT_ID** - Firebase project ID (e.g., `multisales-18e57`)

## Setup Methods

You can set up these secrets using either the GitHub UI (recommended) or GitHub CLI.

### Method 1: GitHub UI (Recommended)

This is the simplest method and works on all platforms.

1. Navigate to your repository's secrets page:
   ```
   https://github.com/KARKABAhamza/multisales/settings/secrets/actions
   ```

2. Click **"New repository secret"** for each secret:

   - **Name**: `CODACY_API_TOKEN`  
     **Value**: Your Codacy API token (obtain from Codacy dashboard)

   - **Name**: `FIREBASE_SERVICE_ACCOUNT`  
     **Value**: Full Firebase service account JSON with deployment permissions  
     (Download from Firebase Console → Project Settings → Service Accounts)

   - **Name**: `FIREBASE_PROJECT_ID`  
     **Value**: `multisales-18e57` (or your Firebase project ID)

3. Click **"Add secret"** after entering each value.

### Method 2: GitHub CLI (Optional)

If you have GitHub CLI installed and authenticated, you can set secrets via command line.

#### Prerequisites

**Windows:**
1. Download GitHub CLI from: https://github.com/cli/cli/releases/latest
2. Download `gh_*_windows_amd64.msi`
3. Run the installer (ensure "Add to PATH" is checked)
4. Open a new PowerShell window and verify:
   ```powershell
   gh --version
   ```

**Linux/macOS:**
```bash
# Install via package manager
# For macOS:
brew install gh

# For Ubuntu/Debian:
sudo apt install gh
```

#### Authenticate

```bash
gh auth login
```

Follow the prompts to authenticate with GitHub.

#### Set Secrets

```bash
# Set default repository
gh repo set-default KARKABAhamza/multisales

# Set each secret (you'll be prompted to paste the value)
gh secret set CODACY_API_TOKEN
gh secret set FIREBASE_SERVICE_ACCOUNT
gh secret set FIREBASE_PROJECT_ID
```

When prompted, paste the secret value and press Enter.

## Workflow Triggers

Once secrets are configured, the following workflows will run automatically:

### Functions CI Workflow
- **Trigger**: Push or Pull Request that modifies files in `functions/**`
- **Actions**:
  - Installs Node.js dependencies
  - Runs ESLint on functions code
  - Runs Codacy analysis on functions directory
  - Uploads lint and Codacy results as artifacts
- **Required Secrets**: `CODACY_API_TOKEN`

### Codacy Analysis Workflow
- **Trigger**: Push or Pull Request to `main` branch
- **Actions**:
  - Runs Codacy static analysis on entire repository
  - Uploads analysis results as artifacts
- **Required Secrets**: `CODACY_API_TOKEN`

## Troubleshooting

### GitHub CLI not found (Windows)

If `gh` command is not recognized after installation:

1. Add GitHub CLI to PATH manually:
   - Typical location: `C:\Program Files\GitHub CLI\`
   - Go to: Settings → System → About → Advanced system settings → Environment Variables
   - Edit "Path" variable → Add new entry: `C:\Program Files\GitHub CLI\`
   - Click OK and close PowerShell
   
2. Open a new PowerShell window and test:
   ```powershell
   gh --version
   ```

### Secret values

- **CODACY_API_TOKEN**: Found in your Codacy project settings under API Tokens
- **FIREBASE_SERVICE_ACCOUNT**: Download from Firebase Console:
  - Project Settings → Service Accounts → Generate new private key
  - Copy the entire JSON content
- **FIREBASE_PROJECT_ID**: Visible in Firebase Console project settings (e.g., `multisales-18e57`)

## Verification

After setting up secrets:

1. Make a small change to `functions/README.md` and push to trigger Functions CI
2. Push any change to `main` branch to trigger Codacy Analysis
3. Check the Actions tab in GitHub to see workflows running
4. Verify artifacts are uploaded successfully

## Security Notes

- Never commit secrets to the repository
- Secrets are encrypted and only available to GitHub Actions workflows
- Rotate secrets periodically for security
- Use service accounts with minimal required permissions

## Additional Resources

- [GitHub Actions Secrets Documentation](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Codacy Documentation](https://docs.codacy.com/)
- [Firebase Service Accounts](https://firebase.google.com/docs/admin/setup#initialize-sdk)
