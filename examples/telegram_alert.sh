#!/usr/bin/env bash

# Replace these with your bot token and chat ID
BOT_TOKEN="your_bot_token_here"
CHAT_ID="your_chat_id_here"

# Get the current date and time
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")

# Declare the associative array and deserialize the incoming settings string
declare -A settings
while IFS='=' read -r key value; do
    settings["$key"]="$value"
done < <(echo "$1" | tr ';' '\n')

MESSAGE="${settings["MESSAGE"]}"
SUBJECT="${settings["TITLE"]}"

# Function to send a message to Telegram
send_telegram_message() {
    local subject=$1
    local message=$2
    local full_message="*${subject}*\n\n${MESSAGE}"
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="${full_message}" \
        -d parse_mode="Markdown"
}

# Send the alert message
send_telegram_message "$SUBJECT" "$MESSAGE"

echo 0
