#!/bin/bash
# Test webhook integration locally

echo "🧪 Testing webhook integration locally"

# Create test failure payload
cat > test_failure_payload.json << EOL
{
  "repository": "Josh-thephillipsequation/Eventflow",
  "branch": "feature/core-ci-testing-foundation",
  "commit": "bb8c587f1234567890abcdef",
  "workflow": "EventFlow CI/CD Pipeline",
  "job": "test",
  "status": "failed",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "artifacts_url": "https://github.com/Josh-thephillipsequation/Eventflow/actions/runs/123456",
  "message": "EventFlow CI tests failed - agent feedback required"
}
EOL

# Process the test payload
python3 scripts/process_ci_webhook.py test_failure_payload.json

echo "🎯 Webhook test complete! Check AGENT_FEEDBACK_WEBHOOK.md"
rm test_failure_payload.json
