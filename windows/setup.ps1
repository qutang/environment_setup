#### -> HELPER FUNCTIONS ####
function Check-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

#### <- HELPER FUNCTIONS ####

#### -> PREREQUISITES ####

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

if (Check-Command -cmdname 'Install-BoxstarterPackage')
{
    Write-Host "Boxstarter is already installed, skip installation."
} else
{
    Write-Host "Installing Boxstarter..."
    Write-Host "------------------------------------" 
    . { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
    Write-Host "Installed Boxstarter" -ForegroundColor Green
}
if (Check-Command -cmdname 'scoop')
{
    Write-Host "Scoop is already installed, attempt to update it."    
} else
{
    Write-Host "Installing scoop..."
    Write-Host "------------------------------------"
    iwr -useb 'https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1' | iex
    Write-Host "Installed Scoop" -ForegroundColor Green
}

scoop install git sudo aria2
scoop bucket add extras
scoop bucket add scoopet https://github.com/integzz/scoopet
scoop bucket add dorado https://github.com/chawyehsu/dorado
scoop bucket add Ash258 https://github.com/Ash258/Scoop-Ash258.git
scoop bucket add java
scoop bucket add JetBrains
scoop bucket add versions
scoop update

# Setup scoop
scoop config aria2-enabled true
scoop config aria2-retry-wait 4
scoop config aria2-split 16
scoop config aria2-max-connection-per-server 16
scoop config aria2-min-split-size 4M
scoop update
# disable if on VPN
# scoop config aria2-enabled false 

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
    "powertoys",
    "jamovi",
    "quicklook",
    "extras/totalcommander",
    "texmaker",
    "portable-virtualbox",
    "yuque",
    "wechat",
    "grammarly",
    "tencent-meeting",
    "dorado/neteasemusic",
    "translucenttb",
    "lxmusic -s",
    "aria-ng-gui",
    "inkscape",
    "bilibili-livehime",
    "locale-emulator",
    "dorado/wechatwork",
    "extras/vcredist2019",
    "dorado/qq",
    "dorado/qqmusic",
    "winaero-tweaker",

    # Utils
    "pshazz",
    "latex",
    "ruby",
    "which",
    "grep",
    "make",
    "perl",
    "zip",
    "unzip",
    "scoop-search",
    "scoop-completion",
    "python",
    "nodejs",
    "r",
    "wget",
    "curl",
    "yarn",
    "graphviz",
    "rtools",
    "youtube-dl",
    "cygwin -s",
    "xming",
    "psutils",
    "ffmpeg",
    "pandoc",
    "main/docker",
    "oraclejre8",
    "msys2",
    "android-sdk",
    "syncthing",
    "cwrsync", # rsync replacement on Windows
    "scoopet/winget"
)

foreach ($app in $Apps)
{
    scoop install $app
} 

scoop uninstall vcredist2019

Write-Host "Installed common tools using scoop" -Foreground green
######## <- COMMON TOOLS CONFIGURATION ########

# ######## -> WINGET TOOLS CONFIGURATION ########
Write-Host "Installing softwares using winget"

$Apps = @(
    "Zoom.Zoom",
    "WhatsApp",
    "Microsoft.Teams",
    "Microsoft.VisualStudio.2019.Community"
)

foreach ($app in $Apps)
{
    winget install $app
} 

Write-Host "Installed softwares using winget" -Foreground green
######## <- WINGET TOOLS CONFIGURATION ########

#######  -> POST PROCESS ########
Write-Host "Setup system using the installed scripts"

# Post process

# Enable auto completion for scoop
Add-Content -Path $Profile -Value "`nImport-Module $env:USERPROFILE\scoop\modules\scoop-completion"
# Enable super fast scoop search
Add-Content -Path $Profile -Value "Invoke-Expression (&scoop-search --hook)"


Write-Host "Setup powershell"
pshazz use steeef

Write-Host "Setup node"
nvm install latest
nvm on
node --version

Write-Host "Setup python"
pip install nox

Write-Host "Setup git"
git config --global user.name "qutang"
git config --global user.email "qu.tang@outlook.com"

####### <- POST PROCESS #########

####### -> CLEAN UP ##########

Write-Host "Clean up scoop cache"
scoop cache rm *
scoop cleanup *

####### <- CLEAN UP ##########