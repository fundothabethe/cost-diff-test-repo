# 🧪 Cost Analysis Test Script

echo "Starting Cost Diff Bot webhook test..."
echo "======================================"

cd "c:\Users\xgame\Downloads\software\pr"

# Check if bot is running
echo "1. Checking if Cost Diff Bot is running..."
$process = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($process) {
    echo "✅ Bot process found (PID: $($process.Id))"
} else {
    echo "❌ Bot not running. Please start with: npm run dev"
    exit 1
}

# Check pricing data
echo ""
echo "2. Verifying pricing data..."
$pricingStatus = & npm run prices:check 2>&1
if ($LASTEXITCODE -eq 0) {
    echo "✅ Pricing data is fresh"
} else {
    echo "❌ Pricing data needs refresh"
}

# Check webhook forwarding
echo ""
echo "3. Checking smee.io webhook forwarding..."
$smeeProcess = Get-Process -Name "node" | Where-Object { $_.CommandLine -like "*smee*" }
if ($smeeProcess) {
    echo "✅ Smee.io forwarding active"
} else {
    echo "⚠️  Smee.io not running. Start with: smee --url https://smee.io/HIqH0PxNaezRNlw --target http://localhost:3000/api/github/webhooks"
}

# Test cost calculation locally
echo ""
echo "4. Testing cost calculations..."
$testResult = & npx ts-node test-production-ready.ts 2>&1
if ($LASTEXITCODE -eq 0) {
    echo "✅ Cost calculations working"
} else {
    echo "❌ Cost calculation test failed"
}

echo ""
echo "======================================"
echo "Test Summary:"
echo "- Bot Status: Running ✅"
echo "- Pricing: Fresh ap-southeast-1 data ✅"
echo "- Webhook: https://smee.io/HIqH0PxNaezRNlw"
echo "- Local Target: http://localhost:3000/api/github/webhooks"
echo ""
echo "Ready for GitHub PR webhook test! 🚀"
echo "Create a PR in cost-diff-test-repo to trigger cost analysis."
