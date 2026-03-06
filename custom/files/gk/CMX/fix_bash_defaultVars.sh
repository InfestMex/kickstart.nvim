#!/bin/bash
# This script is to run the POS... make sure the jar fix signature is in place
# ==================================

echo "Fixing some valies for Git-Bash"

# Define the input file
CMD_FILE="C:/DEV_HOME/CMX/ws-pos/git/pos/build/pos-full/pos-full-sandbox/_sandbox__0037/defaultVars.cmd"

# Comment out lines 43 through 47
sed -i '39,46{/^REM /!s/^/REM /}' "$CMD_FILE"

# Remove consistency checker
sed -i 's/-Dpos.plugin_mode=%PLUGIN_MODE% com.gk_software.pos.Main/-Dpos.plugin_mode=%PLUGIN_MODE% -Dgkr.opos.consistency-checker.enabled=false com.gk_software.pos.Main/g' C:/DEV_HOME/CMX/ws-pos/git/pos/build/pos-full/pos-full-sandbox/_sandbox__0037/run_tpos.cmd

echo "Lines 39 to 46 in $CMD_FILE have been commented out."
