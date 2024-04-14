#! /usr/bin/bash

genid() {
    # acquire lock
    exec 200>/var/tmp/genid.lock
    flock 200 || exit 1

    # load from file the current id
    if [ ! -f "/var/tmp/current_id" ]; then
        echo 0 > "/var/tmp/current_id"
    fi
    current_id=$(<"/var/tmp/current_id")

    # increment the current id
    next_id=$((current_id + 1))

    # write the next id back to the file
    printf $next_id > "/var/tmp/current_id"

    num_digits=${#next_id}
    num_zeros=$((5 - num_digits))
    zeros=""
    for ((i=0; i<$num_zeros; i++)); do
        zeros="${zeros}0"
    done

    echo "${zeros}${next_id}"
    
    # release lock
    flock -u 200
}



# initialize the current id file
echo 0 > "/var/tmp/current_id"

# # test script to call genid concurrently
# # usage: ./test.sh <number of processes> <number of IDs per process>
# # example: ./test.sh 10 1000

NUM_PROCESSES=$1

# remove the file if it exists
if [ -f "ids.txt" ]; then
    rm "ids.txt"
fi

# create the file
touch "ids.txt"

for ((i=0; i<$NUM_PROCESSES; i++)); do
    genid >> "ids.txt" &
done

wait

# 

