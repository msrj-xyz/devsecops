# Pull Request

## 📝 Description
Brief description of changes and motivation.

Fixes #(issue number)

## 🔒 Security Impact Assessment
- [ ] **No security impact** - This change does not affect security
- [ ] **Low security impact** - Minor security consideration (explain below)
- [ ] **Medium security impact** - Moderate security implications (requires security review)
- [ ] **High security impact** - Significant security changes (requires CISO approval)

### Security Details (if applicable)
<!-- Explain any security implications, new attack vectors, or security controls affected -->

## 🔄 Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🔧 Refactoring (no functional changes)
- [ ] 🧪 Test improvements
- [ ] 🔒 Security enhancement
- [ ] 🏗️ Infrastructure changes
- [ ] 🎨 UI/UX improvements

## 🧪 Testing
### Tests Added/Updated
- [ ] Unit tests
- [ ] Integration tests
- [ ] End-to-end tests
- [ ] Security tests
- [ ] Performance tests

### Test Results
- [ ] All new and existing tests pass
- [ ] Test coverage maintained/improved
- [ ] Manual testing completed

### Security Testing (if applicable)
- [ ] SAST scanning completed
- [ ] Dependency scanning completed
- [ ] Container scanning completed (if applicable)
- [ ] Infrastructure scanning completed (if applicable)
- [ ] Manual security testing completed

## 📋 Checklist
### Code Quality
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works

### Security Checklist
- [ ] No secrets, credentials, or sensitive data in code
- [ ] Input validation implemented where needed
- [ ] Output encoding/escaping implemented where needed
- [ ] Authentication/authorization properly implemented
- [ ] Error messages don't leak sensitive information
- [ ] Logging doesn't expose sensitive data
- [ ] Dependencies are up to date and vulnerability-free

### Documentation
- [ ] I have made corresponding changes to the documentation
- [ ] I have updated the README.md if needed
- [ ] I have added/updated API documentation if applicable
- [ ] I have updated security documentation if applicable

### Compliance
- [ ] Changes maintain GDPR compliance
- [ ] Changes maintain SOC 2 compliance  
- [ ] Changes align with security policies
- [ ] Audit trail is preserved
- [ ] Data classification is respected

## 🔄 Breaking Changes
<!-- If this is a breaking change, describe what breaks and how to migrate -->

## 📸 Screenshots (if applicable)
<!-- Add screenshots to help explain your changes -->

## 🏗️ Infrastructure Changes
<!-- If this PR affects infrastructure, describe the changes -->
- [ ] Terraform changes
- [ ] Kubernetes manifests updated
- [ ] Docker images modified
- [ ] CI/CD pipeline changes
- [ ] Monitoring/alerting updates

## 📊 Performance Impact
<!-- Describe any performance implications -->
- [ ] No performance impact
- [ ] Performance improved
- [ ] Performance regression (explain and justify)
- [ ] Performance testing completed

## 🔄 Deployment Notes
<!-- Special instructions for deployment -->
- [ ] No special deployment steps required
- [ ] Database migrations needed
- [ ] Configuration changes required  
- [ ] Infrastructure updates needed
- [ ] Rollback plan documented

## 📚 Additional Notes
<!-- Any additional information that reviewers should know -->

## 👥 Reviewers
<!-- @ mention specific reviewers if needed -->
- Security review: @msrj-xyz (if security impact)
- Technical review: @msrj-xyz
- Documentation review: @msrj-xyz (if doc changes)

---

**By submitting this PR, I confirm that:**
- [ ] I have read and followed the [Contributing Guidelines](../CONTRIBUTING.md)
- [ ] I have read and agree to the [Code of Conduct](../CODE_OF_CONDUCT.md)
- [ ] I understand that this PR will be reviewed for security implications
- [ ] I am willing to make changes based on feedback