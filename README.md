# lan-mine

A simple, lightweight web-based tool to scan and monitor all devices on your local network. Built with Python Flask and designed to run on any local server.
![LAN Scanner](https://img.shields.io/badge/Python-3.7+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

- Quick network scanning - Discover all devices on your LAN in seconds
- Clean web interface - Modern, responsive UI that works on any device
- Device information - View IP addresses, hostnames, MAC addresses, and vendor info
- Smart detection - Automatically identifies your gateway and local device
- Real-time updates - Scan on-demand with a single click
- Terminal-style design - Dark theme with cyan accents and activity log

## Prerequisites

Before you begin, ensure you have the following installed:

- **Python 3.7+** - Check with `python3 --version`
- **nmap** - Network scanning tool
- **pip** - Python package manager

### Installing nmap

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install nmap
```

**Fedora/RHEL:**
```bash
sudo dnf install nmap
```

**Arch Linux:**
```bash
sudo pacman -S nmap
```

**macOS:**
```bash
brew install nmap
```

## Quick start

### 1. Clone or download

```bash
cd /home/sam/lan-mine
```

### 2. Set up virtual environment (recommended)

Create and activate a virtual environment:

```bash
# Create virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate
```

### 3. Install the project

Install the project and all its dependencies:

```bash
pip install .
```

This reads `pyproject.toml` and installs Flask, netifaces, and sets everything up.

### 4. Run the application

Basic mode (limited MAC address detection):
```bash
python3 app.py
```

With sudo (recommended for full MAC address detection):
```bash
# If using venv, use the venv's Python interpreter
sudo venv/bin/python3 app.py

# Or activate venv first
sudo -E env PATH=$PATH python3 app.py
```

### 5. Access the web UI

Open your browser and navigate to:
```
http://localhost:5000
```

Or from another device on your network:
```
http://YOUR_SERVER_IP:5000
```

## Usage

1. **Start the server** using one of the methods above
2. **Open the web interface** in your browser
3. **Click "Scan Network"** to discover all devices
4. **View results** including:
   - Device status (Gateway, Local, Online)
   - IP addresses
   - Hostnames
   - MAC addresses
   - Vendor information

## Configuration

### Change port

Edit `app.py` and modify the last line:
```python
app.run(host='0.0.0.0', port=8080, debug=True)  # Change 5000 to 8080
```

### Network interface

The scanner automatically detects your default network interface. If you need to scan a specific network range, modify the `scan_network()` function in `app.py`.

### Auto-refresh

To enable automatic scanning every 60 seconds, uncomment the auto-refresh code at the bottom of `static/script.js`:
```javascript
setInterval(() => {
    if (!isScanning) {
        startScan();
    }
}, 60000); // Refresh every 60 seconds
```

## Project structure

```
lan-mine/
├── app.py              # Flask backend server
├── pyproject.toml      # Project metadata and dependencies
├── requirements.txt    # Python dependencies (legacy)
├── .gitignore          # Git ignore rules
├── start.sh            # Start script (runs server in background)
├── stop.sh             # Stop script (kills server process)
├── venv/               # Virtual environment (created after setup)
├── desktop-app/        # Desktop application packaging
│   ├── main.py         # Desktop app entry point
│   ├── build.sh        # Build standalone executable
│   ├── package.sh      # Create distribution package
│   ├── requirements.txt # Desktop app dependencies
│   └── README.md       # Desktop app documentation
├── templates/
│   └── index.html     # Main HTML template
└── static/
    ├── style.css      # Styles and responsive design
    └── script.js      # Frontend JavaScript
```

## Distribution packaging

To create a standalone executable for easy distribution:

### Building the desktop app

```bash
cd desktop-app
./build.sh
```

This creates a standalone executable at `dist/lan-mine` that bundles Python, Flask, and all dependencies. Users only need nmap installed.

### Creating distribution packages

```bash
cd desktop-app
./package.sh
```

This creates a ready-to-distribute package:
- **Linux**: `packages/lan-mine-1.0.0-linux.tar.gz`
- **macOS**: `packages/lan-mine-1.0.0-macos.tar.gz` (must build on Mac)

Each package includes:
- Standalone executable
- Installation script (auto-installs nmap)
- Complete documentation

### User installation

Recipients simply:
```bash
tar -xzf lan-mine-1.0.0-linux.tar.gz
cd lan-mine-1.0.0-linux
./install.sh      # Installs nmap if needed
sudo ./lan-mine   # Runs the app
```

See `desktop-app/README.md` for more details.

## Security notes

- **Run with sudo** for full MAC address detection (requires root privileges)
- **Local network only** - This tool is designed for local network use
- **Firewall** - Ensure port 5000 (or your chosen port) is accessible
- **Production** - For production use, consider using a proper WSGI server like gunicorn

## Troubleshooting

### "nmap not found" error

Install nmap using the commands in the Prerequisites section.

### Permission issues

Run with `sudo` for full functionality:
```bash
sudo python3 app.py
```

### Can't access from other devices

Make sure:
1. The server is running on `0.0.0.0` (not `localhost`)
2. Your firewall allows connections on port 5000
3. You're using the correct server IP address

### Slow scans

- Large networks (>254 hosts) take longer to scan
- Consider adjusting the nmap timeout in `app.py`
- Ensure your network has good connectivity

## Future enhancements

Potential features to add:
- Device history tracking
- Custom device naming/labeling
- Email/notification alerts for new devices
- Network change detection
- Export to CSV/JSON
- Multiple network support

## License

This project is open source and available under the MIT License.

## Contributing

Feel free to fork, modify, and submit pull requests. All contributions are welcome.

## Tips

- Run the scanner periodically to keep track of new devices joining your network
- Use descriptive hostnames on your devices for easier identification
- Consider setting up static IPs for important devices
- Keep nmap updated for best results

## Support

If you encounter issues:
1. Check that nmap is installed and accessible
2. Verify Python dependencies are installed
3. Ensure you have network connectivity
4. Try running with sudo for enhanced features
