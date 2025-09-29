#!/bin/bash
# This script is to run the POS... make sure the jar fix signature is in place
# ==================================
echo "Running run_tpos script"

# Change to the directory where this script is located
cd "$(dirname "$0")"

# Fix the defailtVars.cmd needed to run in Git-Bash
./fix_bash_defaultVars.sh

# Change to the specific POS sandbox directory
cd /c/DEV_HOME/FBA/ws-pos/git/pos/build/pos-full/pos-full-sandbox-cloud/_sandbox_7102/

# Run the POS
echo "Running run_tpos.cmd..."
./run_tpos.cmd

RETURN_CODE=$?
echo "Script execution completed with return code: $RETURN_CODE"
