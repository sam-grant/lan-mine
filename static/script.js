// LAN Device Scanner - Frontend JavaScript

let isScanning = false;

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    loadNetworkInfo();
    setupEventListeners();
    logToTerminal('lan-mine initialized', 'system');
});

function setupEventListeners() {
    const scanBtn = document.getElementById('scanBtn');
    scanBtn.addEventListener('click', startScan);
    
    const clearLogBtn = document.getElementById('clearLog');
    clearLogBtn.addEventListener('click', clearTerminalLog);
}

// Terminal logging functions
function logToTerminal(message, type = 'info') {
    const terminalLog = document.getElementById('terminalLog');
    const logEntry = document.createElement('div');
    logEntry.className = `log-entry ${type}`;
    
    const timestamp = new Date().toLocaleTimeString('en-US', { hour12: false });
    logEntry.innerHTML = `<span class="timestamp">[${timestamp}]</span> ${escapeHtml(message)}`;
    
    terminalLog.appendChild(logEntry);
    terminalLog.scrollTop = terminalLog.scrollHeight;
    
    // Keep only last 100 entries
    while (terminalLog.children.length > 100) {
        terminalLog.removeChild(terminalLog.firstChild);
    }
}

function clearTerminalLog() {
    const terminalLog = document.getElementById('terminalLog');
    terminalLog.innerHTML = '<div class="log-entry system">[SYSTEM] Log cleared</div>';
}

async function loadNetworkInfo() {
    logToTerminal('Loading network configuration...', 'info');
    try {
        const response = await fetch('/api/info');
        const data = await response.json();
        
        if (data.error) {
            showError(data.error);
            logToTerminal(`Error: ${data.error}`, 'error');
            return;
        }
        
        document.getElementById('networkRange').textContent = `Network: ${data.network}`;
        document.getElementById('gateway').textContent = `Gateway: ${data.gateway}`;
        document.getElementById('localIP').textContent = `Local IP: ${data.local_ip}`;
        
        logToTerminal(`Network detected: ${data.network}`, 'success');
        logToTerminal(`Gateway: ${data.gateway}`, 'info');
        logToTerminal(`Local IP: ${data.local_ip}`, 'info');
    } catch (error) {
        console.error('Failed to load network info:', error);
        logToTerminal(`Failed to load network info: ${error.message}`, 'error');
    }
}

async function startScan() {
    if (isScanning) return;
    
    isScanning = true;
    const scanBtn = document.getElementById('scanBtn');
    const btnText = scanBtn.querySelector('.btn-text');
    const spinner = scanBtn.querySelector('.spinner');
    
    // Update button state
    scanBtn.disabled = true;
    btnText.textContent = 'Scanning...';
    spinner.style.display = 'inline-block';
    
    // Hide previous results
    hideError();
    document.getElementById('devicesSection').style.display = 'none';
    document.getElementById('stats').style.display = 'none';
    
    logToTerminal('Starting network scan...', 'info');
    logToTerminal('Running nmap discovery scan...', 'system');
    
    const scanStartTime = Date.now();
    
    try {
        const response = await fetch('/api/scan');
        const data = await response.json();
        
        const scanDuration = ((Date.now() - scanStartTime) / 1000).toFixed(2);
        
        if (data.error) {
            showError(data.error);
            logToTerminal(`Scan failed: ${data.error}`, 'error');
        } else {
            displayResults(data);
            logToTerminal(`Scan completed in ${scanDuration}s`, 'success');
            logToTerminal(`Found ${data.total_devices} device(s) on network`, 'success');
            
            // Log discovered devices
            data.devices.forEach(device => {
                let deviceType = device.is_gateway ? '[GATEWAY]' : device.is_local ? '[LOCAL]' : '[DEVICE]';
                logToTerminal(`${deviceType} ${device.ip} - ${device.hostname} (${device.mac})`, 'info');
            });
        }
    } catch (error) {
        showError(`Network error: ${error.message}`);
        logToTerminal(`Network error: ${error.message}`, 'error');
    } finally {
        // Reset button state
        isScanning = false;
        scanBtn.disabled = false;
        btnText.textContent = 'Scan Network';
        spinner.style.display = 'none';
    }
}

function displayResults(data) {
    // Update stats
    document.getElementById('totalDevices').textContent = data.total_devices;
    document.getElementById('scanTime').textContent = data.scan_time;
    document.getElementById('stats').style.display = 'grid';
    
    // Update network info
    document.getElementById('networkRange').textContent = `Network: ${data.network}`;
    document.getElementById('gateway').textContent = `Gateway: ${data.gateway}`;
    document.getElementById('localIP').textContent = `Local IP: ${data.local_ip}`;
    
    // Display devices table
    const tbody = document.getElementById('devicesBody');
    tbody.innerHTML = '';
    
    if (data.devices.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" style="text-align: center; padding: 2rem; color: var(--text-secondary);">No devices found</td></tr>';
    } else {
        data.devices.forEach(device => {
            const row = createDeviceRow(device);
            tbody.appendChild(row);
        });
    }
    
    document.getElementById('devicesSection').style.display = 'block';
}

function createDeviceRow(device) {
    const row = document.createElement('tr');
    
    // Determine status
    let statusBadge = '';
    if (device.is_gateway) {
        statusBadge = '<span class="status-badge status-gateway"><span class="status-dot"></span> Gateway</span>';
    } else if (device.is_local) {
        statusBadge = '<span class="status-badge status-local"><span class="status-dot"></span> This Device</span>';
    } else {
        statusBadge = '<span class="status-badge status-online"><span class="status-dot"></span> Online</span>';
    }
    
    row.innerHTML = `
        <td>${statusBadge}</td>
        <td><strong>${device.ip}</strong></td>
        <td>${escapeHtml(device.hostname)}</td>
        <td><code>${device.mac}</code></td>
        <td>${escapeHtml(device.vendor)}</td>
    `;
    
    return row;
}

function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';
    logToTerminal(`ERROR: ${message}`, 'error');
}

function hideError() {
    document.getElementById('errorMessage').style.display = 'none';
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Auto-refresh option (optional - uncomment to enable)
// setInterval(() => {
//     if (!isScanning) {
//         startScan();
//     }
// }, 60000); // Refresh every 60 seconds
