#!/bin/bash
# First Part - System Information
printf "\n############################################\n"
echo -e "First Part - System Information"
echo -e "System Information: This section provides an overview of the server's operating system and version. Knowing the OS type and version helps to identify specific security patches or vulnerabilities that may affect your system.\n\n"
uname -a
cat /etc/*-release
if [ -f /etc/os-release ]; then
  cat /etc/os-release | grep PRETTY_NAME
else
  lsb_release -a
fi
printf "\n############################################\n"
echo -e "\nSecond Part - Server Hardening Audit\n\n"
echo -e "Now let's have fun in checking what work we need to implement on the server\n\n"

# Check for installed packages
printf "\n############################################\n"
echo -e "Check for essential security packages: This step checks if your system has necessary security packages installed, such as OpenSSL, libssl1.0, and libsasl2-modules. Installing these packages ensures that common security vulnerabilities are addressed.\n\n"
if [ -d /etc/apt ] || [ -d /var/lib/apt ]; then
  echo "\nChecking for essential security packages:"
  dpkg --get-selections | grep -E 'openssl|libssl1.0|libsasl2-modules' > /tmp/essential_packages
  if [ -f /tmp/essential_packages ]; then
    echo "Essential security packages installed."
    echo "To ensure that known vulnerabilities are fixed, please install the following:"
    cat /tmp/essential_packages
  else
    echo "One or more essential security packages are not installed. Please install the following:"
    cat /tmp/essential_packages
  fi
else
  echo "\nChecking for essential security packages:"
  rpm -qa | grep -E 'openssl|libssl1.0|libsasl2-modules' > /tmp/essential_packages
  if [ -f /tmp/essential_packages ]; then
    echo "Essential security packages installed."
    echo "To ensure that known vulnerabilities are fixed, please install the following:"
    cat /tmp/essential_packages
  else
    echo "One or more essential security packages are not installed. Please install the following:"
    cat /tmp/essential_packages
  fi
fi

# Check for latest updates
printf "\n############################################\n"
echo -e "Check for latest updates: This step ensures that the server's software is up-to-date with the latest patches. Regularly updating your system helps to mitigate known vulnerabilities and protect against potential threats.\n\n"
if [ -d /etc/apt ] || [ -d /var/lib/apt ]; then
  echo "\nChecking for available system updates:"
  apt-get update && apt-get upgrade -y --no-install-recommends
else
  echo "\nChecking for available system updates:"
  yum update -y
fi

# Check for unnecessary services disabled
printf "\n############################################\n"
echo -e "Check for unnecessary services disabled: This step identifies any unnecessary services running on the server. Disabling these services can reduce potential attack surfaces and improve security.\n\n"
echo "\nChecking for unnecessary services:"
systemctl list-unit-files | grep enabled | awk '{print $1}' > /tmp/unnecessary_services
if [ -f /tmp/unnecessary_services ]; then
  echo "Unnecessary services found. Please disable the following:"
  cat /tmp/unnecessary_services
else
  echo "No unnecessary services found."
fi

# Check for SSH security
printf "\n############################################\n"
echo -e "Check for SSH security: This step checks if Secure Shell (SSH) is properly configured and enabled. Enabling SSH ensures that remote access to your system is secure and minimizes the risk of unauthorized access.\n\n"
echo "\nChecking SSH security:"
ssctl status
if [ "$?" -ne 0 ]; then
  echo "SSH security not enabled. Please enable it by running the following command:"
  setenforce 1
else
  echo "SSH security is enabled."
fi

# Check for IDS/IPS solutions installed
printf "\n############################################\n"
echo -e "Check for IDS/IPS solutions installed: Intrusion Detection Systems (IDS) and Prevention Systems (IPS) help detect and prevent potential threats from entering your network. Installing an IDS or IPS solution can significantly enhance your system's security.\n\n"
echo "\nChecking for Intrusion Detection System (IDS) or Prevention System (IPS):"
if [ -d /etc/snort ]; then
  echo "Snort IDS/IPS solution found."
elif [ -d /etc/suricata ]; then
  echo "Suricata IDS/IPS solution found."
else
  echo "No IDS/IPS solution found. Please consider installing one of the following:"
  echo "1. Snort: https://www.snort.org/"
  echo "2. Suricata: https://suricata-ids.org/"
fi

# Check for SELinux enabled
printf "\n############################################\n"
echo -e "Check for SELinux enabled: Security-Enhanced Linux (SELinux) is a security module that provides additional protection against unauthorized access and malicious activities. Enabling SELinux enhances your system's security by enforcing strict access controls and policies.\n\n"
echo "\nChecking for SELinux enabled:"
getenforce
if [ "$?" -ne 0 ]; then
  echo "SELinux is not enabled. Please enable it by running the following command:"
  setenforce 1
else
  echo "SELinux is enabled."
fi

# Check for firewall rules configured
printf "\n############################################\n"
echo -e "Check for firewall rules configured: Firewalls act as barriers between your server and the internet, protecting it from unwanted traffic and potential threats. Configuring a firewall helps to control incoming and outgoing connections, reducing the risk of unauthorized access or attacks.\n\n"
echo "\nChecking firewall rules:"
iptables -L
if [ "$?" -ne 0 ]; then
  echo "Firewall rules not configured. Please configure the following:"
  iptables --help
else
  echo "Firewall rules are configured."
fi
