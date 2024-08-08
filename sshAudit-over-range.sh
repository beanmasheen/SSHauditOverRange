#!/bin/bash

# Function to run ssh-audit on a given IP and optionally save the output
run_ssh_audit() {
    IP=$1
    if [ "$OUTPUT_TO_FILE" = "y" ]; then
        if [ -w "$OUTPUT_DIR" ]; then
            ssh-audit $IP > "$OUTPUT_DIR/$IP.txt"
            echo "Results for $IP saved to $OUTPUT_DIR/$IP.txt"
        else
            echo "Error: Cannot write to directory $OUTPUT_DIR. Check permissions."
            exit 1
        fi
    else
        ssh-audit $IP
    fi
}

# Define the list of IPs or IP range to scan
read -p "Enter IP range start: " IP_RANGE_START
read -p "Enter IP range end: " IP_RANGE_END
read -p "Enter base IP (e.g., 10.10.10): " BASE_IP
read -p "Do you want to save the output to files? (y/n): " OUTPUT_TO_FILE

# Ensure ssh-audit is installed
if ! command -v ssh-audit &> /dev/null
then
    echo "ssh-audit could not be found. Please install it first."
    exit 1
fi

# Create output directory if needed
if [ "$OUTPUT_TO_FILE" = "y" ]; then
    read -p "Enter output directory: " OUTPUT_DIR
    mkdir -p $OUTPUT_DIR
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create directory $OUTPUT_DIR. Check permissions."
        exit 1
    fi
fi

# Loop over the IP range and perform the ssh-audit
for i in $(seq $IP_RANGE_START $IP_RANGE_END); do
    IP="$BASE_IP.$i"
    echo "Running ssh-audit on $IP"
    run_ssh_audit $IP
done
