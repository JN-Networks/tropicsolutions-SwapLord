#!/usr/bin/env python3
import psutil
import time
import yaml
import requests
import argparse
import logging

parser = argparse.ArgumentParser(description="SwapLord Resource Monitor")
parser.add_argument("--config", type=str, default="/etc/swaplord/config.yaml", help="Path to config file")
args = parser.parse_args()

with open(args.config, "r") as f:
    config = yaml.safe_load(f)

logging.basicConfig(filename=config["log_file"], level=logging.INFO,
                    format="%(asctime)s [SwapLord] %(levelname)s: %(message)s")

def get_metrics():
    cpu = psutil.cpu_percent()
    ram = psutil.virtual_memory()
    disk = psutil.disk_usage('/')
    return {
        "version": config.get("version", "unknown"),
        "cpu_percent": cpu,
        "ram_used": ram.used,
        "ram_total": ram.total,
        "disk_used": disk.used,
        "disk_total": disk.total
    }

def send_metrics(data, retries=3):
    headers = {"SWAP-API-KEY": f"{config['api_key']}"}
    for attempt in range(1, retries+1):
        try:
            response = requests.post(config["api_endpoint"], json=data, headers=headers, timeout=30)
            if response.status_code == 201:
                logging.info("Metrics sent successfully: %s", data)
                return
            else:
                logging.error("Failed to send metrics: %s - %s", response.status_code, response.text)
        except Exception as e:
            logging.error("Attempt %d: Error sending metrics: %s", attempt, e)
            time.sleep(5)

def main():
    interval = config.get("interval", 10)
    while True:
        data = get_metrics()
        send_metrics(data)
        time.sleep(interval)

if __name__ == "__main__":
    main()
