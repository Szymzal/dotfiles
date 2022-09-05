param($Step="A")

# Portions of this scipt were copied from: 
# https://www.codeproject.com/Articles/223002/Reboot-and-Resume-PowerShell-Script

# Imports
$script = $MyInvocation.MyCommand.Definition

$global:started = $False
$global:startingStep = $Step
$global:RegRunKey ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$global:restartKey = "Restart-And-Resume"
$global:powershell = "C:\Program Files\PowerShell\7\pwsh.exe"

# Functions
function Self-Elevate {
    # Self-Elevate if requied
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-File `"" + $MyInvocation.PSCommandPath + "`" -Step " + $Step
            Start-Process -FilePath $global:powershell -Verb Runas -ArgumentList $CommandLine
            Exit
        }
    }
}

function Install-Scoop {
    if (Command-Exists("scoop")) {
        echo "INFO: Skipping installation of scoop..."
        return $true
    }
    else {
        echo "INFO: Installing scoop..."

        irm get.scoop.sh -OutFile 'install-scoop.ps1'
        .\install-scoop.ps1 > .\logs\scoop.log
        rm .\install-scoop.ps1

        if ($LASTEXITCODE -eq 0) {
            return $true
        } else {
            return $false
        }
    }
}

function Command-Exists([string] $command) {
    try { if (Get-Command $command) { return $true } }
    Catch { $false }
}

function Install-Packages {
    echo "INFO: Installing packages..."
    scoop bucket add main
    scoop bucket add extras
    scoop bucket add versions
    scoop install winget wingetui flow-launcher git notepadplusplus steam docker playnite
    winget install --id Microsoft.PowerShell --silent
}

function WSL-Installed {
    $LinuxState = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | findstr "State"
    $LinuxState = $LinuxState -replace "^.*?:"
    $LinuxState = $LinuxState.Trim()

    if ($LinuxState -eq "Enabled") {
        return $true
    }

    return $false
}

function Install-WSL {
    if (-Not (WSL-Installed)) {
        echo "INFO: Installing WSL..."

        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

        return $TRUE
    } else {
        echo "INFO: Skipping installation of WSL..."

        return $FALSE
    }
}

function Create-Logs-Folder {
    mkdir logs -ErrorAction SilentlyContinue | Out-Null
}

function Should-Run-Step([string] $prospectStep) {
    if ($global:startingStep -eq $prospectStep -or $global:started) {
        $global:started = $TRUE
    }
    return $global:started
}

function Test-Key([string] $path, [string] $key) {
    return ((Test-Path $path) -and ((Get-Key $path $key) -ne $null))   
}

function Remove-Key([string] $path, [string] $key) {
    Remove-ItemProperty -path $path -name $key
}

function Set-Key([string] $path, [string] $key, [string] $value) {
    Set-ItemProperty -path $path -name $key -value $value
}

function Get-Key([string] $path, [string] $key) {
    return (Get-ItemProperty $path).$key
}

function Restart-And-Run([string] $key, [string] $run) {
    Set-Key $global:RegRunKey $key $run
    Restart-Computer
    exit
}

function Clear-Any-Restart([string] $key=$global:restartKey) {
    if (Test-Key $global:RegRunKey $key) {
        Remove-Key $global:RegRunKey $key
    }
}

function Restart-And-Resume([string] $script, [string] $step) {
    Restart-And-Run $global:restartKey "$global:powershell $script -Step `"$step`""
}

# Main Function
function Main {
    Self-Elevate
    Clear-Any-Restart

    if (Should-Run-Step "A") {
        Create-Logs-Folder

        echo "Computer will be restarted, press Enter to continue..."
        pause
        Restart-And-Resume $script "B"

        #if (Install-Scoop) {
        #    Install-Packages
        #    if (Install-WSL) {
        #        echo "Computer will be restarted, press Enter to continue..."
        #        pause
        #        Restart-And-Resume($script, "B")
        #    }


        #} else {
        #    echo "ERROR: Failed to install scoop. Look in 'logs/scoop.log' to get more info."
        #}
    }

    if (Should-Run-Step "B") {
        echo "Hey in new place!"
    }

    pause
}

Main