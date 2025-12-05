
# Set the local and shared home directories
# In Bash, $(pwd) gets the current directory and the paths are converted to a Unix-like format
export LOCAL_HOME=$(pwd)
export SHARED_HOME="/c/DEV_HOME"

# Set JAVA_HOME for Java 21
export JAVA_HOME="$SHARED_HOME/TOOLS/java/1.8.0_111"

# Display a confirmation message with the new PATH
echo "Project specific environment variables have been updated."
# echo "New PATH: $PATH"

