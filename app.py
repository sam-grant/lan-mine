#!/usr/bin/env python3
"""
LAN Device Scanner - Web UI
A simple Flask application to scan and display all devices on your local network.
"""

from flask import Flask, render_template, jsonify
import subprocess
import re
import socket
from datetime import datetime
import netifaces
import ipaddress

app = Flask(__name__)

def get_default_gateway_and_network():
    """Get the default gateway and calculate the network range."""
    try:
        gws = netifaces.gateways()
        default_gateway = gws['default'][netifaces.AF_INET][0]
        default_iface = gws['default'][netifaces.AF_INET][1]
        
        # Get the IP address and netmask for the default interface
        addrs = netifaces.ifaddresses(default_iface)
        ip_info = addrs[netifaces.AF_INET][0]
        ip_addr = ip_info['addr']
        netmask = ip_info['netmask']
        
        # Calculate network
        network = ipaddress.IPv4Network(f"{ip_addr}/{netmask}", strict=False)
        
        return str(network), default_gateway, ip_addr
    except Exception as e:
        print(f"Error getting network info: {e}")
        return "192.168.1.0/24", "192.168.1.1", "192.168.1.100"

def scan_network():
    """Scan the local network for devices using nmap."""
    try:
        network_range, gateway, local_ip = get_default_gateway_and_network()
        print(f"Scanning network: {network_range}")
        
        # Run nmap scan
        # -sn: Ping scan (no port scan)
        # -T4: Faster execution
        cmd = ['nmap', '-sn', '-T4', network_range]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        
        devices = []
        current_device = {}
        
        for line in result.stdout.split('\n'):
            # Match IP address lines
            ip_match = re.search(r'Nmap scan report for (?:(.+) \()?(\d+\.\d+\.\d+\.\d+)\)?', line)
            if ip_match:
                if current_device:
                    devices.append(current_device)
                
                hostname = ip_match.group(1) if ip_match.group(1) else 'Unknown'
                ip = ip_match.group(2)
                current_device = {
                    'ip': ip,
                    'hostname': hostname.strip() if hostname else 'Unknown',
                    'mac': 'N/A',
                    'vendor': 'N/A',
                    'is_gateway': ip == gateway,
                    'is_local': ip == local_ip
                }
            
            # Match MAC address lines
            mac_match = re.search(r'MAC Address: ([0-9A-F:]+) \((.+)\)', line)
            if mac_match and current_device:
                current_device['mac'] = mac_match.group(1)
                current_device['vendor'] = mac_match.group(2)
        
        if current_device:
            devices.append(current_device)
        
        # Sort by IP address
        devices.sort(key=lambda x: [int(part) for part in x['ip'].split('.')])
        
        return {
            'devices': devices,
            'network': network_range,
            'gateway': gateway,
            'local_ip': local_ip,
            'scan_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
            'total_devices': len(devices)
        }
    
    except subprocess.TimeoutExpired:
        return {'error': 'Scan timeout - network too large or slow'}
    except FileNotFoundError:
        return {'error': 'nmap not found. Please install nmap: sudo apt-get install nmap'}
    except Exception as e:
        return {'error': f'Scan failed: {str(e)}'}

@app.route('/')
def index():
    """Render the main page."""
    return render_template('index.html')

@app.route('/api/scan')
def api_scan():
    """API endpoint to trigger a network scan."""
    result = scan_network()
    return jsonify(result)

@app.route('/api/info')
def api_info():
    """API endpoint to get network information."""
    try:
        network_range, gateway, local_ip = get_default_gateway_and_network()
        return jsonify({
            'network': network_range,
            'gateway': gateway,
            'local_ip': local_ip
        })
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    print("=" * 60)
    print("lan-mine")
    print("=" * 60)
    print("\nStarting web server...")
    print("Access the web UI at: http://localhost:5000")
    print("\nNote: Run with sudo for better MAC address detection:")
    print("  sudo python3 app.py")
    print("\nPress Ctrl+C to stop\n")
    
    app.run(host='0.0.0.0', port=5000, debug=True)
