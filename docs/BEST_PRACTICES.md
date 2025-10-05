# DevSecOps Best Practices Guide

## 🛡️ Security-First Development

### 1. Shift-Left Security Approach

#### Pre-Commit Security Hooks
```bash
# Install pre-commit
pip install pre-commit

# Configure pre-commit hooks
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/trufflesecurity/trufflehog
    rev: v3.63.2
    hooks:
      - id: trufflehog
        name: TruffleHog
        description: Detect secrets in your data
        entry: bash -c 'trufflehog git file://. --since-commit HEAD --only-verified --fail'
        language: system
        stages: ["push"]

  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']

  - repo: https://github.com/bridgecrewio/checkov
    rev: 3.0.0
    hooks:
      - id: checkov
        args: [--framework, terraform, --framework, kubernetes]
EOF

# Install hooks
pre-commit install
```

#### Secret Management Best Practices
```bash
# Use environment variables for secrets
export DATABASE_URL="postgresql://user:password@localhost/db"

# Use secret management tools
kubectl create secret generic app-secrets \
  --from-literal=database-url="$DATABASE_URL" \
  --from-literal=api-key="$API_KEY"

# Use sealed secrets for GitOps
kubeseal --format=yaml < secret.yaml > sealed-secret.yaml
```

### 2. Container Security

#### Secure Dockerfile Practices
```dockerfile
# Use specific, minimal base images
FROM node:18-alpine AS builder

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Set security context
USER nextjs

# Use multi-stage builds
FROM node:18-alpine AS runner
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy only necessary files
COPY --from=builder --chown=nextjs:nodejs /app .

# Use HEALTHCHECK
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Run as non-root
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
```

#### Container Security Scanning
```bash
# Trivy scanning
trivy image --severity HIGH,CRITICAL node:18-alpine

# Snyk container scanning
snyk container test node:18-alpine

# Docker bench security
docker run --rm --net host --pid host --userns host --cap-add audit_control \
  -e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
  -v /etc:/etc:ro \
  -v /var/lib:/var/lib:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --label docker_bench_security \
  docker/docker-bench-security
```

### 3. Kubernetes Security Hardening

#### Pod Security Standards
```yaml
# pod-security-policy.yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  privileged: false
  allowPrivilegeEscalation: false
  requiredDropCapabilities:
    - ALL
  volumes:
    - 'configMap'
    - 'emptyDir'
    - 'projected'
    - 'secret'
    - 'downwardAPI'
    - 'persistentVolumeClaim'
  runAsUser:
    rule: 'MustRunAsNonRoot'
  seLinux:
    rule: 'RunAsAny'
  fsGroup:
    rule: 'RunAsAny'
```

#### Network Policies
```yaml
# default-deny-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  ingress: []

---
# allow-frontend-to-backend.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### 4. Infrastructure Security

#### Terraform Security Best Practices
```hcl
# terraform-security.tf
# Enable encryption for all resources
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "devsecops-secure-bucket"

  # Enable encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Enable versioning
  versioning {
    enabled = true
  }

  # Block public access
  public_access_block {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

# Use least privilege IAM policies
resource "aws_iam_role_policy" "least_privilege" {
  name = "LeastPrivilegePolicy"
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.secure_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })
}
```

#### Infrastructure Scanning
```bash
# Checkov scanning
checkov -f main.tf --framework terraform

# TFSec scanning
tfsec .

# Terrascan scanning
terrascan scan -t terraform
```

### 5. CI/CD Security Pipeline

#### Secure Pipeline Configuration
```yaml
# .github/workflows/secure-pipeline.yml
name: Secure CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      # Source code security
      - name: Secret Scanning
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: main
          head: HEAD

      # SAST Analysis
      - name: CodeQL Analysis
        uses: github/codeql-action/init@v3
        with:
          languages: javascript, python, java

      # Dependency Scanning
      - name: Snyk Security Scan
        uses: snyk/actions/setup@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}

      # Container Scanning
      - name: Trivy Container Scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:latest'
          format: 'sarif'
          output: 'trivy-results.sarif'

      # Infrastructure Scanning
      - name: Checkov IaC Scan
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          framework: terraform,kubernetes
```

### 6. Monitoring and Alerting

#### Security Monitoring Setup
```yaml
# prometheus-security-rules.yml
groups:
  - name: security.rules
    rules:
      - alert: HighFailedLoginRate
        expr: rate(authentication_failures_total[5m]) > 0.1
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High failed login rate detected"
          description: "Failed login rate is {{ $value }} per second"

      - alert: SuspiciousNetworkActivity
        expr: rate(network_connections_total{destination!~"internal.*"}[5m]) > 100
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Suspicious network activity detected"
          description: "High rate of external connections: {{ $value }} per second"

      - alert: UnauthorizedAPIAccess
        expr: rate(api_requests_total{status_code="403"}[5m]) > 10
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High rate of unauthorized API access"
          description: "403 errors rate: {{ $value }} per second"
```

#### Log Analysis with ELK Stack
```yaml
# logstash-security.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [type] == "security" {
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
    }
    
    if [response] >= 400 {
      mutate {
        add_tag => ["security_event"]
      }
    }
    
    # Detect potential SQL injection
    if [request] =~ /(?i)(union|select|insert|update|delete|drop|create|alter)/ {
      mutate {
        add_tag => ["potential_sql_injection"]
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "security-%{+YYYY.MM.dd}"
  }
}
```

### 7. Compliance and Governance

#### Policy as Code with OPA Gatekeeper
```yaml
# require-security-context.yaml
apiVersion: templates.gatekeeper.sh/v1beta1
kind: ConstraintTemplate
metadata:
  name: requiresecuritycontext
spec:
  crd:
    spec:
      names:
        kind: RequireSecurityContext
      validation:
        openAPIV3Schema:
          type: object
  targets:
    - target: admission.k8s.gatekeeper.sh
      rego: |
        package requiresecuritycontext
        
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not container.securityContext.runAsNonRoot
          msg := "Container must run as non-root user"
        }
        
        violation[{"msg": msg}] {
          container := input.review.object.spec.containers[_]
          not container.securityContext.readOnlyRootFilesystem
          msg := "Container must have read-only root filesystem"
        }

---
apiVersion: config.gatekeeper.sh/v1alpha1
kind: RequireSecurityContext
metadata:
  name: must-have-security-context
spec:
  match:
    - apiGroups: ["apps"]
      kinds: ["Deployment"]
      namespaces: ["production"]
```

#### Compliance Reporting
```bash
#!/bin/bash
# compliance-report.sh

echo "# DevSecOps Compliance Report"
echo "Generated: $(date)"
echo ""

echo "## Security Scanning Results"
echo "### SAST Results"
sonar-scanner -Dsonar.projectKey=devsecops \
  -Dsonar.sources=. \
  -Dsonar.host.url=$SONAR_HOST_URL \
  -Dsonar.login=$SONAR_TOKEN

echo "### Dependency Scanning"
snyk test --json > dependency-scan.json
cat dependency-scan.json | jq '.vulnerabilities | length'

echo "### Container Scanning"  
trivy image --format json myapp:latest > container-scan.json
cat container-scan.json | jq '.Results[].Vulnerabilities | length'

echo "### Infrastructure Scanning"
checkov -f infrastructure/ --framework terraform --output json > iac-scan.json
cat iac-scan.json | jq '.results.failed_checks | length'

echo "## Compliance Metrics"
echo "- Security tests passed: $(cat test-results.xml | grep -c 'status=\"passed\"')"
echo "- Policy violations: $(kubectl get constraintviolations --all-namespaces -o json | jq '.items | length')"
echo "- Unencrypted resources: 0"
echo "- Privileged containers: $(kubectl get pods --all-namespaces -o json | jq '[.items[].spec.containers[] | select(.securityContext.privileged == true)] | length')"
```

### 8. Incident Response Automation

#### Automated Response Scripts
```bash
#!/bin/bash
# incident-response.sh

SEVERITY=$1
INCIDENT_TYPE=$2

case $SEVERITY in
  "critical")
    # Immediate containment
    kubectl scale deployment suspicious-app --replicas=0
    
    # Alert security team
    curl -X POST -H 'Content-type: application/json' \
      --data '{"text":"🚨 CRITICAL SECURITY INCIDENT: '$INCIDENT_TYPE'"}' \
      $SLACK_WEBHOOK_URL
      
    # Create incident ticket
    curl -X POST -H "Authorization: Bearer $JIRA_TOKEN" \
      -H "Content-Type: application/json" \
      --data '{
        "fields": {
          "project": {"key": "SEC"},
          "summary": "Critical Security Incident: '$INCIDENT_TYPE'",
          "description": "Automated incident created at $(date)",
          "issuetype": {"name": "Incident"},
          "priority": {"name": "Critical"}
        }
      }' \
      "$JIRA_URL/rest/api/2/issue/"
    ;;
    
  "high")
    # Isolate affected resources
    kubectl label pod $AFFECTED_POD quarantine=true
    kubectl apply -f network-isolation-policy.yaml
    
    # Gather evidence
    kubectl logs $AFFECTED_POD > incident-logs-$(date +%Y%m%d-%H%M%S).log
    kubectl describe pod $AFFECTED_POD > incident-details-$(date +%Y%m%d-%H%M%S).txt
    ;;
esac
```

## 📊 Metrics and KPIs

### Security Metrics Dashboard
- **MTTR (Mean Time to Remediation)**: < 4 hours
- **Vulnerability Detection Rate**: > 99%
- **False Positive Rate**: < 5%
- **Security Test Coverage**: > 95%
- **Policy Compliance**: > 98%

### Automation Metrics
- **Pipeline Success Rate**: > 99%
- **Deployment Frequency**: Multiple per day
- **Lead Time**: < 2 hours
- **Recovery Time**: < 30 minutes

This comprehensive guide ensures that your DevSecOps practices meet international standards and industry best practices for security, compliance, and operational excellence.