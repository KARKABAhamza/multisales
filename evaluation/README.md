# Evaluation Framework

This folder contains a lightweight evaluation setup for the MultiSales app.

## Metrics

- Response accuracy (contact form validation success/failure)
- Route protection (admin page access based on email domain)
- Seed script success (Firestore settings/contact written with expected fields)

## Files

- `queries.json`: synthetic test inputs for contact form, admin route, and seed script.
- `collect.js`: Node runner to execute seed script and record output; prints pass/fail.

## Usage

1. Install deps:

```powershell
npm install
```

1. Run seed evaluation:

```powershell
node evaluation/collect.js --credentials "C:\\path\\to\\serviceAccount.json" --project your-project-id
```

Note: App route protection and contact form checks can be expanded with Flutter integration tests.
