#!/bin/bash
# copy-to-repo.sh - Script to copy test files to your GitHub repository

REPO_PATH=$1

if [ -z "$REPO_PATH" ]; then
    echo "Usage: ./copy-to-repo.sh /path/to/your/test/repository"
    echo "Example: ./copy-to-repo.sh ../my-test-repo"
    exit 1
fi

if [ ! -d "$REPO_PATH" ]; then
    echo "Error: Directory $REPO_PATH does not exist"
    exit 1
fi

echo "Copying test files to $REPO_PATH..."

# Copy configuration
cp test-repo-files/.costbot.yml "$REPO_PATH/"
echo "✅ Copied .costbot.yml"

# Copy terraform files
mkdir -p "$REPO_PATH/terraform"
cp test-repo-files/terraform/*.json "$REPO_PATH/terraform/"
echo "✅ Copied Terraform test files"

# Copy cloudformation files  
mkdir -p "$REPO_PATH/cloudformation"
cp test-repo-files/cloudformation/*.yaml "$REPO_PATH/cloudformation/"
echo "✅ Copied CloudFormation test files"

# Copy documentation
cp test-repo-files/README.md "$REPO_PATH/"
cp test-repo-files/TESTING_GUIDE.md "$REPO_PATH/"
echo "✅ Copied documentation"

echo ""
echo "🎉 Test files copied successfully!"
echo ""
echo "Next steps:"
echo "1. cd $REPO_PATH"
echo "2. git add ."
echo "3. git commit -m 'Add cost analysis test files'"
echo "4. git push"
echo "5. Create a PR with one of the terraform/*.json files"
