# Quick Test Guide

## 🚀 Test Your Cost Diff Bot

### Setup
1. Copy these files to a GitHub repository where your bot is installed
2. Make sure your bot is running and webhook forwarding is active

### Test Scenarios

#### Test 1: Basic Resources (Should Pass) 
**Files:** `terraform/plan.json`
- Expected cost: ~$28/month (t3.small + 100GB GP3 + NAT Gateway)
- Expected result: ✅ Success (under $25 threshold)

#### Test 2: Expensive Resources (Should Warn/Fail)
**Files:** `terraform/expensive-plan.json` 
- Expected cost: ~$150+/month (c5.xlarge + 500GB GP3 + db.r5.large)
- Expected result: ❌ Failure (over $25 threshold)

#### Test 3: Cost Savings (Negative Delta)
**Files:** `terraform/cost-savings-plan.json`
- Expected savings: ~$100/month (deleting t3.large + NAT Gateway + storage)
- Expected result: ✅ Success with negative cost delta

#### Test 4: CloudFormation Template
**Files:** `cloudformation/stack.yaml`
- Test by modifying instance types or adding/removing resources
- Expected result: CFN diff analysis

### How to Test

1. **Create a new branch** in your test repo
2. **Add one of the test files** (choose a scenario)
3. **Commit and create a Pull Request**
4. **Check for:**
   - Bot comment with cost breakdown
   - "Cost Diff" Check Run status
   - Logs in your bot terminal

### Example Commands

```bash
# Create test branch
git checkout -b test-cost-analysis

# Copy basic test
cp test-repo-files/terraform/plan.json terraform/
git add terraform/plan.json
git commit -m "Add terraform plan for cost analysis"

# Push and create PR
git push origin test-cost-analysis
# Then create PR via GitHub UI
```

### Expected Bot Comment Format

```markdown
## 💰 Cost Impact Analysis

📈 **Estimated monthly cost increase: $28.45**

⚠️ **WARNING**: Cost change exceeds warning threshold of $10

### Resource Changes
| Service | Resource | Action | Monthly Δ | Notes |
|---------|----------|--------|-----------|-------|
| ec2 | `aws_instance.web` | ➕ create | +$15.18 | Instance type: t3.small |
| ebs | `aws_ebs_volume.data` | ➕ create | +$8.00 | GP3 100GB |
| nat_gateway | `aws_nat_gateway.main` | ➕ create | +$32.40 | - |
```

### Troubleshooting

- **No bot comment?** Check webhook delivery in GitHub App settings
- **Bot not responding?** Check logs in your dev terminal  
- **Wrong calculations?** Verify resource types match our pricing data
- **Check Run missing?** Ensure app has "Checks" write permission
