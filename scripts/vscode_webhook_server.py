#!/usr/bin/env python3
"""
VS Code Webhook Server for Amp Integration
Runs a local webhook endpoint that Amp can interact with for CI feedback
"""

import json
import os
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime
import threading
import time

class AmpWebhookHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        """Handle incoming webhook POSTs from GitHub Actions"""
        try:
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            payload = json.loads(post_data.decode('utf-8'))
            
            print(f"🔔 Webhook received: {payload.get('message', 'Unknown')}")
            
            # Generate agent feedback
            self.generate_agent_feedback(payload)
            
            # Send success response
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({
                "status": "success", 
                "message": "Agent feedback generated"
            }).encode())
            
        except Exception as e:
            print(f"❌ Webhook error: {e}")
            self.send_response(500)
            self.end_headers()
    
    def do_GET(self):
        """Health check endpoint"""
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        html_response = """
        <html><body>
        <h2>Amp Webhook Server Running</h2>
        <p>EventFlow CI integration active!</p>
        <p>Ready to receive GitHub Actions failure notifications.</p>
        </body></html>
        """
        self.wfile.write(html_response.encode('utf-8'))
    
    def generate_agent_feedback(self, payload):
        """Generate structured feedback for Amp"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M')
        
        feedback = f"""# 🚨 Live CI Failure - Amp Action Required

## Webhook Notification - {timestamp}

**Repository**: {payload.get('repository', 'Unknown')}
**Branch**: {payload.get('branch', 'Unknown')}  
**Commit**: {payload.get('commit', 'Unknown')[:8]}
**Workflow**: {payload.get('workflow', 'Unknown')}
**Status**: {payload.get('status', 'failed')}

## 🤖 Automated Detection

This failure was detected by GitHub Actions and automatically reported via webhook integration.

## 🎯 Immediate Actions for Amp

1. **Download GitHub Actions artifacts** from: {payload.get('artifacts_url', 'Check GitHub Actions')}
2. **Check test_reports/failures.txt** for specific test failures
3. **Review test_reports/analysis.txt** for static analysis issues
4. **Fix failing tests** using the error messages provided
5. **Run tests locally** to verify fixes: `flutter test`
6. **Push fixes** and monitor next CI run

## 📋 VS Code Integration Active

- **Webhook server running** at http://localhost:8080
- **Real-time CI monitoring** enabled
- **Amp notification system** ready for automated fixes

**Amp**: Please read the failure details and fix the issues systematically.
"""
        
        # Write feedback file for Amp to read
        with open('AGENT_FEEDBACK.md', 'w') as f:
            f.write(feedback)
        
        print(f"✅ Agent feedback generated: AGENT_FEEDBACK.md")
        print(f"📋 Amp can now read and fix the CI failures!")
        
        # Create VS Code notification file
        with open('.vscode/amp_notification.md', 'w') as f:
            f.write(f"""# 🚨 Amp: CI Failure Detected

{payload.get('message', 'CI tests failed')}

**Action Required**: Read AGENT_FEEDBACK.md and fix the failing tests.

Time: {timestamp}
""")
    
    def log_message(self, format, *args):
        """Custom logging for cleaner output"""
        print(f"[{datetime.now().strftime('%H:%M:%S')}] {format % args}")

def start_webhook_server():
    """Start the webhook server for Amp integration"""
    port = 8080
    server = HTTPServer(('localhost', port), AmpWebhookHandler)
    
    print(f"🚀 Amp Webhook Server starting on http://localhost:{port}")
    print(f"🔗 Configure GitHub webhook to POST to this URL")
    print(f"📡 Ready to receive CI failure notifications for Amp...")
    print(f"🛑 Press Ctrl+C to stop")
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print(f"\n🛑 Webhook server stopped")
        server.shutdown()

if __name__ == "__main__":
    start_webhook_server()
