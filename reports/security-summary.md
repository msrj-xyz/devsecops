# 🛡️ Security Scan Summary Report

**Scan Date**: Tue Oct  7 02:09:27 UTC 2025
**Branch**: development
**Commit**: 9e7a6856f89904faeeff08705734203683e64c49

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
drwxr-xr-x  3 runner runner   4096 Oct  7 02:09 .
drwxr-xr-x 12 runner runner   4096 Oct  7 02:08 ..
drwxr-xr-x  2 runner runner   4096 Oct  7 02:09 checkov-k8s.json
-rw-r--r--  1 runner runner     81 Oct  7 02:09 checkov-report.md
-rw-r--r--  1 root   root      822 Oct  7 02:08 dependency-check-gitlab.json
-rw-r--r--  1 root   root    27923 Oct  7 02:08 dependency-check-jenkins.html
-rw-r--r--  1 root   root     1774 Oct  7 02:08 dependency-check-junit.xml
-rw-r--r--  1 root   root      424 Oct  7 02:08 dependency-check-report.csv
-rw-r--r--  1 root   root   138626 Oct  7 02:08 dependency-check-report.html
-rw-r--r--  1 root   root     3527 Oct  7 02:08 dependency-check-report.json
-rw-r--r--  1 root   root     3707 Oct  7 02:08 dependency-check-report.sarif
-rw-r--r--  1 root   root     3270 Oct  7 02:08 dependency-check-report.xml
-rw-r--r--  1 runner runner    131 Oct  7 02:07 gitleaks-report.md
-rw-r--r--  1 runner runner    289 Oct  7 02:08 nodejs-audit-report.md
-rw-r--r--  1 runner runner   1714 Oct  7 02:08 npm-audit-results.json
-rw-r--r--  1 runner runner    377 Oct  7 02:08 owasp-report.md
-rw-r--r--  1 runner runner    626 Oct  7 02:09 security-summary.md
-rw-r--r--  1 runner runner     94 Oct  7 02:08 semgrep-report.md
-rw-r--r--  1 runner runner  36814 Oct  7 02:08 semgrep-results.json
-rw-r--r--  1 runner runner     49 Oct  7 02:08 snyk-report.md
-rw-r--r--  1 runner runner   2683 Oct  7 02:08 snyk-results.json
-rw-r--r--  1 runner runner    272 Oct  7 02:09 trivy-nodejs-api.json
-rw-r--r--  1 runner runner   6339 Oct  7 02:09 trivy-react-app.json
-rw-r--r--  1 runner runner   9523 Oct  7 02:08 trivy-results.sarif
-rw-r--r--  1 runner runner    198 Oct  7 02:07 trufflehog-report.md
