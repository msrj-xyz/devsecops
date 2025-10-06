#!/bin/bash
# Complete Multi-Environment Setup Script
# Sets up development, staging, and production environments

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BASE_PROJECT_NAME="devsecops-portfolio"
ENVIRONMENTS=("dev" "staging" "prod")
REGION="us-central1"

echo -e "${BLUE}🌟 DevSecOps Multi-Environment Setup${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    print_error "gcloud CLI is not installed. Please install it first."
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n1 > /dev/null; then
    print_error "Please authenticate with gcloud first: gcloud auth login"
    exit 1
fi

echo -e "${YELLOW}Choose setup option:${NC}"
echo "1) Single project with multiple service accounts (Recommended for demo/portfolio)"
echo "2) Multiple projects (Enterprise approach)"
echo ""
read -p "Enter choice (1 or 2): " setup_choice

if [ "$setup_choice" = "1" ]; then
    # Single project setup
    PROJECT_ID="${BASE_PROJECT_NAME}-001"
    
    print_info "Setting up single project: $PROJECT_ID"
    
    # Create project if it doesn't exist
    if ! gcloud projects describe $PROJECT_ID &> /dev/null; then
        print_info "Creating project: $PROJECT_ID"
        gcloud projects create $PROJECT_ID --name="DevSecOps Portfolio"
        print_status "Project created: $PROJECT_ID"
    else
        print_status "Project already exists: $PROJECT_ID"
    fi
    
    # Set active project
    gcloud config set project $PROJECT_ID
    
    # Enable required APIs
    print_info "Enabling required APIs..."
    gcloud services enable \
        container.googleapis.com \
        artifactregistry.googleapis.com \
        cloudbuild.googleapis.com \
        secretmanager.googleapis.com \
        monitoring.googleapis.com \
        logging.googleapis.com \
        cloudkms.googleapis.com \
        securitycenter.googleapis.com \
        binaryauthorization.googleapis.com \
        containeranalysis.googleapis.com
    
    print_status "APIs enabled successfully"
    
    # Create service accounts for each environment
    for env in "${ENVIRONMENTS[@]}"; do
        SA_NAME="github-actions-${env}-sa"
        print_info "Creating service account: $SA_NAME"
        
        if ! gcloud iam service-accounts describe ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com &> /dev/null; then
            gcloud iam service-accounts create $SA_NAME \
                --display-name="GitHub Actions ${env^} SA" \
                --description="Service account for ${env} environment"
            print_status "Service account created: $SA_NAME"
        else
            print_status "Service account already exists: $SA_NAME"
        fi
        
        # Assign roles based on environment
        case $env in
            "dev")
                ROLES=(
                    "roles/container.developer"
                    "roles/artifactregistry.writer"
                    "roles/cloudbuild.builds.editor"
                    "roles/secretmanager.accessor"
                    "roles/logging.viewer"
                )
                ;;
            "staging")
                ROLES=(
                    "roles/container.developer"
                    "roles/artifactregistry.writer"
                    "roles/cloudbuild.builds.editor"
                    "roles/secretmanager.accessor"
                    "roles/monitoring.editor"
                    "roles/logging.admin"
                )
                ;;
            "prod")
                ROLES=(
                    "roles/container.admin"
                    "roles/artifactregistry.admin"
                    "roles/cloudbuild.builds.editor"
                    "roles/compute.admin"
                    "roles/iam.serviceAccountUser"
                    "roles/secretmanager.accessor"
                    "roles/monitoring.admin"
                    "roles/logging.admin"
                )
                ;;
        esac
        
        # Assign roles
        for role in "${ROLES[@]}"; do
            gcloud projects add-iam-policy-binding $PROJECT_ID \
                --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
                --role="$role" > /dev/null
        done
        print_status "Roles assigned for ${env} environment"
        
        # Create artifact registry for environment
        REPO_NAME="devsecops-${env}-repo"
        if ! gcloud artifacts repositories describe $REPO_NAME --location=$REGION &> /dev/null; then
            gcloud artifacts repositories create $REPO_NAME \
                --repository-format=docker \
                --location=$REGION \
                --description="Container images for ${env} environment"
            print_status "Artifact registry created: $REPO_NAME"
        else
            print_status "Artifact registry already exists: $REPO_NAME"
        fi
        
        # Generate service account key
        KEY_FILE="github-actions-${env}-key.json"
        gcloud iam service-accounts keys create $KEY_FILE \
            --iam-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
        print_status "Service account key generated: $KEY_FILE"
    done
    
else
    # Multiple projects setup
    print_info "Setting up multiple projects for each environment"
    
    for env in "${ENVIRONMENTS[@]}"; do
        PROJECT_ID="${BASE_PROJECT_NAME}-${env}"
        print_info "Setting up project: $PROJECT_ID"
        
        # Create project
        if ! gcloud projects describe $PROJECT_ID &> /dev/null; then
            gcloud projects create $PROJECT_ID --name="DevSecOps ${env^}"
            print_status "Project created: $PROJECT_ID"
        else
            print_status "Project already exists: $PROJECT_ID"
        fi
        
        # Set active project
        gcloud config set project $PROJECT_ID
        
        # Enable APIs
        print_info "Enabling APIs for $PROJECT_ID..."
        gcloud services enable \
            container.googleapis.com \
            artifactregistry.googleapis.com \
            cloudbuild.googleapis.com \
            secretmanager.googleapis.com \
            monitoring.googleapis.com \
            logging.googleapis.com > /dev/null
        
        # Create service account
        SA_NAME="github-actions-sa"
        if ! gcloud iam service-accounts describe ${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com &> /dev/null; then
            gcloud iam service-accounts create $SA_NAME \
                --display-name="GitHub Actions SA" \
                --description="Service account for GitHub Actions"
            print_status "Service account created for $PROJECT_ID"
        fi
        
        # Generate key
        KEY_FILE="github-actions-${env}-key.json"
        gcloud iam service-accounts keys create $KEY_FILE \
            --iam-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
        print_status "Key generated: $KEY_FILE"
    done
fi

# Generate GitHub secrets output
echo ""
echo -e "${BLUE}📋 GitHub Secrets Configuration${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

for env in "${ENVIRONMENTS[@]}"; do
    KEY_FILE="github-actions-${env}-key.json"
    
    case $env in
        "dev") 
            ENV_DISPLAY="🔵 DEVELOPMENT"
            ENV_UPPER="DEV"
            ;;
        "staging")
            ENV_DISPLAY="🟡 STAGING"  
            ENV_UPPER="STAGING"
            ;;
        "prod")
            ENV_DISPLAY="🔴 PRODUCTION"
            ENV_UPPER="PROD"
            ;;
    esac
    
    echo -e "${YELLOW}${ENV_DISPLAY} ENVIRONMENT:${NC}"
    echo "Secret Name: GOOGLE_CREDENTIALS_${ENV_UPPER}"
    echo "Secret Value:"
    cat $KEY_FILE
    echo ""
    
    if [ "$setup_choice" = "1" ]; then
        PROJECT_ID="${BASE_PROJECT_NAME}-001"
        SA_EMAIL="github-actions-${env}-sa@${PROJECT_ID}.iam.gserviceaccount.com"
    else
        PROJECT_ID="${BASE_PROJECT_NAME}-${env}"
        SA_EMAIL="github-actions-sa@${PROJECT_ID}.iam.gserviceaccount.com"
    fi
    
    echo "Secret Name: GCP_PROJECT_ID_${ENV_UPPER}"
    echo "Secret Value: $PROJECT_ID"
    echo ""
    echo "Secret Name: GCP_SA_EMAIL_${ENV_UPPER}"
    echo "Secret Value: $SA_EMAIL"
    echo ""
    echo "Secret Name: ARTIFACT_REGISTRY_${ENV_UPPER}"
    echo "Secret Value: devsecops-${env}-repo"
    echo ""
    echo "---"
    echo ""
done

echo -e "${GREEN}🎉 Multi-environment setup completed!${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Copy the secrets above to GitHub repository settings"
echo "2. Create GitHub environments (development, staging, production)"
echo "3. Add environment-specific secrets to each GitHub environment"
echo "4. Configure deployment protection rules"
echo "5. Test deployments to each environment"
echo ""
echo -e "${RED}🔒 SECURITY REMINDER:${NC}"
echo "Delete all .json key files after copying to GitHub:"
echo "rm github-actions-*-key.json"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "See docs/MULTI_ENVIRONMENT_SETUP.md for detailed configuration"