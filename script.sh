#!/bin/bash
apt update
apt install -y nginx jq unzip net-tools
for I in {1..10}
do
  echo "Hello $I"
  sleep 1
done