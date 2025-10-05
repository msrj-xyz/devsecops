#!/bin/bash

# DevSecOps Portfolio Setup Script
# This script automates the initial setup and validation of the DevSecOps portfolio

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing_tools=()
    
    # Check required tools
    local tools=("git" "docker" "node" "npm" "python3" "pip3" "kubectl" "helm" "terraform")
    
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -eq 0 ]; then
        log_success "All prerequisites are installed"
    else
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install the missing tools and run this script again"
        exit 1
    fi
}

# Validate tool versions
check_versions() {
    log_info "Checking tool versions..."
    
    # Node.js version
    local node_version=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$node_version" -lt 18 ]; then
        log_warning "Node.js version $node_version detected. Recommended: 18+"
    else
        log_success "Node.js version: $(node --version)"
    fi
    
    # Python version
    local python_version=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1-2)
    if [[ "$python_version" < "3.9" ]]; then
        log_warning "Python version $python_version detected. Recommended: 3.9+"
    else
        log_success "Python version: $(python3 --version)"
    fi
    
    # Docker version
    log_success "Docker version: $(docker --version)"
    
    # Terraform version
    log_success "Terraform version: $(terraform --version | head -n1)"
    
    # Kubernetes version
    log_success "kubectl version: $(kubectl version --client --short 2>/dev/null || echo "Not connected to cluster")"
}

# Install development dependencies
install_dependencies() {
    log_info "Installing development dependencies..."
    
    # Install Node.js dependencies
    if [ -f "package.json" ]; then
        log_info "Installing Node.js dependencies..."
        npm install
        log_success "Node.js dependencies installed"
    fi
    
    # Install Python dependencies
    if [ -f "requirements.txt" ]; then
        log_info "Installing Python dependencies..."
        pip3 install -r requirements.txt
        log_success "Python dependencies installed"
    fi
    
    if [ -f "requirements-dev.txt" ]; then
        log_info "Installing Python development dependencies..."
        pip3 install -r requirements-dev.txt
        log_success "Python development dependencies installed"
    fi
    
    # Install pre-commit hooks
    if command_exists pre-commit; then
        log_info "Installing pre-commit hooks..."
        pre-commit install
        log_success "Pre-commit hooks installed"
    else
        log_info "Installing pre-commit..."
        pip3 install pre-commit
        pre-commit install
        log_success "Pre-commit installed and hooks configured"
    fi
}

# Setup security tools
setup_security_tools() {
    log_info "Setting up security tools..."
    
    # Install security scanning tools
    local security_tools=("bandit" "safety" "semgrep" "checkov")
    
    for tool in "${security_tools[@]}"; do
        if ! command_exists "$tool"; then
            log_info "Installing $tool..."
            pip3 install "$tool"
        fi
    done
    
    # Install trivy
    if ! command_exists trivy; then
        log_info "Installing Trivy..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install trivy
        fi
    fi
    
    log_success "Security tools setup completed"
}

# Run initial security scan
run_security_scan() {
    log_info "Running initial security scan..."
    
    # Secret scanning
    if command_exists gitleaks; then
        log_info "Running Gitleaks secret scan..."
        gitleaks detect --report-format json --report-path gitleaks-report.json --verbose || log_warning "Gitleaks found potential secrets"
    fi
    
    # Python security scan
    if [ -f "requirements.txt" ] && command_exists bandit; then
        log_info "Running Bandit security scan..."
        bandit -r . -f json -o bandit-report.json || log_warning "Bandit found potential security issues"
    fi
    
    # Dependency vulnerability scan
    if command_exists safety; then
        log_info "Running Safety dependency scan..."
        safety check --json --output safety-report.json || log_warning "Safety found vulnerable dependencies"
    fi
    
    # Infrastructure security scan
    if [ -d "infrastructure" ] && command_exists checkov; then
        log_info "Running Checkov infrastructure scan..."
        checkov -d infrastructure --framework terraform --output json --output-file checkov-report.json || log_warning "Checkov found infrastructure security issues"
    fi
    
    log_success "Initial security scan completed"
}

# Validate Terraform configuration
validate_terraform() {
    if [ -d "infrastructure/terraform" ]; then
        log_info "Validating Terraform configuration..."
        cd infrastructure/terraform
        
        # Initialize Terraform (without backend)
        terraform init -backend=false
        
        # Validate configuration
        terraform validate
        
        # Format check
        terraform fmt -check -recursive || {
            log_warning "Terraform files need formatting. Running terraform fmt..."
            terraform fmt -recursive
        }
        
        cd - > /dev/null
        log_success "Terraform validation completed"
    fi
}

# Setup development environment
setup_dev_environment() {
    log_info "Setting up development environment..."
    
    # Create necessary directories
    mkdir -p logs reports temp
    
    # Setup Git hooks
    if [ -d ".git" ]; then
        log_info "Configuring Git settings..."
        git config --local init.defaultBranch main
        git config --local pull.rebase false
        
        # Setup Git attributes for security
        cat > .gitattributes << EOF
# Security-sensitive files
*.key binary
*.pem binary
*.p12 binary
*.pfx binary
secrets.* binary
.env* binary

# Documentation
*.md linguist-documentation
*.txt linguist-documentation
EOF
    fi
    
    # Setup VS Code settings (if .vscode doesn't exist)
    if [ ! -d ".vscode" ]; then
        mkdir -p .vscode
        cat > .vscode/settings.json << EOF
{
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true,
        "source.organizeImports": true
    },
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.banditEnabled": true,
    "terraform.experimentalFeatures.validateOnSave": true,
    "files.associations": {
        "*.tf": "terraform",
        "*.tfvars": "terraform"
    },
    "yaml.schemas": {
        "kubernetes": "k8s-*.yaml"
    }
}
EOF
        
        cat > .vscode/extensions.json << EOF
{
    "recommendations": [
        "ms-python.python",
        "ms-python.flake8",
        "ms-vscode.vscode-typescript-next",
        "hashicorp.terraform",
        "ms-kubernetes-tools.vscode-kubernetes-tools",
        "redhat.vscode-yaml",
        "ms-vscode.docker",
        "github.vscode-pull-request-github",
        "eamodio.gitlens"
    ]
}
EOF
    fi
    
    log_success "Development environment setup completed"
}

# Run tests
run_tests() {
    log_info "Running tests..."
    
    # Run Node.js tests if package.json exists
    if [ -f "package.json" ] && grep -q '"test"' package.json; then
        log_info "Running Node.js tests..."
        npm test
    fi
    
    # Run Python tests if pytest is available
    if command_exists pytest && [ -d "tests" ]; then
        log_info "Running Python tests..."
        pytest tests/ --verbose
    fi
    
    log_success "Tests completed"
}

# Generate project documentation
generate_docs() {
    log_info "Generating project documentation..."
    
    # Create documentation structure if it doesn't exist
    mkdir -p docs/{architecture,api,tutorials,security}
    
    # Generate API documentation if available
    if [ -f "package.json" ] && command_exists jsdoc; then
        log_info "Generating JavaScript API documentation..."
        jsdoc -d docs/api/ -r .
    fi
    
    if command_exists sphinx-build && [ -f "docs/conf.py" ]; then
        log_info "Generating Python documentation..."
        sphinx-build -b html docs docs/_build/html
    fi
    
    log_success "Documentation generation completed"
}

# Main execution
main() {
    echo "=================================================================="
    echo "🛡️  DevSecOps Portfolio Setup Script"
    echo "=================================================================="
    echo ""
    
    log_info "Starting DevSecOps portfolio setup..."
    
    # Run setup steps
    check_prerequisites
    check_versions
    install_dependencies
    setup_security_tools
    setup_dev_environment
    validate_terraform
    run_security_scan
    run_tests
    generate_docs
    
    echo ""
    echo "=================================================================="
    log_success "🎉 DevSecOps portfolio setup completed successfully!"
    echo "=================================================================="
    echo ""
    echo "Next steps:"
    echo "1. Review security scan reports in the current directory"
    echo "2. Configure your cloud provider credentials"
    echo "3. Update environment-specific variables in infrastructure/terraform/environments/"
    echo "4. Run 'terraform plan' to preview infrastructure changes"
    echo "5. Start contributing following the guidelines in CONTRIBUTING.md"
    echo ""
    echo "For more information, see:"
    echo "- README.md for project overview"
    echo "- docs/BEST_PRACTICES.md for development guidelines"
    echo "- security/SECURITY_POLICY.md for security policies"
    echo ""
}

# Script options
case "${1:-}" in
    --help|-h)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h          Show this help message"
        echo "  --security-only     Run only security-related setup"
        echo "  --terraform-only    Run only Terraform validation"
        echo "  --no-tests         Skip running tests"
        echo ""
        exit 0
        ;;
    --security-only)
        log_info "Running security-only setup..."
        check_prerequisites
        setup_security_tools
        run_security_scan
        ;;
    --terraform-only)
        log_info "Running Terraform validation only..."
        check_prerequisites
        validate_terraform
        ;;
    --no-tests)
        log_info "Running setup without tests..."
        check_prerequisites
        check_versions
        install_dependencies
        setup_security_tools
        setup_dev_environment
        validate_terraform
        run_security_scan
        generate_docs
        ;;
    *)
        main
        ;;
esac