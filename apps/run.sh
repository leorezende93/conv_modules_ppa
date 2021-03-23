#!/bin/bash

# Clean environment
./clean.sh

# Run application
source ./venv/bin/activate
python3 ${1}.py

