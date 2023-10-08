#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker command not found. Please install Docker and try again."
    exit 1
fi

# Validate script arguments
if [[ "$#" -ne 1 ]] || ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Usage: $0 <number_of_days>"
    exit 1
fi

# Number of days threshold
days_threshold=$1

# Get all containers (including exited ones) with their info
mapfile -t docker_containers < <(docker ps -a --format "{{.ID}} {{.Image}} {{.Status}}")

# Display relevant images
echo "Images with containers exited more than $days_threshold day(s) ago:"

# Iterate through each line (container) of docker_containers
for container in "${docker_containers[@]}"; do
    # Extract container ID, image, and status
    container_id=$(echo "$container" | awk '{print $1}')
    container_image=$(echo "$container" | awk '{print $2}')
    container_status=$(echo "$container" | cut -d' ' -f3-)
    
    # Check if the container is exited
    if [[ "$container_status" == Exited* ]]; then
        # Extract the age part of the status, if present
        age_string=$(echo "$container_status" | sed -n -e 's/Exited ([0-9]\+) \(.*\) ago/\1/p')
        
        # Check if age_string contains "day", "month", or "year"
        if [[ "$age_string" == *day* ]]; then
            age_days=$(echo "$age_string" | awk '{print $1}')
        elif [[ "$age_string" == *month* ]]; then
            age_months=$(echo "$age_string" | awk '{print $1}')
            age_days=$((age_months * 30))
        elif [[ "$age_string" == *year* ]]; then
            age_years=$(echo "$age_string" | awk '{print $1}')
            age_days=$((age_years * 365))
        else
            # Set age_days=0 if age is in minutes/hours/weeks or unrecognized
            age_days=0
        fi
        
        # Check if the age is greater than the threshold
        if [[ $age_days -gt $days_threshold ]]; then
            echo "- $container_image (Container ID: $container_id, Status: $container_status)"
        fi
    fi
done

