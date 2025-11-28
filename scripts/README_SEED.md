# Seed Contact Settings Script

This script seeds the `settings/contact` Firestore document used by the MultiSales app contact page.

## Prerequisites

- Node.js installed
- `firebase-admin` package: `npm install firebase-admin`
- A Firebase service account JSON file with Firestore write permission

## Usage

### Basic usage (using environment variable)

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
node scripts/seed-contact-settings.js
```

### Windows PowerShell

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\path\to\service-account.json"
node scripts/seed-contact-settings.js
```

### Using command-line arguments

```bash
node scripts/seed-contact-settings.js --serviceAccount ./sa.json --projectId multisales-18e57
```

## What it does

The script writes the following data to `settings/contact`:

```json
{
  "phone": "+212 784007410",
  "email": "contact@multisales.ma",
  "address": "49 boulevard CHEFCHAOUNI II, Ain Sébaâ, Casablanca Maroc",
  "hours": "Lun–Ven 08:30 – 18:00",
  "updatedAt": "<server_timestamp>"
}
```

## Customization

Edit the `contactData` object in `seed-contact-settings.js` to change the seeded values.

## CI/CD Integration

Add this script to your deployment workflow:

```yaml
- name: Seed contact settings
  env:
    GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
  run: |
    npm install firebase-admin
    node scripts/seed-contact-settings.js
```
