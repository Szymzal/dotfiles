# Self-Elevate if requied
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

mkdir logs -ErrorAction SilentlyContinue | Out-Null

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

function Command-Exists([string]$command) {
    try { if (Get-Command $command) { return $true } }
    Catch { $false }
}

function Install-Packages {
    echo "INFO: Installing packages..."
    scoop bucket add main
    scoop bucket add extras
    scoop bucket add versions
    scoop install winget wingetui flow-launcher git notepadplusplus steam docker
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
    } else {
        echo "INFO: Skipping installation of WSL..."
    }
}

function Main {
    if (Install-Scoop) {
        Install-Packages
        Install-WSL
    } else {
        echo "ERROR: Failed to install scoop. Look in 'logs/scoop.log' to get more info."
    }

    pause
}

Main