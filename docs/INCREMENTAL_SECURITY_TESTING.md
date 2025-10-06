# 🛡️ Incremental Security Testing Guide

## Overview
This guide outlines our iterative approach to enabling DevSecOps security tools one by one to ensure each tool works properly and generates reports.

## 🎯 Current Strategy

### Phase 1: Foundation Testing ✅
**Status**: Currently Active

**Enabled Tools**:
- ✅ **TruffleHog** (Secret Detection)

**Disabled Tools**:
- ⏸️ GitLeaks (Secret Detection - testing one at a time)
- ⏸️ Semgrep (SAST - fixing config issues)
- ⏸️ Snyk (SCA - need token configuration)
- ⏸️ OWASP (Dependency Check - need testing)
- ⏸️ Trivy (Container Security - need testing)
- ⏸️ Checkov (IaC Security - terraform not ready)
- ⏸️ CodeQL (SAST - disabled for faster builds)

**Test Objective**: Verify TruffleHog works correctly and generates reports

---

## 🔧 Tool Configuration Status

### Environment Variables
Located in `.github/workflows/security-scan.yml`:

```yaml
env:
  # Security tools toggle - enable one by one for testing
  ENABLE_CODEQL: 'false'       # CodeQL SAST (disabled for faster builds)
  ENABLE_TRUFFLEHOG: 'true'    # Secret detection ← CURRENTLY TESTING
  ENABLE_GITLEAKS: 'false'     # Secret detection (disable one to test other)
  ENABLE_SEMGREP: 'false'      # SAST (disabled for now due to config issue)
  ENABLE_SNYK: 'false'         # SCA (need token)
  ENABLE_OWASP: 'false'        # Dependency check
  ENABLE_TRIVY: 'false'        # Container security
  ENABLE_CHECKOV: 'false'      # IaC security (terraform not ready)
```

### Key Improvements Made

#### 1. **Error Handling**
- Changed from `continue-on-error: true` to `continue-on-error: false`
- This ensures we catch and fix issues properly during testing

#### 2. **Semgrep Configuration Fix**
- **Issue**: `Cannot run 'semgrep ci' with --config while logged in`
- **Solution**: Use `semgrep --config=auto` instead of semgrep-action with --config

#### 3. **Dockerfile Fix**
- **Issue**: `npm audit fix --audit-level=moderate` causing exit code 1
- **Solution**: Removed problematic audit fix command, kept only `npm ci --only=production`

#### 4. **Report Generation**
- Each tool now generates individual reports in `reports/` directory
- Reports include status, date, branch information
- All reports available as downloadable artifacts

#### 5. **Slack Notifications Enhanced**
- Added detailed icons and status information
- Shows which tools are enabled/disabled
- Provides direct links to workflow logs and artifacts

---

## 📋 Testing Phases Plan

### Phase 1: Secret Detection ← CURRENT
- [x] **TruffleHog**: Currently being tested
- [ ] **GitLeaks**: Next after TruffleHog succeeds

### Phase 2: Static Analysis (SAST)
- [ ] **Semgrep**: After fixing config issues
- [ ] **CodeQL**: Optional (disabled for performance)

### Phase 3: Software Composition Analysis (SCA)  
- [ ] **Snyk**: Requires SNYK_TOKEN configuration
- [ ] **OWASP Dependency Check**: Comprehensive vulnerability scanning

### Phase 4: Container Security
- [ ] **Trivy**: Filesystem and container image scanning

### Phase 5: Infrastructure as Code (IaC)
- [ ] **Checkov**: Kubernetes only (Terraform skipped as requested)

---

## 🚀 Execution Plan

### Step 1: Validate Current Tool (TruffleHog)
```bash
# Monitor current run
gh run list --workflow="security-scan.yml" --limit 1

# Check logs if needed
gh run view [RUN_ID] --log
```

### Step 2: Enable Next Tool (if current succeeds)
Update environment variables in `security-scan.yml`:
```yaml
# Example: Enable GitLeaks after TruffleHog success
ENABLE_TRUFFLEHOG: 'false'   # Disable current
ENABLE_GITLEAKS: 'true'      # Enable next
```

### Step 3: Test and Validate
- Run workflow: `gh workflow run security-scan.yml`
- Check for successful completion
- Download and review reports
- Verify Slack notifications

### Step 4: Repeat Process
Continue enabling tools one by one until all are validated.

---

## 📊 Success Criteria

For each tool to be considered "successful":

1. **✅ Execution**: Tool runs without errors
2. **✅ Reports**: Generates readable report in `reports/` directory  
3. **✅ Artifacts**: Reports available for download
4. **✅ Notifications**: Slack notification sent with correct status
5. **✅ Integration**: Works within overall workflow

---

## 🔍 Troubleshooting

### Common Issues and Solutions

#### Semgrep Config Error
```
Cannot run `semgrep ci` with --config while logged in
```
**Solution**: Use standalone semgrep command instead of action
```bash
pip install semgrep
semgrep --config=auto --json --output=reports/semgrep-results.json .
```

#### Dockerfile Build Failures
```
npm audit fix --audit-level=moderate" did not complete successfully: exit code 1
```
**Solution**: Remove audit fix, use only `npm ci --only=production`

#### Missing Tokens
- **Snyk**: Requires `SNYK_TOKEN` secret configuration
- **Semgrep**: Requires `SEMGREP_TOKEN` (if using SemgrEP App)

#### Terraform Scanning
- **Status**: Deliberately skipped as requested
- **Alternative**: Focus on Kubernetes IaC scanning only

---

## 📈 Progress Tracking

### Completed ✅
- [x] Workflow restructuring with toggle switches
- [x] Error handling improvements
- [x] Semgrep configuration fix
- [x] Dockerfile npm audit fix
- [x] Report generation system
- [x] Enhanced Slack notifications
- [x] TruffleHog testing initiation

### In Progress 🔄
- [ ] TruffleHog validation and report verification

### Pending ⏳
- [ ] GitLeaks enablement and testing
- [ ] Semgrep standalone implementation
- [ ] Token configuration for Snyk
- [ ] OWASP dependency check testing
- [ ] Trivy container scanning
- [ ] Checkov Kubernetes IaC scanning

---

## 🎯 Final Goal

Once all tools are individually validated:

1. **Enable All Working Tools**: Set all validated tools to `'true'`
2. **Performance Optimization**: Fine-tune execution order and parallel processing
3. **Production Deployment**: Deploy comprehensive security pipeline
4. **Monitoring Setup**: Establish ongoing security monitoring

---

**Next Action**: Monitor current TruffleHog test execution and prepare for GitLeaks enablement.

---

*Last Updated: $(date)*  
*Author: DevSecOps Team*