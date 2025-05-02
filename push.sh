#!/usr/bin/env bash

# GitHub Push Script for Python Files
# This script organizes Python files into folders based on filenames and pushes them to GitHub

# Set these variables before running
GITHUB_REPO_URL="https://github.com/myamusashi/04tplp008.git"
BRANCH_NAME="main"  # or master, depending on your default branch

echo "Starting GitHub file organization and push script..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

# Create a temporary directory for organizing files
TEMP_DIR="temp_repo_$(date +%s)"
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# Clone the repository (if it exists)
echo "Cloning repository..."
if git clone $GITHUB_REPO_URL .; then
    echo "Repository cloned successfully."
else
    echo "Repository not found or inaccessible. Initializing a new repository..."
    git init
    git remote add origin $GITHUB_REPO_URL
fi

# Ensure we're on the right branch
git checkout $BRANCH_NAME 2>/dev/null || git checkout -b $BRANCH_NAME

# Move back to original directory to process files
cd ..

# Find all Python files in the current directory
echo "Finding Python files..."
for pyfile in *.py; do
    # Check if the file exists (to handle case where no .py files are found)
    if [ -f "$pyfile" ]; then
        echo "Processing $pyfile..."
        
        # Create folder based on filename (without extension)
        folder_name="${pyfile%.py}"
        
        # Create folder in the repo
        mkdir -p "$TEMP_DIR/$folder_name"
        
        # Copy Python file to its folder
        cp "$pyfile" "$TEMP_DIR/$folder_name/"
        
        echo "Organized $pyfile into folder $folder_name"
    fi
done

# Go back to the repo directory
cd $TEMP_DIR

# Add all files to git
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "No changes to commit."
else
    # Commit changes
    echo "Committing changes..."
    git commit -m "Organized Python files into folders based on filenames"
    
    # Push to GitHub
    echo "Pushing to GitHub..."
    git push -u origin $BRANCH_NAME
    
    echo "Successfully pushed to GitHub!"
fi

# Clean up
cd ..
echo "Cleaning up temporary directory..."
rm -rf $TEMP_DIR

echo "Script completed!"
