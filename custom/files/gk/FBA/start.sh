#!/bin/bash

export LOCAL_HOME=$(pwd)
export SHARED_HOME="/c/DEV_HOME"

# Set Neovim's binary path
export NVIM_BIN="/c/DEV_HOME/TOOLS/neovim/nvim-win64/bin"

# Set JAVA_HOME for Java 8
export JAVA_HOME="$SHARED_HOME/TOOLS/java/1.8.0_111"
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

# Update the PATH variable, using ':' as the separator for Bash
export PATH="$LOCAL_HOME/scripts:$SHARED_HOME/scripts:$M2_HOME/bin:$PATH:$NVIM_BIN:$GCC_HOME:$RIPGREP_HOME:$PYTHON_HOME:$FD_HOME"

echo "all variables are set..."
