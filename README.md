
# Steps

1. Install by clicking [here](https://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/qutang/environment_setup/main/windows/setup.ps1).
2. Setup Rstudio manually
   1. Open Rstudio by `Ctrl + click` the icon to set the R executable path before starting Rstudio. The R executable path should be easily found in the scoop shim folder.
   2. Set the git path in Rstudio's Global Options dialog to `C:\Users\[username]\scoop\apps\git\current\bin\git.exe` instead of using the shim shortcut cmdlet to avoid a known [issue](https://github.com/lukesampson/scoop/issues/1028#issuecomment-843650134).