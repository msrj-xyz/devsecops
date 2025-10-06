# 🛡️ Security Scan Summary Report

**Scan Date**: Mon Oct  6 08:55:50 UTC 2025
**Branch**: feature/cicd-implementation
**Commit**: 08057b4f5e2f97193b68b557239082f64829e832

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
drwxr-xr-x  3 runner runner    4096 Oct  6 08:55 .
drwxr-xr-x 16 runner runner    4096 Oct  6 08:55 ..
drwxr-xr-x  2 runner runner    4096 Oct  6 08:55 checkov-k8s.json
-rw-r--r--  1 runner runner      81 Oct  6 08:55 checkov-report.md
-rw-r--r--  1 root   root     42983 Oct  6 08:54 dependency-check-gitlab.json
-rw-r--r--  1 root   root     76063 Oct  6 08:54 dependency-check-jenkins.html
-rw-r--r--  1 root   root   1466216 Oct  6 08:54 dependency-check-junit.xml
-rw-r--r--  1 root   root     10952 Oct  6 08:54 dependency-check-report.csv
-rw-r--r--  1 root   root   8001717 Oct  6 08:54 dependency-check-report.html
-rw-r--r--  1 root   root   2718032 Oct  6 08:54 dependency-check-report.json
-rw-r--r--  1 root   root   1525211 Oct  6 08:54 dependency-check-report.sarif
-rw-r--r--  1 root   root   2925580 Oct  6 08:54 dependency-check-report.xml
-rw-r--r--  1 runner runner     147 Oct  6 08:53 gitleaks-report.md
-rw-r--r--  1 runner runner     104 Oct  6 08:54 owasp-report.md
-rw-r--r--  1 runner runner   45825 Oct  6 08:52 results.sarif
-rw-r--r--  1 runner runner     642 Oct  6 08:55 security-summary.md
-rw-r--r--  1 runner runner      94 Oct  6 08:53 semgrep-report.md
-rw-r--r--  1 runner runner   36589 Oct  6 08:53 semgrep-results.json
-rw-r--r--  1 runner runner      49 Oct  6 08:53 snyk-report.md
-rw-r--r--  1 runner runner    2683 Oct  6 08:53 snyk-results.json
-rw-r--r--  1 runner runner     272 Oct  6 08:55 trivy-nodejs-api.json
-rw-r--r--  1 runner runner    6339 Oct  6 08:55 trivy-react-app.json
-rw-r--r--  1 runner runner    9523 Oct  6 08:55 trivy-results.sarif
-rw-r--r--  1 runner runner     214 Oct  6 08:53 trufflehog-report.md
