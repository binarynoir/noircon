#!/usr/bin/env bash

# Replace this with your Discord webhook URL
WEBHOOK_URL="your_webhook_url_here"

# Get the current date and time
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")

# Declare the associative array and deserialize the incoming settings string
declare -A settings
while IFS='=' read -r key value; do
    settings["$key"]="$value"
done < <(echo "$1" | tr ';' '\n')

MESSAGE="${settings["MESSAGE"]}"
SUBJECT="${settings["TITLE"]}"

# Function to send a message to Discord
send_discord_message() {
    local subject=$1
    local message=$2
    local full_message="**${subject}**\n\n${message}"
    curl -s -X POST "$WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"${full_message}\"}"
}

# Send the alert message
send_discord_message "$SUBJECT" "$MESSAGE"

echo 0
