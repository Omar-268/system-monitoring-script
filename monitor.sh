#!/bin/bash

# Default values for options
ALERT=80
OUTPUT_FILE="system_monitor.log"
EMAIL_RECIPIENT="example@gmail.com"

# Parse optional arguments
while getopts ":t:f:" opt; do
  case ${opt} in
    t) 
      ALERT=$OPTARG
      ;;
    f) 
      OUTPUT_FILE=$OPTARG
      ;;
    \?) 
      echo "Usage: $0 [-t threshold] [-f output_file]"
      exit 1
      ;;
  esac
done

# Function to send email notification
send_email() {
    local subject=$1
    local body=$2
    echo -e "Subject: $subject\n\n$body" | msmtp "$EMAIL_RECIPIENT"
}

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}'

}

# Function to get memory usage (total, used, free)
get_memory_usage() {
    free -h | grep Mem | awk '{print "Total Memory: "$2"\nUsed Memory: "$3"\nFree Memory: "$4}'
}

# Function to get disk usage
get_disk_usage() {
    df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
}

# Get the current date and time
CURRENT_DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Disk Usage Check
DISK_USAGE=$(get_disk_usage)
DISK_REPORT="Disk Usage Report - $CURRENT_DATE\n======================================\nDisk Usage: $DISK_USAGE%\n"

# Check if disk usage exceeds threshold
if [ "$DISK_USAGE" -gt "$ALERT" ]; then
    DISK_WARNING="Warning: Disk usage is above $ALERT%!"
    DISK_REPORT+="Warning: Disk usage is above $ALERT%!\n"
else
    DISK_WARNING=""
fi

# CPU Usage Check
CPU_USAGE=$(get_cpu_usage)
CPU_REPORT="CPU Usage Report:\nCurrent CPU Usage: $CPU_USAGE\n"

# Memory Usage Check
MEMORY_REPORT=$(get_memory_usage)

MEMORY_REPORT+="\n"
# Top 5 Memory-Consuming Processes
PROCESS_REPORT="Top 5 Memory-Consuming Processes:\n"
TOP_PROCESSES=$(ps aux --sort=-%mem | awk 'NR<=6 {print $2, $1, $4, $11}' | tail -n +2)
PROCESS_REPORT+="$(printf "%s\n" "$TOP_PROCESSES")"

# Combine all the reports
REPORT="System Monitoring Report - $CURRENT_DATE\n======================================\n$DISK_REPORT\n$CPU_REPORT\n$MEMORY_REPORT\n$PROCESS_REPORT"

# Output the report to the log file
echo -e "$REPORT" >> "$OUTPUT_FILE"

# Print the report in color (optional)
echo -e "\033[1;32m$REPORT\033[0m" # Green color for normal output

# Send an email with the full report if any disk usage warning exists
if [ -n "$DISK_WARNING" ]; then
    EMAIL_SUBJECT="System Monitoring Alert - $CURRENT_DATE"
    EMAIL_BODY="System Monitoring Alert - $CURRENT_DATE\n======================================\n$DISK_WARNING\n$REPORT"
    send_email "$EMAIL_SUBJECT" "$EMAIL_BODY"
fi

