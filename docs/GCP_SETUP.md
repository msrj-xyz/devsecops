# Google Cloud Platform Setup Guide

## 📋 **SETUP CHECKLIST**

### ✅ **Phase 1: GitHub Repository Setup**
- [ ] Enable GitHub security features
- [ ] Configure branch protection rules  
- [ ] Add repository secrets
- [ ] Setup environments (dev, staging, production)
- [ ] Configure GitHub Actions permissions

### ✅ **Phase 2: Google Cloud Initial Setup**
- [ ] Create GCP project
- [ ] Enable required APIs
- [ ] Setup billing account
- [ ] Configure IAM service accounts
- [ ] Setup Artifact Registry

### ✅ **Phase 3: Infrastructure Setup**
- [ ] Create GKE cluster
- [ ] Setup Cloud Build
- [ ] Configure monitoring & logging
- [ ] Setup security scanning

---

## 🔧 **DETAILED SETUP INSTRUCTIONS**

### **Step 1: GCP Project Creation**

1. **Via Web Console:**
   ```
   https://console.cloud.google.com/projectcreate
   
   Project Name: DevSecOps Portfolio
   Project ID: devsecops-portfolio-[RANDOM]
   ```

2. **Via CLI:**
   ```bash
   # Install gcloud CLI first
   curl https://sdk.cloud.google.com | bash
   exec -l $SHELL
   gcloud auth login
   
   # Create project
   gcloud projects create devsecops-portfolio-001 \
     --name="DevSecOps Portfolio"
   
   gcloud config set project devsecops-portfolio-001
   ```

### **Step 2: Enable APIs**
```bash
# Core APIs
gcloud services enable container.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable cloudkms.googleapis.com

# Security APIs
gcloud services enable securitycenter.googleapis.com
gcloud services enable binaryauthorization.googleapis.com
gcloud services enable containeranalysis.googleapis.com
```

### **Step 3: Setup Service Accounts**

1. **GitHub Actions Service Account:**
   ```bash
   # Create service account
   gcloud iam service-accounts create github-actions-sa \
     --display-name="GitHub Actions SA" \
     --description="Service account for GitHub Actions CI/CD"
   
   # Assign roles
   ROLES=(
     "roles/container.developer"
     "roles/artifactregistry.writer"  
     "roles/cloudbuild.builds.editor"
     "roles/compute.admin"
     "roles/iam.serviceAccountUser"
     "roles/secretmanager.accessor"
   )
   
   for role in "${ROLES[@]}"; do
     gcloud projects add-iam-policy-binding devsecops-portfolio-001 \
       --member="serviceAccount:github-actions-sa@devsecops-portfolio-001.iam.gserviceaccount.com" \
       --role="$role"
   done
   
   # Create key
   gcloud iam service-accounts keys create github-actions-key.json \
     --iam-account=github-actions-sa@devsecops-portfolio-001.iam.gserviceaccount.com
   ```

2. **Workload Identity Service Account (for GKE pods):**
   ```bash
   gcloud iam service-accounts create devsecops-workload-sa \
     --display-name="DevSecOps Workload SA"
   
   # Bind to Kubernetes service account
   gcloud iam service-accounts add-iam-policy-binding \
     devsecops-workload-sa@devsecops-portfolio-001.iam.gserviceaccount.com \
     --role roles/iam.workloadIdentityUser \
     --member "serviceAccount:devsecops-portfolio-001.svc.id.goog[staging/devsecops-sa]"
   ```

### **Step 4: Setup Artifact Registry**
```bash
# Create repository
gcloud artifacts repositories create devsecops-repo \
  --repository-format=docker \
  --location=us-central1 \
  --description="DevSecOps container images"

# Configure Docker auth
gcloud auth configure-docker us-central1-docker.pkg.dev
```

### **Step 5: Create GKE Cluster**
```bash
gcloud container clusters create devsecops-cluster \
  --location=us-central1 \
  --num-nodes=3 \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=10 \
  --enable-autorepair \
  --enable-autoupgrade \
  --enable-network-policy \
  --enable-ip-alias \
  --enable-shielded-nodes \
  --workload-pool=devsecops-portfolio-001.svc.id.goog \
  --enable-binary-authorization \
  --disk-type=pd-ssd \
  --disk-size=50GB \
  --machine-type=e2-standard-2 \
  --security-group="gke-security-groups"
```

### **Step 6: Setup Secrets**
```bash
# Create secrets in Secret Manager
echo -n "postgresql://user:pass@host:5432/db" | \
  gcloud secrets create database-url --data-file=-

echo -n "super-secure-jwt-secret-256-bits" | \
  gcloud secrets create jwt-secret --data-file=-

# Grant access to service account
gcloud secrets add-iam-policy-binding database-url \
  --member="serviceAccount:devsecops-workload-sa@devsecops-portfolio-001.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

---

## 🔐 **GITHUB SECRETS CONFIGURATION**

Add these secrets in GitHub Repository Settings:

### **Repository Secrets:**
```bash
GOOGLE_CREDENTIALS        # Content of github-actions-key.json
GCP_PROJECT_ID           # devsecops-portfolio-001  
GCP_SA_EMAIL             # github-actions-sa@devsecops-portfolio-001.iam.gserviceaccount.com
SNYK_TOKEN               # Your Snyk API token
SLACK_WEBHOOK_URL        # Your Slack webhook URL
```

### **Environment Variables:**
```bash
ARTIFACT_REGISTRY_LOCATION=us-central1
ARTIFACT_REGISTRY_REPOSITORY=devsecops-repo
GKE_CLUSTER=devsecops-cluster
GKE_ZONE=us-central1
```

---

## 🚀 **DEPLOYMENT COMMANDS**

### **Initial Deployment:**
```bash
# Get cluster credentials
gcloud container clusters get-credentials devsecops-cluster \
  --zone us-central1

# Deploy to staging
kubectl apply -f k8s/staging/

# Check deployment status
kubectl get pods -n staging
kubectl get services -n staging
```

### **Monitoring & Troubleshooting:**
```bash
# View logs
kubectl logs -f deployment/app-deployment -n staging

# Describe pod for issues
kubectl describe pod <pod-name> -n staging

# Check events
kubectl get events -n staging --sort-by='.lastTimestamp'
```

---

## 📊 **COST ESTIMATION**

### **Monthly Cost Estimate:**
- **GKE Cluster**: ~$75/month (3 e2-standard-2 nodes)
- **Load Balancer**: ~$18/month
- **Artifact Registry**: ~$5/month (storage)
- **Cloud Build**: ~$10/month (moderate usage)
- **Monitoring & Logging**: ~$20/month
- **Secret Manager**: ~$1/month

**Total Estimated Cost: ~$130/month**

### **Cost Optimization Tips:**
- Use preemptible nodes for dev/staging
- Enable cluster autoscaling
- Set up resource quotas
- Use regional persistent disks
- Monitor with cost alerts

---

## 🔍 **VERIFICATION STEPS**

After setup, verify everything works:

1. **Check APIs are enabled:**
   ```bash
   gcloud services list --enabled
   ```

2. **Verify service accounts:**
   ```bash
   gcloud iam service-accounts list
   ```

3. **Test Artifact Registry:**
   ```bash
   docker pull hello-world
   docker tag hello-world us-central1-docker.pkg.dev/devsecops-portfolio-001/devsecops-repo/hello-world
   docker push us-central1-docker.pkg.dev/devsecops-portfolio-001/devsecops-repo/hello-world
   ```

4. **Check GKE cluster:**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

5. **Trigger GitHub Actions:**
   - Push to main branch
   - Check Actions tab in GitHub
   - Verify deployment in GCP Console

---

## ⚡ **QUICK START SCRIPT**

Save this as `setup-gcp.sh`:

```bash
#!/bin/bash
set -e

PROJECT_ID="devsecops-portfolio-001"
REGION="us-central1"

echo "🚀 Setting up DevSecOps on Google Cloud..."

# Set project
gcloud config set project $PROJECT_ID

# Enable APIs
echo "📋 Enabling APIs..."
gcloud services enable container.googleapis.com artifactregistry.googleapis.com cloudbuild.googleapis.com

# Create Artifact Registry
echo "📦 Creating Artifact Registry..."
gcloud artifacts repositories create devsecops-repo \
  --repository-format=docker \
  --location=$REGION

# Create service account
echo "🔐 Creating service accounts..."
gcloud iam service-accounts create github-actions-sa \
  --display-name="GitHub Actions SA"

echo "✅ Setup complete! Next: Configure GitHub secrets"
```

---

**Need help?** Contact: msrj.xyz@gmail.com