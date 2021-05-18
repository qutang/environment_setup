#### -> HELPER FUNCTIONS ####
function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

Set-ExecutionPolicy Bypass -Scope Process -Force; 

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, attempt to update it."
    choco upgrade chocolatey -y
}
else {
    Write-Host "Installing Chocolatey first..."
    Write-Host "------------------------------------" 
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
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
    Write-Host "Scoop is already installed, attempt to update it."
    scoop update
}
else {
    Write-Host "Installing scoop..."
    Write-Host "------------------------------------"
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser | iwr -useb https://get.scoop.sh | iex
    Write-Host "Installed Scoop" -ForegroundColor Green
}