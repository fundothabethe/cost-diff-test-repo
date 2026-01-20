# copy-to-repo.ps1 - PowerShell script to copy test files to your GitHub repository

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoPath
)

if (-not (Test-Path $RepoPath)) {
    Write-Error "Directory $RepoPath does not exist"
    exit 1
}

Write-Host "Copying test files to $RepoPath..." -ForegroundColor Green

# Copy configuration
Copy-Item "test-repo-files\.costbot.yml" "$RepoPath\" -Force
Write-Host "✅ Copied .costbot.yml" -ForegroundColor Green

# Copy terraform files
$terraformDir = Join-Path $RepoPath "terraform"
if (-not (Test-Path $terraformDir)) {
    New-Item -ItemType Directory -Path $terraformDir | Out-Null
}
Copy-Item "test-repo-files\terraform\*.json" $terraformDir -Force
Write-Host "✅ Copied Terraform test files" -ForegroundColor Green

# Copy cloudformation files
$cfnDir = Join-Path $RepoPath "cloudformation" 
if (-not (Test-Path $cfnDir)) {
    New-Item -ItemType Directory -Path $cfnDir | Out-Null
}
Copy-Item "test-repo-files\cloudformation\*.yaml" $cfnDir -Force
Write-Host "✅ Copied CloudFormation test files" -ForegroundColor Green

# Copy documentation
Copy-Item "test-repo-files\README.md" "$RepoPath\" -Force
Copy-Item "test-repo-files\TESTING_GUIDE.md" "$RepoPath\" -Force
Write-Host "✅ Copied documentation" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Test files copied successfully!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. cd $RepoPath"
Write-Host "2. git add ."
Write-Host "3. git commit -m 'Add cost analysis test files'"
Write-Host "4. git push"
Write-Host "5. Create a PR with one of the terraform/*.json files"
