# lan-mine Desktop App

This directory contains the desktop application version of lan-mine.

## Build the Desktop App

```bash
cd desktop-app
./build.sh
```

This will:
1. Create a virtual environment
2. Install dependencies (PyWebView, PyInstaller)
3. Build a standalone executable
4. Output: `dist/lan-mine` (~20-30MB)

## Requirements

**Build Requirements:**
- Python 3.7+
- Linux system

**Runtime Requirements (for users):**
- Linux system
- nmap installed (`sudo apt-get install nmap`)
- Run with sudo for full network scanning

## Running the App

```bash
sudo ./dist/lan-mine
```

The app will open in a native desktop window.

## Sharing

Copy the `dist/lan-mine` file to share with others. They need:
- Linux system
- nmap installed
- Run with `sudo ./lan-mine`

## How It Works

- Uses **PyWebView** to wrap the Flask web UI in a native window
- Flask runs in background thread
- **PyInstaller** bundles everything into a single executable
- Includes Python interpreter, dependencies, templates, and static files
- Still requires nmap as external dependency (can't bundle system tools)

## File Size

The executable is ~20-30MB, much lighter than Electron-based apps.
