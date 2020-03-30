# start-sc.ps1
# Runs the requirements for Star Citizen, then starts the launcher.
# 20200329 21:48 Derek Moyes <derek.moyes at gmail dot com>
# To run this script from the command prompt, aor from a shortcut, you'll need to change the 
#   Execution Policy for PowerShell scripts, like this:
#   ps> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7

clear

# Start JoyToKey
# https://joytokey.net/en/
"=== Starting JoyToKey ==="
Start-Process "C:\Games\JoyToKey\JoyToKey.exe"

# Start GameGlass 
# https://gameglass.gg/ 
"=== Starting GameGlass ==="
Start-Process -FilePath "C:\Program Files\GameGlass\launcher.exe" -WorkingDirectory "C:\Program Files\GameGlass" -Verb RunAs

# Check free memory
$freemem = Get-WmiObject -Class Win32_OperatingSystem
While (([math]::round(($freemem.FreePhysicalMemory / 1024 / 1024), 2)) -lt 10)
    {
	""
	""
	"=== Free Memory Under 10GB, currently {0} GB ===" -f ([math]::round(($freemem.FreePhysicalMemory / 1024 / 1024), 2))
	""
	""
	Read-Host -Prompt "Free up some RAM, then press Enter to continue"
	$freemem = Get-WmiObject -Class Win32_OperatingSystem
    }
"=== Free Memory {0} GB ===" -f ([math]::round(($freemem.FreePhysicalMemory / 1024 / 1024), 2))

# Wait a number of seconds for GameGlass to start.
$sleepseconds = 10
"=== Waiting $sleepseconds for GameGlass to start ==="
Start-Sleep -Second $sleepseconds

# Start Star Citizen Launcher
# https://robertsspaceindustries.com/
"=== Starting Star Citizen Launcher ==="
Start-Process -FilePath "C:\Games\RSI Launcher\RSI Launcher.exe" -WorkingDirectory "C:\Games\RSI Launcher"
