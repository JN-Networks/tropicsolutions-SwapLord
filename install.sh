#!/bin/bash
clear
set -e

BLUE="\033[1;34m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
SUCCESS="✅"
INFO="💡"

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid > /dev/null 2>&1; do
        for ((i=0;i<${#spinstr};i++)); do
            printf "\r  [%c]  " "${spinstr:$i:1}"
            sleep $delay
        done
    done
    printf "\r        \r"
}

echo -e "${BLUE}========================================${RESET}"
echo -e "${BLUE}      TropicSolutions SwapLord Installer${RESET}"
echo -e "${BLUE}========================================${RESET}\n"

echo -e "${INFO} Before you start, make sure you have your API Key ready."
echo -e "${INFO} You can see an manual here"
echo -e "${YELLOW}https://docs.tropicsoltions.net/swaplord/${RESET}\n"

read -p "Enter your API Key: " API_KEY

read -p "Enter the system user for SwapLord [swaplord]: " SWAPUSER
SWAPUSER=${SWAPUSER:-swaplord}

echo -e "${INFO} Installing dependencies..."
install_dependencies() {
    sudo apt-get update -qq >/dev/null
    sudo apt-get install -y python3 python3-pip >/dev/null
    sudo pip3 install --upgrade pip >/dev/null 2>&1
    sudo pip3 install psutil requests pyyaml >/dev/null 2>&1
}
install_dependencies &
spinner $!
echo -e "${GREEN}  ${SUCCESS} Dependencies installed${RESET}\n"

echo -ne "${INFO} Setting up configuration... "
sudo mkdir -p /etc/swaplord
sudo cp ./config/config.example.yaml /etc/swaplord/config.yaml
sudo sed -i "s|<INSERT_YOUR_KEY_HERE>|$API_KEY|g" /etc/swaplord/config.yaml
echo -e "${GREEN}${SUCCESS}${RESET} Config successfull created"

echo -ne "${INFO} Creating log directory... "
sudo mkdir -p /var/log/swaplord
sudo chown $SWAPUSER:$SWAPUSER /var/log/swaplord || true
sudo chmod 750 /var/log/swaplord
sudo sed -i "s|log_file:.*|log_file: /var/log/swaplord/swaplord.log|g" /etc/swaplord/config.yaml
echo -e "${GREEN}${SUCCESS}${RESET} Log directory ready at /var/log/swaplord"

echo -ne "${INFO} Installing SwapLord script... "
sudo cp ./bin/swaplord.py /usr/local/bin/swaplord
sudo chmod +x /usr/local/bin/swaplord
echo -e "${GREEN}${SUCCESS}${RESET} Service Scripts successfully installed"

echo -ne "${INFO} Creating system user '$SWAPUSER'... "
sudo useradd -r -s /bin/false $SWAPUSER >/dev/null 2>&1 || true
echo -e "${GREEN}${SUCCESS}${RESET} User '$SWAPUSER' ready"

echo -ne "${INFO} Setting up systemd service... "
PYTHON_PATH=$(which python3)
sudo cp ./systemd/swaplord.service /etc/systemd/system/swaplord.service
sudo sed -i "s|ExecStart=.*|ExecStart=$PYTHON_PATH /usr/local/bin/swaplord --config /etc/swaplord/config.yaml|g" /etc/systemd/system/swaplord.service
sudo sed -i "s|User=.*|User=$SWAPUSER|g" /etc/systemd/system/swaplord.service
sudo sed -i "s|Group=.*|Group=$SWAPUSER|g" /etc/systemd/system/swaplord.service
sudo sed -i "s|WorkingDirectory=.*|WorkingDirectory=/etc/swaplord|g" /etc/systemd/system/swaplord.service
sudo sed -i "/ExecStart/a StandardOutput=journal\nStandardError=journal" /etc/systemd/system/swaplord.service || true

sudo systemctl daemon-reload
sudo systemctl enable swaplord
sudo systemctl restart swaplord
echo -e "${GREEN}${SUCCESS}${RESET} SwapLord service installed and started!\n"

echo -e "${BLUE}========================================${RESET}"
echo -e "${GREEN}Installation complete!${RESET} ${SUCCESS}"
echo -e "${BLUE}Check service status: sudo systemctl status swaplord${RESET}"
echo -e "${GREEN}Please be note that this is a BETA-Version and you cannot see the live metrics at our dashboard at the moment.${RESET}"