# 🛡️ Security Scan Summary Report

**Scan Date**: Tue Oct  7 02:45:30 UTC 2025
**Branch**: development
**Commit**: e919543e6ce9d96eb35856da44cc7c852f72ae72

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

total 300
drwxr-xr-x  3 runner runner   4096 Oct  7 02:44 .
drwxr-xr-x 12 runner runner   4096 Oct  7 02:44 ..
drwxr-xr-x  2 runner runner   4096 Oct  7 02:43 checkov-k8s.json
-rw-r--r--  1 runner runner     81 Oct  7 02:45 checkov-report.md
-rw-r--r--  1 runner runner    822 Oct  7 02:44 dependency-check-gitlab.json
-rw-r--r--  1 runner runner  27923 Oct  7 02:44 dependency-check-jenkins.html
-rw-r--r--  1 runner runner   1774 Oct  7 02:44 dependency-check-junit.xml
-rw-r--r--  1 runner runner    424 Oct  7 02:44 dependency-check-report.csv
-rw-r--r--  1 root   root   138626 Oct  7 02:44 dependency-check-report.html
-rw-r--r--  1 runner runner   3527 Oct  7 02:44 dependency-check-report.json
-rw-r--r--  1 runner runner   3707 Oct  7 02:44 dependency-check-report.sarif
-rw-r--r--  1 runner runner   3270 Oct  7 02:44 dependency-check-report.xml
-rw-r--r--  1 runner runner    131 Oct  7 02:43 gitleaks-report.md
-rw-r--r--  1 runner runner    267 Oct  7 02:44 nodejs-audit-report.md
-rw-r--r--  1 runner runner    364 Oct  7 02:44 npm-audit-results.json
-rw-r--r--  1 runner runner    377 Oct  7 02:44 owasp-report.md
-rw-r--r--  1 runner runner    626 Oct  7 02:45 security-summary.md
-rw-r--r--  1 runner runner     94 Oct  7 02:44 semgrep-report.md
-rw-r--r--  1 runner runner  34766 Oct  7 02:44 semgrep-results.json
-rw-r--r--  1 runner runner     49 Oct  7 02:44 snyk-report.md
-rw-r--r--  1 runner runner   2683 Oct  7 02:44 snyk-results.json
-rw-r--r--  1 runner runner    271 Oct  7 02:45 trivy-nodejs-api.json
-rw-r--r--  1 runner runner   6339 Oct  7 02:45 trivy-react-app.json
-rw-r--r--  1 runner runner   9523 Oct  7 02:44 trivy-results.sarif
-rw-r--r--  1 runner runner    198 Oct  7 02:43 trufflehog-report.md
