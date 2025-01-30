# system-monitoring-script

This Bash script is designed to monitor system resources such as disk usage, CPU usage, and memory usage. It generates a detailed report and logs the results to a file. Additionally, it can send an email notification if the disk usage exceeds a specified threshold.

## Features
- Monitors disk usage, CPU usage, and memory usage.
- Logs system status to a specified log file.
- Sends an email notification if disk usage exceeds a configurable threshold.
- Provides a report on the top 5 memory-consuming processes.

## Prerequisites
- msmtp: A simple SMTP client used for sending email notifications. Make sure it is installed and configured on your system.
- A working Gmail account (or another SMTP server setup) to receive email alerts.

## Example Commands
1-Run with default settings (disk usage threshold 80%, log output to system_monitor.log):
```bash
./system_monitor.sh
```

2-Run with custom disk usage threshold (e.g., 90%) and custom log file (custom_log.txt):
```bash
./system_monitor.sh -t 90 -f custom_log.txt
```

## Report Output
The script generates the following reports:

- Disk Usage Report: Displays the current disk usage percentage.
- CPU Usage Report: Displays the current CPU usage as a percentage.
- Memory Usage Report: Shows total, used, and free memory.
- Top 5 Memory-Consuming Processes: Lists the top 5 processes consuming the most memory.

## Example Output
```bash
System Monitoring Report - 2025-01-29 10:00:00
======================================
Disk Usage Report - 2025-01-29 10:00:00
======================================
Disk Usage: 85%
Warning: Disk usage is above 80%!

CPU Usage Report:
Current CPU Usage: 23%

Total Memory: 8.0G
Used Memory: 4.0G
Free Memory: 2.5G

Top 5 Memory-Consuming Processes:
PID  USER   MEM %  COMMAND
1234 root    50.5  java
2345 user    30.3  python
...
```

## Email Notification
If the disk usage exceeds the specified threshold, the script will send an email notification with the system status. The email will contain the full system monitoring report, including the disk usage warning.
example of email notification
![image](https://lens.usercontent.google.com/image?vsrid=CMG1l5IBEAIYASIkYTdlNmVhNjMtMTNjMS00ZTdjLWFiZDAtOGI5M2YxNWE5Zjlj&gsessionid=Ua76MjmzIZd0O67ESz8Sfjk0VtC_bTeXOzFBqZzsTCmC3PwsWTuuKQ)

## Automate the Script with Cron Job
You can automate the script to run every hour and send an email if any thresholds are breached by setting it up as a cron job.

Steps to set up the cron job:
1-Open your crontab configuration file by running:
```bash
crontab -e
```

2-Add the following line to run the script every hour (adjust the path to the script if needed):
```bash
0 * * * * /path/to/system_monitor.sh -t 80 -f /path/to/system_monitor.log
```

## This cron job will:
- Run the script at the start of every hour (0 * * * *).
- Use a disk usage threshold of 80%.
- Log the output to system_monitor.log.

3-Save and exit the editor (usually by pressing CTRL + X, then Y, and Enter).

The script will now run automatically every hour and send an email if any thresholds are breached.


