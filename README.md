# TropicSolutions - SwapLord

**SwapLord** is a lightweight Linux service that monitors **RAM, CPU, and disk usage** and sends this data to a configured API. SwapLord runs as a daemon in the background, making it ideal for server monitoring and automated infrastructure tracking.

---

## 🚀 Features

- Monitors:
  - RAM usage
  - CPU usage
  - Disk/storage usage
- Sends metrics to a configurable **API endpoint**
- Lightweight background daemon
- Minimal system resource consumption
- Flexible configuration via **config file** or environment variables
- Logging and error handling

---

## 💻 Installation

**Requirements:**

- Linux-based system
- Python 3.10+ / Go / Node.js *(depending on your implementation)*
- Access to the target API

**Steps:**

1. Clone the repository:
   ```bash
   git clone https://github.com/jn-networks/tropicsolutions-swaplord.git
   cd SwapLord
   chmod +x install.sh
   ./install.sh
