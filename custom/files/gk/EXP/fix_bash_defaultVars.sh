#!/bin/bash
# This script is to run the POS... make sure the jar fix signature is in place
# ==================================

echo "Fixing some valies for Git-Bash"

# Define the input file
CMD_FILE="/c/DEV_HOME/GXC/ws-pos/git/pos/build/pos-full/pos-full-sandbox-cloud/_sandbox_t128/defaultVars.cmd"

# Comment out lines 42 through 47
sed -i '42,49{/^REM /!s/^/REM /}' "$CMD_FILE"

echo "Lines 42 to 49 in $CMD_FILE have been commented out."
