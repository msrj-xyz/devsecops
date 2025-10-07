# 🛡️ Security Scan Summary Report

**Scan Date**: Tue Oct  7 01:36:47 UTC 2025
**Branch**: development
**Commit**: 4bcf48091479710ca85567a613988f285c8be3d7

## 🔧 Enabled Security Tools

| Tool | Status | Purpose |
|------|--------|---------|
| TruffleHog | ✅ Enabled | Secret Detection |
| GitLeaks | ✅ Enabled | Secret Detection |
| CodeQL | ⏸️ Disabled | SAST Analysis |
| Semgrep | ✅ Enabled | SAST Analysis |
| Snyk | ✅ Enabled | SCA Analysis |
| OWASP | ✅ Enabled | Dependency Check |
| Trivy | ✅ Enabled | Container Security |
| Checkov | ✅ Enabled | IaC Security |

## 📁 Available Reports

total 16540
drwxr-xr-x  3 runner runner    4096 Oct  7 01:35 .
drwxr-xr-x 12 runner runner    4096 Oct  7 01:36 ..
drwxr-xr-x  2 runner runner    4096 Oct  7 01:33 checkov-k8s.json
-rw-r--r--  1 runner runner      81 Oct  7 01:36 checkov-report.md
-rw-r--r--  1 runner runner   42983 Oct  7 01:35 dependency-check-gitlab.json
-rw-r--r--  1 runner runner   76063 Oct  7 01:35 dependency-check-jenkins.html
-rw-r--r--  1 runner runner 1466216 Oct  7 01:35 dependency-check-junit.xml
-rw-r--r--  1 runner runner   10952 Oct  7 01:35 dependency-check-report.csv
-rw-r--r--  1 root   root   8001717 Oct  7 01:35 dependency-check-report.html
-rw-r--r--  1 runner runner 2718032 Oct  7 01:35 dependency-check-report.json
-rw-r--r--  1 runner runner 1525211 Oct  7 01:35 dependency-check-report.sarif
-rw-r--r--  1 runner runner 2925580 Oct  7 01:35 dependency-check-report.xml
-rw-r--r--  1 runner runner     131 Oct  7 01:34 gitleaks-report.md
-rw-r--r--  1 runner runner     104 Oct  7 01:35 owasp-report.md
-rw-r--r--  1 runner runner   45825 Oct  7 01:33 results.sarif
-rw-r--r--  1 runner runner     626 Oct  7 01:36 security-summary.md
-rw-r--r--  1 runner runner      94 Oct  7 01:34 semgrep-report.md
-rw-r--r--  1 runner runner   35811 Oct  7 01:34 semgrep-results.json
-rw-r--r--  1 runner runner      49 Oct  7 01:35 snyk-report.md
-rw-r--r--  1 runner runner    2683 Oct  7 01:35 snyk-results.json
-rw-r--r--  1 runner runner     272 Oct  7 01:36 trivy-nodejs-api.json
-rw-r--r--  1 runner runner    6339 Oct  7 01:36 trivy-react-app.json
-rw-r--r--  1 runner runner    9523 Oct  7 01:36 trivy-results.sarif
-rw-r--r--  1 runner runner     198 Oct  7 01:34 trufflehog-report.md
