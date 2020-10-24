$fireeyeFeed      = "https://www.myget.org/F/fireeye/api/v2"
$ErrorActionPreference = 'Continue'

function InitialSetup {
	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
	# Chocolatey setup
	Write-Host "Initializing chocolatey"
	$toolListDirShortcut = Join-Path ${Env:UserProfile} "Desktop\Tools.lnk"
	[Environment]::SetEnvironmentVariable("TOOL_LIST_SHORTCUT", $toolListDirShortcut, 2)
	iex "choco sources add -n=fireeye -s $fireeyeFeed --priority 1"
	iex "choco feature enable -n allowGlobalConfirmation"
	iex "choco feature enable -n allowEmptyChecksums"
}
function MiscSetup {
	#disable windows defender
	sc config WinDefend start= disabled
	sc stop WinDefend

}

function Main {
	InitialSetup
	MiscSetup
cinst common.fireeye
cinst .\packages.config
certutil -urlcache -f https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.1.1dev/cme-windows-latest.1.zip cme-windows.zip
certutil -urlcache -f https://github.com/byt3bl33d3r/CrackMapExec/releases/download/v5.1.1dev/cme-ubuntu-latest.4.zip cme-ubuntu.zip
}

Main
