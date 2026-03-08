#!/bin/bash
# This script is to run the POS... make sure the jar fix signature is in place
# ==================================
echo "Running run_tpos script"

# Get the absolute path of the directory where the script is located.
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Compile custom code
source $SCRIPT_DIR/../set-env-variables.sh
export JAVA_HOME="$SHARED_HOME/TOOLS/java/1.8.0_111"
mvn clean install -Dfast -f C:/DEV_HOME/CMX/ws-pos/git/pos/client/mod-functions-client-cst/pom.xml
mvn clean install -Dfast -f C:/DEV_HOME/CMX/ws-pos/git/pos/build/pos-full/pos-full-deployment/pom.xml

# Change to the directory where this script is located
cd "$(dirname "$0")"

# Fix the defailtVars.cmd needed to run in Git-Bash
./fix_bash_defaultVars.sh

# Change to the specific POS sandbox directory
cd /c/DEV_HOME/CMX/ws-pos/git/pos/build/pos-full/pos-full-sandbox/_sandbox__0037/

# Run the POS
echo "Running run_tpos.cmd..."
./run_tpos.cmd

RETURN_CODE=$?
echo "Script execution completed with return code: $RETURN_CODE"
