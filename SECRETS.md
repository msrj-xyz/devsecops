# Secrets and Environment Variables (DevSecOps repository)

This document lists the environment variables and repository secrets required by the scaffolded projects and CI workflows in this repository.

Use this as a checklist when configuring repository or organization secrets. Never commit secret values to the repository.

---

## High-level guidance

- Store sensitive values in GitHub Secrets, a cloud secret manager, or Vault. Do not store them in the repo.
- Use least-privilege credentials and rotate them periodically.
- For client-exposed values (frontend) use public-prefixed env vars (e.g. `NEXT_PUBLIC_*`) and never store secrets there.

---

## Global CI / Registry secrets

- `GITHUB_TOKEN` (provided by Actions) — ensure repo Actions permissions allow `packages: write` if you push images with `GITHUB_TOKEN`.
- `GHCR_PAT` — Personal Access Token for GHCR if `GITHUB_TOKEN` isn't sufficient. Scopes: `write:packages`, `read:packages`, `repo` (private repos).
- `DOCKERHUB_USERNAME`, `DOCKERHUB_PASSWORD` — if using Docker Hub.
- `REGISTRY` — optional (e.g. `ghcr.io`).
- `IMAGE_NAMESPACE` — optional (e.g. `msrj-xyz`).

## Cloud provider credentials

Choose the provider you're using (do not add multiple providers unless you actually deploy to both).

- AWS:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - Optional: `AWS_ECR_REPOSITORY`

- GCP:
  - `GCP_SA_KEY` — raw JSON service account credentials (or base64-encoded JSON). Also set `GCP_PROJECT_ID`.

- Kubernetes:
  - `KUBE_CONFIG` — base64-encoded kubeconfig (use cloud auth actions where possible instead of raw kubeconfig).

## Databases and caches

- Postgres (choose one approach):
  - `DATABASE_URL` (recommended, e.g. `postgres://user:pass@host:5432/dbname`)
  OR
  - `POSTGRES_HOST`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`

- MySQL:
  - `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE`

- Redis:
  - `REDIS_URL` or `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

## Application-level secrets (per backend)

- Common:
  - `PORT` (optional)
  - `NODE_ENV` / `FLASK_ENV` / `SPRING_PROFILES_ACTIVE`
  - `JWT_SECRET` (token signing)
  - `SESSION_SECRET` / `FLASK_SECRET_KEY` / `GO_APP_SECRET` / `SPRING_BOOT_SECRET`
  - `SALT_ROUNDS` (if hashing)
  - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM` (email sending)

## OAuth / Third-party integrations

- `GITHUB_CLIENT_ID`, `GITHUB_CLIENT_SECRET`
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`
- `FACEBOOK_CLIENT_ID`, `FACEBOOK_CLIENT_SECRET`
- `SENTRY_DSN`
- `NEW_RELIC_LICENSE_KEY`
- `STRIPE_SECRET_KEY` (or other payment provider keys)

## Security tooling tokens (optional)

- `SNYK_TOKEN` — for Snyk SCA
- `SEMgrep_APP_TOKEN` — if using Semgrep enterprise features
- `TRIVY_USERNAME` / `TRIVY_PASSWORD` — not usually required; Trivy uses public DB

## Frontend-specific envs (public vs server)

- Next.js (public): prefix with `NEXT_PUBLIC_` e.g. `NEXT_PUBLIC_API_BASE_URL`.
- Nuxt (public): `NUXT_PUBLIC_API_BASE`.
- Angular: use environment files; avoid sensitive values in client bundles.

Do NOT put `JWT_SECRET`, DB passwords or API keys into public-prefixed envs.

## Per-project recommended variables (paths)

- `projects/backend/go-api/`:
  - `PORT`, `DATABASE_URL`, `JWT_SECRET`

- `projects/backend/python-api/`:
  - `FLASK_SECRET_KEY`, `DATABASE_URL`, `REDIS_URL`

- `projects/backend/java-api/`:
  - `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD`, `JWT_SECRET`

- `projects/frontend/nextjs-app/`:
  - `NEXT_PUBLIC_API_BASE_URL` (public)
  - CI: registry secrets (`GHCR_PAT` or rely on `GITHUB_TOKEN`)

- `projects/frontend/nuxt-app/` and `projects/frontend/angular-app/` follow same pattern as Next.js.

## Example: add repo secret with `gh` (PowerShell)

Replace values before running. These commands set repo-level secrets.

```powershell
# set GHCR PAT
gh secret set GHCR_PAT --repo msrj-xyz/devsecops --body 'ghp_xxx'

# set GCP service account (raw JSON)
$sa = Get-Content -Raw 'C:\path\to\gcp-service-account.json'
gh secret set GCP_SA_KEY --repo msrj-xyz/devsecops --body $sa

# set DATABASE_URL
gh secret set DATABASE_URL --repo msrj-xyz/devsecops --body 'postgres://user:pass@host:5432/db'
```

If you prefer base64-encoding for files (sa key or kubeconfig):

```powershell
$raw = Get-Content -Raw 'C:\path\to\gcp-service-account.json'
$encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($raw))
gh secret set GCP_SA_KEY_BASE64 --repo msrj-xyz/devsecops --body $encoded
```

## Best practices

- Use environment-specific secrets (staging vs production) via GitHub Environments.
- Prefer cloud-managed secrets (GCP Secret Manager, AWS Secrets Manager, Azure Key Vault) for production.
- Minimize tokens stored in CI; use ephemeral credentials where possible (OIDC + cloud action supports).
- Limit `GHCR_PAT` and rotate regularly.

## Minimal checklist to get CI fully functional

1. Ensure `Actions > General > Workflow permissions` allows `Read and write permissions` for `GITHUB_TOKEN` if using it for GHCR.
2. Add `GHCR_PAT` (or confirm `GITHUB_TOKEN` write permissions).
3. Provide cloud credentials for your chosen cloud (`GCP_SA_KEY` or `AWS_*`).
4. Add `DATABASE_URL` for services that require DB during integration tests (if any).
5. Add `JWT_SECRET` / `SESSION_SECRET` for backend projects.

---

If you want, I can:

- automatically add `.env.example` files per project reflecting the variables above and commit them;
- generate a PowerShell script that bulk-creates the repository secrets using `gh secret set` (you run it locally to keep secrets out of chat);
- or directly run a small helper (non-secret) commit to verify CI after you add required secrets.

Pick which next and I'll implement it.
