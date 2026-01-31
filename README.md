# Cost Diff Bot Test Repository 🤖

This repository is set up to test the Cost Diff Bot GitHub App.

**Testing timestamp:** 2026-01-30 (Production readiness testing with ap-southeast-1 pricing)

## Current Test Infrastructure (ap-southeast-1)

### Test Scenario: Production Web Application Stack
This repository contains a realistic Terraform configuration for testing cost analysis:

**Infrastructure Components:**
- **2x EC2 t3.medium instances** (web servers)  
- **1x NAT Gateway** (for private subnet access)
- **1x EBS GP3 volume** (100GB with 4000 IOPS, 200MB/s throughput)
- **1x RDS PostgreSQL db.t3.small** (database)
- **VPC with public/private subnets** (networking)

**Expected Monthly Costs (ap-southeast-1):**
- EC2 (2x t3.medium): ~$74.68
- NAT Gateway: ~$35.04  
- EBS GP3 (100GB): ~$8.80
- RDS (db.t3.small): ~$19.69
- **Total: ~$138.21/month**

*Note: ap-southeast-1 costs are ~17.9% higher than us-east-1*

### Configuration
- `.costbot.yml` - Bot configuration with custom thresholds for testing

## How to Test

1. Create a new branch
2. Add/modify one of the test files
3. Create a Pull Request
4. Watch for the bot comment and Check Run status

## Expected Bot Behavior

✅ Posts cost analysis comment
✅ Sets "Cost Diff" Check Run status  
✅ Updates comment when PR changes
✅ Respects policy thresholds in `.costbot.yml`


githgub app
forward traffic:
npx smee -u https://smee.io/HIqH0PxNaezRNlw -t http://127.0.0.1:3000/api/github/webhooks