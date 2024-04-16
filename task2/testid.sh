#! /usr/bin/bash


genid() {
    # acquire lock
    exec 200>/var/tmp/genid.lock
    flock -x 200 || exit 1 

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

# test script to call genid concurrently
# usage: ./test.sh <number of processes> 
# example: ./test.sh 10 

# initialize the current id file
echo 0 > "/var/tmp/current_id"

NUM_PROCESSES=$1
PER_PROCESS_IDS=$2

if [ "$2" == "seq" ]; then
    seq_flag=1
else
    seq_flag=0
fi

# remove the file if it exists
if [ -f "ids.txt" ]; then
    rm "ids.txt"
fi

# create the file
touch "ids.txt"

start=`date +%s%N`
if [ $seq_flag -eq 1 ]; then
    for ((i=1; i<=$NUM_PROCESSES; i++)); do
        num_digits=${#i}
        num_zeros=$((5 - num_digits))       
        zeros=""
        for ((j=0; j<$num_zeros; j++)); do
            zeros="${zeros}0"
        done
        echo "${zeros}${i}" >> "ids.txt"
    done
    end=`date +%s%N`
    echo "Sequential generation took $((end-start)) nanoseconds."
    exit 0
fi


# call PER_PROCESS_IDS times the genid function concurrently 
for ((i=0; i<$NUM_PROCESSES; i++)); 
do
    ( for ((j=0; j<$PER_PROCESS_IDS; j++)); do genid >> "ids.txt"; done ) &
done

wait

end=`date +%s%N`
echo "Concurrent generation took $((end-start)) nanoseconds."

# check if they are equal to (seq 1 NUM_PROCESSES)
ideal_count=$((NUM_PROCESSES * PER_PROCESS_IDS))
arr=()
while read line; do
    arr+=($line)
done < "ids.txt"

if [ ${#arr[@]} -eq $ideal_count ]; then
    echo "id.txt contains the generated sequential numbers from 1 to $ideal_count"
else
    echo "Some ids are not unique or not sequential. Check ids.txt for more information."
fi 