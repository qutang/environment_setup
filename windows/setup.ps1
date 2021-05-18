#### -> HELPER FUNCTIONS ####
function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

#### <- HELPER FUNCTIONS ####

#### -> PREREQUISITES ####

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host "Installing Chocolatey first..."
    Write-Host "------------------------------------" 
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Installed Chocolatey" -ForegroundColor Green
}
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
    Write-Host "Scoop is already installed, skip installation."
}
else {
    Write-Host "Installing scoop..."
    Write-Host "------------------------------------" 
    iwr -useb https://get.scoop.sh | iex
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

# ######## -> Install using native windows store #########
Write-Host "Installing softwares using Windows "

# ######## <- Install using native windows store #########

# ######## -> COMMON TOOLS CONFIGURATION ########
Write-Host "Installing common tools using choco"

$Apps = @(
    #Browsers
    "microsoft-edge",
    "googlechrome",
    "firefox",
    
    #Communications
    "skype",
    "microsoft-teams.install",
    #"teamviewer",
    
    #Editing
    "notepadplusplus.install",
    "grammarly",
    
    # Media players and production
    "vlc",
    #"kdenlive", # Supports standalone 
    "obs-studio",
    
    # Network & Debugging
    "fiddler",
    "logparser",
    "postman",
    "sysinternals",
    "wget",
    "wireshark",

    #office
    "powerbi",

    #Scriptings
    "powershell-core",
    
    #Utils
    "filezilla",
    "greenshot"

    #"lightshot.install",
)

foreach ($app in $Apps) {
    cinst $app -y
} 
Write-Host "Installed common tools" -Foreground green
######## <- COMMON TOOLS CONFIGURATION ########

######## -> DEV TOOLS CONFIGURATION ########
Write-Host "Installing dev tools using choco"
$devTools = @(
    #Editors
    "vscode",
    #Version control    
    "git",
    #.Net
    "dotnetcore-sdk",
    "dotpeek",
    "debugdiagnostic",
    #Uncomment below line for service fabric
    #"service-fabric-explorer",
    #NodeJS
    "nodejs-lts",
    #Python
    "python3",
    #Database
    "ssms",
    # hosting on cloud
    "azure-cli",
    # Diagramming
    "graphviz"
)
foreach ($devTool in $devTools) {
    cinst $devTool -y
}

###### -> Install VS Code Extensions #######
$vsCodeExtensions = @(
    "jebbs.plantuml",
    "evilz.vscode-reveal",
    "streetsidesoftware.code-spell-checker",
    "ms-azuretools.vscode-docker"
)
Write-Host "Installing VS Code extensions"
$vsCodeExtensions | ForEach-Object { code --install-extension $_ }
Write-Host "Installed VS Code Extensions" -Foreground green
Write-Host "Installed dev tools" -Foreground green
######## <- DEV TOOLS CONFIGURATION ########

#### -> PERSONALIZE ####
git config --global user.email "joymon@gmail.com"
git config --global user.name "Joy George Kunjikkuru"

#### <- PERSONALIZE ####