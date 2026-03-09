# Linux Hardening Audit Script

**hardening_audit.sh** is a lightweight, modular Bash script designed to perform a security audit and hardening check on Linux systems. It helps identify common security misconfigurations, weak settings, and potential vulnerabilities on servers, workstations, and containers.

> **Status:** Work in progress – feedback, contributions, and pull requests are very welcome!

## Features

- Checks for insecure permissions on critical files/directories
- Verifies user & authentication settings (password policies, sudo, etc.)
- Examines running services, open ports, and firewall status
- Audits kernel parameters (sysctl) for common hardening recommendations
- Detects world-writable files, SUID/SGID binaries, and other risky configurations
- Basic compliance-style reporting (PASS / WARN / FAIL style output)
- Color-coded, human-readable output
- Easy to extend with your own checks

## Requirements

- Bash 4+ (most modern Linux distributions)
- Root privileges (`sudo`) – many checks require elevated access
- Common utilities: `grep`, `awk`, `find`, `ss`, `systemctl`, etc. (usually pre-installed)

Tested on:
- Ubuntu / Debian
- CentOS / Rocky / AlmaLinux / RHEL
- (Feedback welcome for other distros)

## Installation & Quick Start

```bash
# Clone the repository
git clone https://github.com/sweatdigital/Linux-Audit-Script.git
cd Linux-Audit-Script

# Make the script executable
chmod +x hardening_audit.sh

# Run the audit (recommended: as root or with sudo)
sudo ./hardening_audit.sh
