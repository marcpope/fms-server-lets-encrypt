#!/bin/sh

# Define log file
LOG_FILE="/var/log/fms_renew_ssl.log"
touch $LOG_FILE

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start of script
log_message "Starting SSL certificate renewal process."

# Define variables
DOMAIN="fms19.mydomain.com"
EMAIL="me@youremail.com"
SERVER_PATH="/opt/FileMaker/FileMaker Server/"
WEB_ROOT="/var/www/letsencrypt/"
FMADMIN="Administrator"
FMPASS="FILEMAKER_PASSWORD_HERE"

# Export variables for use in the renew hook script
export DOMAIN
export SERVER_PATH
export FMADMIN
export FMPASS
export LOG_FILE  # Export LOG_FILE so it's available in get-ssl-step2.sh

# Run Certbot with renew-hook to trigger updates only on renewal
log_message "Running Certbot to renew certificate for $DOMAIN."
certbot certonly --webroot -w "$WEB_ROOT" -d "$DOMAIN" --agree-tos -m "$EMAIL" --preferred-challenges "http" -n --renew-hook "/root/get-ssl-step2.sh" >> "$LOG_FILE" 2>&1

# End of script
log_message "SSL certificate renewal process completed."
