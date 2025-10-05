# Contributing to DevSecOps Portfolio

Thank you for your interest in contributing to this DevSecOps portfolio! This document provides guidelines and best practices for contributing to ensure high-quality, secure, and maintainable code.

## 🤝 How to Contribute

### 1. Getting Started

#### Prerequisites
- **Git**: Version 2.30 or higher
- **Node.js**: Version 18 or higher
- **Python**: Version 3.9 or higher  
- **Docker**: Version 20.10 or higher
- **Terraform**: Version 1.6 or higher
- **kubectl**: Version 1.28 or higher

#### Development Environment Setup
```bash
# 1. Fork and clone the repository
git clone https://github.com/your-username/devsecops.git
cd devsecops

# 2. Install pre-commit hooks
pip install pre-commit
pre-commit install

# 3. Install dependencies
npm install
pip install -r requirements-dev.txt

# 4. Run initial security scan
./scripts/security-scan.sh

# 5. Verify setup
npm run test
terraform validate infrastructure/terraform/
```

### 2. Development Workflow

#### Branch Strategy
We follow a **GitFlow** workflow with security-first practices:

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# For security fixes
git checkout -b security/vulnerability-fix

# For infrastructure changes  
git checkout -b infra/terraform-updates

# For documentation
git checkout -b docs/update-readme
```

#### Commit Convention
We use **Conventional Commits** specification:

```bash
# Format: <type>[optional scope]: <description>
git commit -m "feat(api): add rate limiting middleware"
git commit -m "fix(security): resolve SQL injection vulnerability"
git commit -m "docs(readme): update installation guide"
git commit -m "sec(deps): update vulnerable package versions"
```

**Commit Types:**
- `feat`: New feature
- `fix`: Bug fix
- `sec`: Security-related changes
- `docs`: Documentation changes
- `style`: Formatting, missing semi colons, etc.
- `refactor`: Code refactoring
- `test`: Adding missing tests
- `chore`: Maintenance tasks
- `ci`: CI/CD pipeline changes
- `infra`: Infrastructure changes

### 3. Security Requirements

#### Security Checklist
Before submitting any contribution, ensure:

- [ ] **No secrets** in code (API keys, passwords, tokens)
- [ ] **Dependencies** are updated and vulnerability-free
- [ ] **SAST** scans pass with no high/critical issues
- [ ] **Container images** are scanned and secure
- [ ] **Infrastructure code** follows security best practices
- [ ] **Tests** include security test cases
- [ ] **Documentation** includes security considerations

#### Pre-commit Security Hooks
Our pre-commit hooks automatically run:

```yaml
# .pre-commit-config.yaml (excerpt)
repos:
  - repo: https://github.com/trufflesecurity/trufflehog
    hooks:
      - id: trufflehog
  
  - repo: https://github.com/Yelp/detect-secrets
    hooks:
      - id: detect-secrets

  - repo: https://github.com/bridgecrewio/checkov
    hooks:
      - id: checkov
        args: [--framework, terraform, --framework, kubernetes]
```

#### Security Testing
```bash
# Run comprehensive security tests
npm run security:test

# Specific security scans
npm run security:sast     # Static analysis
npm run security:deps     # Dependency scanning  
npm run security:secrets  # Secret detection
npm run security:containers # Container scanning
npm run security:iac      # Infrastructure scanning
```

### 4. Code Quality Standards

#### Code Style and Linting
```bash
# JavaScript/TypeScript
npm run lint
npm run format

# Python  
flake8 .
black .
isort .
mypy .

# Terraform
terraform fmt -recursive
tflint
```

#### Testing Requirements
- **Unit tests**: Minimum 80% coverage
- **Integration tests**: All API endpoints
- **Security tests**: All security controls
- **End-to-end tests**: Critical user flows

```bash
# Run all tests
npm run test:all

# Run with coverage
npm run test:coverage

# Security-specific tests
npm run test:security
```

### 5. Documentation Standards

#### Required Documentation
For any contribution, please ensure:

1. **Code Documentation**
   ```javascript
   /**
    * Validates user input for security vulnerabilities
    * @param {string} input - User input to validate
    * @param {Object} options - Validation options
    * @param {boolean} options.allowHtml - Whether to allow HTML
    * @returns {Object} Validation result with sanitized input
    * @throws {SecurityError} When input contains malicious content
    * @security Prevents XSS and injection attacks
    */
   function validateInput(input, options = {}) {
     // Implementation
   }
   ```

2. **Security Documentation**
   - Threat model updates
   - Security control descriptions
   - Risk assessments
   - Compliance mappings

3. **Architecture Documentation**
   - System design changes
   - Data flow diagrams
   - Security architecture updates

#### Documentation Format
- Use **Markdown** for all documentation
- Include **diagrams** using Mermaid syntax
- Add **security annotations** for sensitive operations
- Provide **examples** for all APIs and configurations

### 6. Pull Request Process

#### PR Requirements
1. **Description**: Clear description of changes and rationale
2. **Security Impact**: Assessment of security implications
3. **Testing**: Evidence of comprehensive testing
4. **Documentation**: Updated documentation where needed
5. **Compliance**: Confirmation of compliance requirements

#### PR Template
```markdown
## Description
Brief description of changes and motivation.

## Security Impact Assessment
- [ ] No security impact
- [ ] Low security impact - explain
- [ ] Medium security impact - requires security review
- [ ] High security impact - requires CISO approval

## Type of Change
- [ ] Bug fix (non-breaking change)
- [ ] New feature (non-breaking change)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Security fix
- [ ] Infrastructure change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Security tests pass
- [ ] Manual testing completed

## Security Checklist
- [ ] No secrets in code
- [ ] Dependencies updated
- [ ] SAST scans pass
- [ ] Container scans pass (if applicable)
- [ ] Infrastructure scans pass (if applicable)
- [ ] Security documentation updated

## Compliance
- [ ] GDPR compliance maintained
- [ ] SOC 2 controls not impacted
- [ ] Audit trail preserved
- [ ] Data classification respected

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Additional Notes
Any additional information reviewers should know.
```

#### Review Process
1. **Automated Checks**: All CI/CD checks must pass
2. **Peer Review**: At least one code review approval
3. **Security Review**: Required for security-impacting changes
4. **Documentation Review**: Technical writer review for docs

### 7. Issue Reporting

#### Security Issues
**DO NOT** create public issues for security vulnerabilities.

Instead:
1. Email security@yourcompany.com
2. Use GitHub's private vulnerability reporting
3. Include detailed reproduction steps
4. Provide impact assessment

#### Bug Reports
```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**Security Impact** 
Is this a security-related bug? If yes, please email security@yourcompany.com instead.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Environment:**
- OS: [e.g. Ubuntu 20.04]
- Browser: [e.g. chrome, safari]
- Version: [e.g. 22]
- Kubernetes version: [e.g. 1.28]

**Additional context**
Add any other context about the problem here.
```

#### Feature Requests
```markdown
**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Security Considerations**
How might this feature impact security? What security controls are needed?

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Compliance Impact**
Will this feature affect any compliance requirements (SOC2, GDPR, etc.)?

**Additional context**
Add any other context or screenshots about the feature request here.
```

### 8. Community Guidelines

#### Code of Conduct
We are committed to providing a welcoming and inspiring community for all. Please read our [Code of Conduct](CODE_OF_CONDUCT.md).

#### Communication Channels
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and community discussions
- **Slack**: Real-time team communication (invite only)
- **Email**: security@yourcompany.com for security issues

#### Recognition
Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Annual contributor appreciation

### 9. Development Resources

#### Useful Commands
```bash
# Security scanning
make security-scan

# Full test suite
make test-all

# Local development environment
make dev-setup

# Infrastructure deployment
make infra-deploy ENV=dev

# Documentation generation
make docs-generate
```

#### Learning Resources
- [DevSecOps Best Practices](docs/BEST_PRACTICES.md)
- [Security Policy](security/SECURITY_POLICY.md)
- [Architecture Guide](docs/architecture/README.md)
- [API Documentation](docs/api/README.md)

#### Tools and Extensions
Recommended development tools:
- **VS Code Extensions**: ESLint, Prettier, GitLens, Docker
- **Browser Extensions**: OWASP ZAP HUD
- **CLI Tools**: gitleaks, semgrep, checkov, trivy

## ❓ Questions?

If you have questions about contributing, please:
1. Check existing [GitHub Discussions](../../discussions)
2. Review our [documentation](docs/)
3. Contact the maintainers

Thank you for contributing to making this DevSecOps portfolio better and more secure! 🛡️