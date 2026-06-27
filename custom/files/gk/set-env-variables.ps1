# Set the local and shared home directories
# In PowerShell, $PWD gets the current working directory object
$env:LOCAL_HOME = $PWD.Path
$env:SHARED_HOME = "C:\DEV_HOME"
$env:DEV_HOME = "C:\DEV_HOME"

# Set Neovim's binary path
$env:NVIM_BIN = "C:\DEV_HOME\TOOLS\neovim\nvim-win64\bin"

# Set Gitlab plugin token
$env:GITLAB_TOKEN = "glpat-exW8LcntjnsFohzGc9SXYW86MQp1OjE5Ngk.01.0z1vwt4q3"
$env:GITLAB_URL = "https://gitlab.gk.gk-software.com/"
$env:GITLAB_VIM_URL = "https://gitlab.gk.gk-software.com/"

# Set JAVA_HOME for Java 21
$env:JAVA_HOME = "$env:SHARED_HOME\TOOLS\java\21.0.6"
$env:JAVA_1_6_HOME = $env:JAVA_HOME
$env:JAVA_1_8_HOME = $env:JAVA_HOME
$env:JAVA_1_11_HOME = $env:JAVA_HOME
$env:JAVA_11_HOME = $env:JAVA_1_11_HOME

# Set Maven-related variables
$env:M2_HOME = "$env:SHARED_HOME\TOOLS\mvn\apache-maven-3.6.3"
$env:MAVEN_HOME = $env:M2_HOME
$env:MAVEN_OPTS = "-Xmx3g -Dmaven.multiModuleProjectDirectory"

# Set other tool paths
$env:FD_HOME = "C:\DEV_HOME\TOOLS\fd-pc-windows-gnu"
$env:PYTHON_HOME = "C:\DEV_HOME\TOOLS\python3.13.4"
$env:RIPGREP_HOME = "C:\DEV_HOME\TOOLS\ripgrep"
$env:RIPGREP_ALL_HOME = "C:\DEV_HOME\TOOLS\ripgrep_all"
$env:GCC_HOME = "C:\DEV_HOME\TOOLS\mingw64\bin"
$env:PSQL_HOME = "C:\Program Files\PostgreSQL\16\bin"
$env:GO_HOME = "C:\DEV_HOME\TOOLS\go\bin"
$env:DERBY_HOME = "C:\DEV_HOME\TOOLS\db-derby-10.17.1.0-bin\bin"

# Set NPM binary path
$env:NPM = "C:\Users\vaquilar\AppData\Roaming\npm"

# Update the PATH variable, using ';' as the separator for Windows/PowerShell
$NewPaths = @(
    "$env:LOCAL_HOME\scripts",
    "$env:SHARED_HOME\scripts",
    "$env:M2_HOME\bin",
    $env:PATH,
    $env:NVIM_BIN,
    $env:GCC_HOME,
    $env:RIPGREP_HOME,
    $env:RIPGREP_ALL_HOME,
    $env:PYTHON_HOME,
    $env:FD_HOME,
    $env:PSQL_HOME,
    $env:GO_HOME,
    $env:DERBY_HOME,
    $env:NPM
)
$env:PATH = $NewPaths -join ";"

# Useful commands / Aliases
# Note: 'less' isn't native to PowerShell, but if you have git-bash installed, 
# PowerShell can usually find it. If not, 'more' is built-in anyway.
Set-Alias -Name ll -Value Get-ChildItem

# Display a confirmation message
Write-Host "Environment variables have been updated for PowerShell."