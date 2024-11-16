#!/bin/bash

# Function to get the local IP
get_local_ip() {
    ip=$(ip addr show wlan0 | awk '/inet / {print $2}' | cut -d'/' -f1)
    echo $ip
}

# Update the .env file in the server directory
update_env() {
    local ip=$(get_local_ip)
    if [[ -z "$ip" ]]; then
        echo "Error: Could not determine local IP address."
        exit 1
    fi

    echo "LOCAL_IP=$ip" >>./Server/.env
    echo ".env file updated with LOCAL_IP=$ip"
}

# Start the client in a new Kitty window
run_client() {
    local client_path="$(pwd)/Client"
    echo "Starting client in a new Kitty window..."
    kitty @ launch --title "Client" --cwd "$client_path" bash -c "npm run start; exec bash"
}

# Start the server in a new Kitty window
run_server() {
    local server_path="$(pwd)/Server"
    echo "Starting server in a new Kitty window..."
    kitty @ launch --title "Server" --cwd "$server_path" bash -c "sudo node server.js; exec bash"
}

# Main script logic
update_env
run_client
run_server
