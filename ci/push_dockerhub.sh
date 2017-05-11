#!/bin/bash

echo "Pusing to dockerhub..."

ls -lh ./ci/output

for f in $(ls ./ci/output); do
    docker load < "./ci/output/${f}"
done

docker images
