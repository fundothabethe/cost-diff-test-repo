# Cost Diff Bot Test Repository 🤖

This repository is set up to test the Cost Diff Bot GitHub App.

**Testing timestamp:** 2026-01-24 18:37 (Debug CloudFormation parsing error)

## Test Files

### Terraform Test
- `terraform/plan.json` - Contains a Terraform plan with EC2 and EBS resources
- Expected result: Bot should calculate costs for t3.small instance + 100GB GP3 volume

### CloudFormation Test  
- `cloudformation/stack.yaml` - Contains CFN template with multiple AWS resources
- Expected result: Bot should analyze resource changes between template versions

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

forward traffic:
npx smee -u https://smee.io/HIqH0PxNaezRNlw -t http://127.0.0.1:3000/api/github/webhooks