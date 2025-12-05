# Set the local and shared home directories
# In Bash, $(pwd) gets the current directory and the paths are converted to a Unix-like format
export LOCAL_HOME=$(pwd)
export SHARED_HOME="/c/DEV_HOME"

# Set Neovim's binary path
export NVIM_BIN="/c/DEV_HOME/TOOLS/neovim/nvim-win64/bin"

# Set JAVA_HOME for Java 21
export JAVA_HOME="$SHARED_HOME/TOOLS/java/21.0.6"
export JAVA_1_6_HOME="$JAVA_HOME"
export JAVA_1_8_HOME="$JAVA_HOME"
export JAVA_1_11_HOME="$JAVA_HOME"
export JAVA_11_HOME="$JAVA_1_11_HOME"

# Set Maven-related variables
export M2_HOME="$SHARED_HOME/TOOLS/mvn/apache-maven-3.6.3"
export MAVEN_HOME="$M2_HOME"
export MAVEN_OPTS="-Xmx3g -XX:MaxPermSize=1g -Dmaven.multiModuleProjectDirectory"

# Set other tool paths
export FD_HOME="/c/DEV_HOME/TOOLS/fd-pc-windows-gnu"
export PYTHON_HOME="/c/DEV_HOME/TOOLS/python3.13.4"
export RIPGREP_HOME="/c/DEV_HOME/TOOLS/ripgrep"
export GCC_HOME="/c/DEV_HOME/TOOLS/mingw64/bin"
export PSQL_HOME="/c/Program Files/PostgreSQL/16/bin"

# Update the PATH variable, using ':' as the separator for Bash
export PATH="$LOCAL_HOME/scripts:$SHARED_HOME/scripts:$M2_HOME/bin:$PATH:$NVIM_BIN:$GCC_HOME:$RIPGREP_HOME:$PYTHON_HOME:$FD_HOME:$PSQL_HOME"

# usefull commands:
alias more="less -de"

# Display a confirmation message with the new PATH
echo "Environment variables have been updated."
# echo "New PATH: $PATH"

