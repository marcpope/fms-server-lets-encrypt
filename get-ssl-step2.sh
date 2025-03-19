#!/bin/sh

# Define log file
LOG_FILE="/var/log/fms_renew_ssl.log"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Start of script
log_message "Starting certificate renewal and service restart process."

# Copy new certificate files to FileMaker Server's CStore directory
log_message "Copying new certificate files."
cp "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" "${SERVER_PATH}CStore/fullchain.pem"
cp "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" "${SERVER_PATH}CStore/privkey.pem"

# Set correct permissions on the private key
log_message "Setting permissions on the private key."
chmod 640 "${SERVER_PATH}CStore/privkey.pem"

# Move the old server.pem if it exists to avoid conflicts
if [ -f "${SERVER_PATH}CStore/server.pem" ]; then
    log_message "Moving old server.pem to serverKey-old.pem."
    mv "${SERVER_PATH}CStore/server.pem" "${SERVER_PATH}CStore/serverKey-old.pem"
fi

# Delete the old certificate
log_message "Deleting the old certificate from Filemaker Server."
fmsadmin certificate delete --yes -u "${FMADMIN}" -p "${FMPASS}" >> "$LOG_FILE" 2>&1

# Import the new certificate
log_message "Importing the new certificate into Filemaker Server."
fmsadmin certificate import "${SERVER_PATH}CStore/fullchain.pem" --keyfile "${SERVER_PATH}CStore/privkey.pem" --yes -u "${FMADMIN}" -p "${FMPASS}" >> "$LOG_FILE" 2>&1

# Restart the HTTP server to load the new certificate
log_message "Restarting the httpserver service."
fmsadmin restart httpserver --yes -u "${FMADMIN}" -p "${FMPASS}" >> "$LOG_FILE" 2>&1

# End of script
log_message "Certificate renewal and service restart process completed."
