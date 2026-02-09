# TropicSolutions - SwapLord

**SwapLord** is a lightweight Linux service that monitors **RAM, CPU, and disk usage** and sends this data to the TropicSolutions-API. SwapLord runs as a daemon in the background, making it ideal for server monitoring.

---

## 🚀 Features

- Monitors:
  - RAM usage
  - CPU usage
  - Disk/storage usage
- Sends metrics to the TropicSolutions-API Endpoint
- Lightweight background daemon
- Minimal system resource consumption
- Flexible configuration via **config file**
- Logging and error handling

---

## 💻 Installation

**Requirements:**

- Linux-based system
- Python 3.10+
- Access to the target TropicSolutions-API

**Steps:**

1. Clone the repository:
   ```bash
   git clone https://github.com/JN-Networks/tropicsolutions-SwapLord.git
   cd SwapLord
   chmod +x install.sh
   ./install.sh
