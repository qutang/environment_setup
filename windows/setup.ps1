#### -> HELPER FUNCTIONS ####
function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

#### <- HELPER FUNCTIONS ####

#### -> PREREQUISITES ####

Set-ExecutionPolicy Bypass -Scope Process -Force; 

if (Check-Command -cmdname 'Install-BoxstarterPackage') {
    Write-Host "Boxstarter is already installed, skip installation."
}
else {
    Write-Host "Installing Boxstarter..."
    Write-Host "------------------------------------" 
    . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
    Write-Host "Installed Boxstarter" -ForegroundColor Green
}
if (Check-Command -cmdname 'scoop') {
    Write-Host "Scoop is already installed, attempt to update it."
    scoop bucket add extras
    scoop update
    
}
else {
    Write-Host "Installing scoop..."
    Write-Host "------------------------------------"
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser | iwr -useb https://get.scoop.sh | iex
    scoop bucket add extras
    scoop update
    Write-Host "Installed Scoop" -ForegroundColor Green
}

# #### <- PREREQUISITES ####

# ######## -> ENVIRONMENT CONFIGURATION ########

Write-Host "Setting up power options"
# reference: https://docs.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options#option_change
# Connected to power, never turn off monitor
Powercfg /Change monitor-timeout-ac 0
# Connected to power, never go to sleep
Powercfg /Change standby-timeout-ac 0
# On battery, turn off monitor in 15 minutes
Powercfg /Change monitor-timeout-dc 15
# On battery, go to sleep in 30 minutes
Powercfg /Change standby-timeout-dc 30
Write-Host "Completed power options" -Foreground green

# Show hidden files, Show protected OS files, Show file extensions
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions

# ######## <- ENVIRONMENT CONFIGURATION ########

# ######## -> COMMON TOOLS CONFIGURATION ########
Write-Host "Installing common tools using scoop"

$Apps = @(
    # Extras
    "zoom",
    "vscode-insiders",
    "android-studio",
    "rstudio",
    "obs-studio",
    "vlc",
    "filezilla",
    "screentogif",
    "mobaxterm",
    "inno-setup",
    "everything",
    "spacesniffer",
    "audacity",
    "windows-terminal",
    "github",
    "steam",
    "whatsapp",
    "powertoys",
    "jamovi",
    "quicklook",
    "totalcommander",
    "texmaker",
    "portable-virtualbox",

    # Utils
    "latex",
    "ruby",
    "which",
    "grep",
    "make",
    "perl",
    "zip",
    "unzip",
    "scoop-search",
    "python",
    "nvm",
    "r",
    "wget",
    "curl",
    "yarn",
    "graphviz",
    "rtools",
    "youtube-dl",
    "7zip",
    "git",
    "cygwin",
    "xming",
    "psutils"
)

foreach ($app in $Apps) {
    scoop install $app
} 

# Post process



Write-Host "Installed common tools using scoop" -Foreground green
######## <- COMMON TOOLS CONFIGURATION ########

#######  -> POST PROCESS ########
Write-Host "Setup system using the installed scripts"

Write-Host "Setup node"
nvm install node
nvm use node
node --version

Write-Host "Setup python"
python3 -m pip install --user pipx
python3 -m pipx ensurepath


####### <- POST PROCESS #########