# GitHub Actions Workflows – Required Secrets

This repository includes CI workflows that optionally use secrets for deployment and analysis. Configure the following repository secrets under GitHub Settings > Secrets and variables > Actions.

## Functions CI (`functions-ci.yml`)

- `FIREBASE_SERVICE_ACCOUNT`: JSON for a Google Cloud service account with permission to deploy Firebase/Cloud Functions.
- `FIREBASE_PROJECT_ID`: Your GCP project id (e.g., `multisales-18e57`).

Notes:

- Deploy runs only on `main` and executes when both secrets are present.
- Secrets are read per step; steps skip themselves if a secret is missing.

Artifacts:

- `functions-test-results`: JUnit XML from unit tests.
- `codacy-results-text`, `codacy-results-sarif`: Static analysis outputs.

## Codacy Analysis (`codacy-analysis.yml`)

- `CODACY_API_TOKEN`: Codacy API token to authenticate analysis. Without it, analysis still runs locally and artifacts are uploaded, but results aren’t submitted to Codacy.

Artifacts:

- `codacy-results-text`: Text report of issues.
- `codacy-results-sarif`: SARIF report suitable for security tooling.

## Tips

- Keep tokens scoped minimally and rotate regularly.
- Prefer OIDC/workload identity over long-lived service accounts when possible.
