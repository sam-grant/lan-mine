#!/usr/bin/env python3
"""
lan-mine Desktop App
Standalone executable that starts the server and opens browser
"""

import sys
import os
from pathlib import Path
import webbrowser
import time
import signal

# Add parent directory to path to import Flask app
sys.path.insert(0, str(Path(__file__).parent.parent))

from app import app

def open_browser():
    """Open browser after server starts"""
    time.sleep(1.5)
    print("\nOpening lan-mine in your browser...")
    try:
        # Try to open browser as the actual user (not root)
        if os.geteuid() == 0:  # Running as root
            # Get the original user
            sudo_user = os.environ.get('SUDO_USER')
            if sudo_user:
                # Run browser as the original user
                os.system(f'sudo -u {sudo_user} xdg-open http://127.0.0.1:5000 2>/dev/null &')
            else:
                webbrowser.open('http://127.0.0.1:5000')
        else:
            webbrowser.open('http://127.0.0.1:5000')
    except Exception as e:
        print(f"Could not auto-open browser: {e}")
        print("Please manually open: http://127.0.0.1:5000")

def signal_handler(sig, frame):
    """Handle Ctrl+C gracefully"""
    print("\n\nShutting down lan-mine...")
    sys.exit(0)

def main():
    # Register signal handler
    signal.signal(signal.SIGINT, signal_handler)
    
    # Start browser opener in background
    import threading
    browser_thread = threading.Thread(target=open_browser, daemon=True)
    browser_thread.start()
    
    # Start Flask server (this blocks)
    print("=" * 60)
    print("lan-mine")
    print("=" * 60)
    print("\nStarting web server...")
    print("Access the web UI at: http://localhost:5000")
    print("\nPress Ctrl+C to stop\n")
    
    app.run(host='127.0.0.1', port=5000, debug=False, use_reloader=False)

if __name__ == '__main__':
    main()
