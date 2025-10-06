# 🔐 GitHub Secrets Setup Guide

## Step-by-Step Instructions to Add GCP Secrets

### 1. Navigate to GitHub Repository Secrets
- Go to: https://github.com/msrj-xyz/devsecops
- Click: "Settings" tab (at the top)
- Click: "Secrets and variables" (left sidebar)  
- Click: "Actions" (sub-menu)
- Click: "New repository secret" (green button)

### 2. Add Required Secrets

#### Secret #1: GOOGLE_CREDENTIALS
- Name: GOOGLE_CREDENTIALS
- Value: [Paste entire content of github-actions-key.json file]
- Click: "Add secret"

#### Secret #2: GCP_PROJECT_ID  
- Name: GCP_PROJECT_ID
- Value: devsecops-portfolio-001
- Click: "Add secret"

#### Secret #3: GCP_SA_EMAIL
- Name: GCP_SA_EMAIL  
- Value: github-actions-sa@devsecops-portfolio-001.iam.gserviceaccount.com
- Click: "Add secret"

### 3. Optional Additional Secrets
#### Secret #4: SNYK_TOKEN (for security scanning)
- Name: SNYK_TOKEN
- Value: [Get from https://snyk.io - Account Settings - API Token]
- Click: "Add secret"

#### Secret #5: SLACK_WEBHOOK_URL (for notifications)
- Name: SLACK_WEBHOOK_URL
- Value: [Your Slack webhook URL]
- Click: "Add secret"

### 4. Environment Variables (Optional - can be hardcoded)
#### ARTIFACT_REGISTRY_LOCATION
- Name: ARTIFACT_REGISTRY_LOCATION
- Value: us-central1

#### ARTIFACT_REGISTRY_REPOSITORY  
- Name: ARTIFACT_REGISTRY_REPOSITORY
- Value: devsecops-repo

#### GKE_CLUSTER
- Name: GKE_CLUSTER
- Value: devsecops-cluster

#### GKE_ZONE
- Name: GKE_ZONE
- Value: us-central1

## 🔍 How to Get github-actions-key.json Content

If you haven't created the service account key yet, run this command in GCP Cloud Shell:

```bash
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions-sa@devsecops-portfolio-001.iam.gserviceaccount.com

cat github-actions-key.json
```

Copy the entire output and paste it as the GOOGLE_CREDENTIALS secret.

## ✅ Verification

After adding all secrets, you should see them listed in the repository secrets section:
- GOOGLE_CREDENTIALS
- GCP_PROJECT_ID  
- GCP_SA_EMAIL
- SNYK_TOKEN (optional)
- SLACK_WEBHOOK_URL (optional)

## 🚀 Test the Setup

1. Make a small change to any file
2. Commit and push to trigger GitHub Actions
3. Check the Actions tab to see if the workflow runs successfully
4. Monitor GCP Cloud Build console for deployment progress

## 🔒 Security Notes

- ❌ NEVER commit .json key files to your repository
- ✅ Only store sensitive data in GitHub Secrets
- ✅ Rotate service account keys every 90 days
- ✅ Use principle of least privilege for service account permissions