#!/bin/bash
# Quick script to generate and display GCP service account key

# Set your project ID (ganti dengan project ID Anda)
PROJECT_ID="devsecops-portfolio-001"

echo "🔑 Generating GitHub Actions Service Account Key..."
echo "Project ID: $PROJECT_ID"
echo ""

# Generate service account key
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=github-actions-sa@${PROJECT_ID}.iam.gserviceaccount.com

echo ""
echo "📋 Copy the following JSON content and paste it as GOOGLE_CREDENTIALS secret in GitHub:"
echo "===================================================================================="
cat github-actions-key.json
echo ""
echo "===================================================================================="
echo ""
echo "🚀 Other secrets to add:"
echo "GCP_PROJECT_ID: $PROJECT_ID"
echo "GCP_SA_EMAIL: github-actions-sa@${PROJECT_ID}.iam.gserviceaccount.com"
echo ""
echo "⚠️  IMPORTANT: Delete the github-actions-key.json file after copying to GitHub!"
echo "rm github-actions-key.json"