# 🔑 GitHub Secrets Setup Guide

**Repository:** [msrj-xyz/devsecops](https://github.com/msrj-xyz/devsecops)  
**Branch:** feature/cicd-implementation  
**Date:** October 5, 2025  
**Status:** 🔄 Ready for GitHub Secrets Configuration

---

## 🎯 **PHASE 2: GitHub Secrets Configuration**

### 📋 **Prerequisites**
- ✅ Sample applications implemented (React + Node.js)
- ✅ Branch `feature/cicd-implementation` pushed to GitHub
- ❌ Google Cloud Project (optional for now - dapat dilakukan setelah secrets)
- ❌ GitHub Secrets configured

---

## 🔑 **STEP 1: Navigate to GitHub Secrets**

### **1.1 Go to Repository Settings**
```
https://github.com/msrj-xyz/devsecops/settings/secrets/actions
```

### **1.2 Access Path**
1. Go to your repository: `https://github.com/msrj-xyz/devsecops`
2. Click **"Settings"** tab (top right)
3. Click **"Secrets and variables"** in left sidebar
4. Click **"Actions"** submenu
5. Click **"New repository secret"** button

---

## 🔐 **STEP 2: Add Basic Secrets (Minimal Setup)**

### **2.1 Essential Secrets untuk CI/CD Testing**

#### **SECRET 1: DOCKER_USERNAME**
```yaml
Name: DOCKER_USERNAME
Value: [Your Docker Hub username - optional untuk sekarang]
```

#### **SECRET 2: DOCKER_PASSWORD**  
```yaml
Name: DOCKER_PASSWORD
Value: [Your Docker Hub password/token - optional untuk sekarang]
```

#### **SECRET 3: SLACK_WEBHOOK_URL (Optional)**
```yaml
Name: SLACK_WEBHOOK_URL
Value: [Your Slack webhook URL untuk notifications]
```

---

## ☁️ **STEP 3: Google Cloud Secrets (Dapat Dilakukan Nanti)**

**Catatan**: Secrets ini bisa ditambahkan nanti setelah GCP project setup

#### **SECRET 4: GOOGLE_CREDENTIALS**
```yaml
Name: GOOGLE_CREDENTIALS
Value: [JSON content dari service account key file]
```

#### **SECRET 5: GCP_PROJECT_ID**
```yaml
Name: GCP_PROJECT_ID  
Value: [Your GCP project ID, contoh: devsecops-demo-001]
```

#### **SECRET 6: GCP_SA_EMAIL**
```yaml
Name: GCP_SA_EMAIL
Value: [Service account email, contoh: github-actions-sa@project-id.iam.gserviceaccount.com]
```

---

## 🌍 **STEP 4: Environment Configuration**

### **4.1 Create Environments**
1. Go to: `https://github.com/msrj-xyz/devsecops/settings/environments`
2. Click **"New environment"**

### **4.2 Create Three Environments**

#### **Environment 1: development**
```yaml
Name: development
Protection rules: None (auto-deploy)
Environment secrets: None needed
```

#### **Environment 2: staging**  
```yaml
Name: staging
Protection rules: Optional (add reviewers if desired)
Environment secrets: None needed
```

#### **Environment 3: production**
```yaml
Name: production
Protection rules: ✅ Required reviewers (add yourself)
Environment secrets: Add sensitive production secrets here
```

---

## 🧪 **STEP 5: Test CI/CD Pipeline Without GCP**

### **5.1 Minimal Testing Configuration**

Dengan setup ini, kita bisa test CI/CD pipeline untuk:
- ✅ **Code linting** dan formatting
- ✅ **Security scanning** (SAST/DAST)
- ✅ **Unit testing** dengan coverage
- ✅ **Docker image building** (local/Docker Hub)
- ✅ **Branch-based environment** determination

### **5.2 Trigger Pipeline Test**
```bash
# Create a small test commit
echo "# CI/CD Test" > TEST_CICD.md
git add TEST_CICD.md
git commit -m "test: trigger CI/CD pipeline for feature branch"
git push origin feature/cicd-implementation
```

### **5.3 Monitor Pipeline**
1. Go to: `https://github.com/msrj-xyz/devsecops/actions`
2. Watch pipeline execution:
   - 🎯 Environment determination (should detect "development")
   - 🔍 Pre-build validation
   - 🛡️ Security scanning
   - 🏗️ Build and test React app
   - 🏗️ Build and test Node.js API
   - 🐋 Docker image build (if Docker secrets available)

---

## 📊 **STEP 6: Expected Workflow Results**

### **6.1 Successful Pipeline Should Show**
```yaml
✅ Environment Detection: development (from feature branch)
✅ Security Scan: SAST/DAST checks passed
✅ React Build: npm install, test, build success
✅ Node.js Build: npm install, test success  
✅ Code Quality: eslint, formatting checks
✅ Docker Build: Multi-stage build success (if credentials available)
```

### **6.2 Possible Warnings (Expected)**
```yaml
⚠️ GCP Deployment: Skipped (no GCP credentials)
⚠️ Docker Push: Skipped (no Docker Hub credentials)
⚠️ Infrastructure: Skipped (no Terraform backend)
```

---

## 🔄 **STEP 7: Branch Testing Strategy**

### **7.1 Test Different Branch Behaviors**

#### **Test 1: Feature Branch (Current)**
```bash
# Should trigger development environment deployment
git push origin feature/cicd-implementation
```

#### **Test 2: Development Branch**  
```bash
# Switch and merge to development
git checkout development
git merge feature/cicd-implementation
git push origin development
# Should trigger development environment with auto-deploy
```

#### **Test 3: Staging Branch**
```bash
# Switch and merge to staging  
git checkout staging
git merge development
git push origin staging
# Should trigger staging environment (may require approval)
```

#### **Test 4: Production Branch (Master)**
```bash
# Switch and merge to master
git checkout master  
git merge staging
git push origin master
# Should trigger production environment (requires approval)
```

---

## 🛠️ **STEP 8: Troubleshooting Common Issues**

### **8.1 Pipeline Failures**
```yaml
❌ Secret not found: Check spelling dan capitalization
❌ Permission denied: Ensure secrets are set at repository level
❌ Workflow not triggered: Check branch protection rules
❌ Build failures: Check package.json dan dependencies
```

### **8.2 Environment Issues**
```yaml
❌ Environment not created: Manual creation required in GitHub Settings
❌ Approval not required: Check protection rules configuration
❌ Wrong environment detected: Check branch naming in workflow files
```

---

## 📋 **STEP 9: Verification Checklist**

### **9.1 Before Proceeding**
- [ ] Repository secrets added (minimal set)
- [ ] Environments created (development, staging, production)
- [ ] Production environment has protection rules
- [ ] Feature branch pipeline executed successfully
- [ ] Security scans completed without critical issues
- [ ] Docker builds completed (if credentials provided)

### **9.2 Success Indicators**
- [ ] ✅ Green checkmarks in GitHub Actions
- [ ] ✅ All jobs completed successfully  
- [ ] ✅ Security scan results visible
- [ ] ✅ Build artifacts generated
- [ ] ✅ Environment detection working correctly

---

## 🎯 **NEXT STEPS AFTER GITHUB SETUP**

### **Immediate (Can do now)**
1. **Test pipeline** dengan different branches
2. **Review security scan** results
3. **Validate Docker builds** 
4. **Check environment routing**

### **Later (Optional)**  
1. **Setup GCP project** (PHASE 1)
2. **Add GCP secrets** to GitHub
3. **Deploy infrastructure** (PHASE 4)
4. **End-to-end testing** (PHASE 5)

---

## 🆘 **Need Help?**

### **Common Commands**
```bash
# Check current branch
git branch

# View recent commits
git log --oneline -5

# Check GitHub Actions status
# Visit: https://github.com/msrj-xyz/devsecops/actions

# View workflow files
ls -la .github/workflows/
```

### **Useful Links**
- **Repository**: https://github.com/msrj-xyz/devsecops
- **Actions**: https://github.com/msrj-xyz/devsecops/actions  
- **Settings**: https://github.com/msrj-xyz/devsecops/settings
- **Secrets**: https://github.com/msrj-xyz/devsecops/settings/secrets/actions

---

**🎉 Ready to configure GitHub Secrets dan test CI/CD pipeline!**

---

*📧 Questions? Contact: msrj.xyz@gmail.com*  
*🔗 Repository: https://github.com/msrj-xyz/devsecops*  
*📅 Created: October 5, 2025*