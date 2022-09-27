param($Step="A")

# Portions of this scipt were copied from: 
# https://www.codeproject.com/Articles/223002/Reboot-and-Resume-PowerShell-Script
# https://gist.github.com/Splaxi/fe168eaa91eb8fb8d62eba21736dc88a

# Imports
$script = $MyInvocation.MyCommand.Definition

$global:started = $False
$global:startingStep = $Step
$global:RegRunKey ="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$global:restartKey = "Restart-And-Resume"
$global:powershell = "C:\Program Files\PowerShell\7\pwsh.exe"
$global:runError = $False
$global:WSLPath = "$env:USERPROFILE\WSL"

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
        Write-Host "Skipping installation of scoop..."
        return $true
    }
    else {
        Write-Host "Installing scoop..."

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
    Write-Host "Installing packages..."
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
        Write-Host "Installing WSL..."

        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
        Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux

        return $TRUE
    } else {
        Write-Host "Skipping installation of WSL..."

        return $FALSE
    }
}

function Create-Folders {
    mkdir logs -ErrorAction SilentlyContinue | Out-Null
    mkdir temp -ErrorAction SilentlyContinue | Out-Null
    mkdir "$global:WSLPath\Arch" -ErrorAction SilentlyContinue | Out-Null
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

function Download-Latest-From-Github([string] $repo, [string] $pattern, [string] $pathExtract) {
    $releasesUri = "https://api.github.com/repos/$repo/releases/latest"
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object name -like $pattern ).browser_download_url

    $pathZip = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $(Split-Path -Path $downloadUri -Leaf)

    Invoke-WebRequest -Uri $downloadUri -Out $pathZip

    Remove-Item -Path $pathExtract -Recurse -Force -ErrorAction SilentlyContinue

    Expand-Archive -Path $pathZip -DestinationPath $pathExtract -Force

    Remove-Item $pathZip -Force
}

function Install-Arch-WSL {
    Write-Host "Installing Arch Linux WSL installer..."

    $ArchWSLPath = "$global:WSLPath\Arch"
    Download-Latest-From-Github "yuk7/ArchWSL" "Arch_Online.zip" "$ArchWSLPath"

    Add-To-PATH-Environment-Variable User "$ArchWSLPath"

    if (Test-Path -Path "$ArchWSLPath\Arch.exe") {
        Write-Host "Installing Arch Linux WSL..."
        Invoke-Expression -Command "$ArchWSLPath\Arch.exe"

        $Result = Invoke-Expression -Command "wsl --list" | findstr "Arch"

        if ($Result -eq "") {
            return $FALSE
        }

        return $TRUE
    }

    return $FALSE
}

function Add-To-PATH-Environment-Variable([EnvironmentVariableTarget] $target, [string] $pathToAdd) {
    $oldPathValue = [Environment]::GetEnvironmentVariable("Path", $target)

    if (-Not ($oldPathValue.Contains($pathToAdd))) {
        Write-Host "Adding path to PATH variable..."
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$oldPathValue;$pathToAdd",
            $target
        )
    }

}

# Main Function
function Main {
    Self-Elevate
    Clear-Any-Restart
    Create-Folders

    if (Should-Run-Step "A") {
        $global:runError = (-Not (Install-Scoop))
        if (-Not $global:runError) {
            Install-Packages

            $global:runError = (-not (Install-WSL))
            if (-Not $global:runError) {
                Write-Host "Computer will be restarted, press Enter to continue..."
                pause
                Restart-And-Resume $script "B"
            }
        } else {
            Write-Error "Failed to install scoop. Look in 'logs/scoop.log' to get more info."
        }
    }

    if ((-Not $global:runError) -And (Should-Run-Step "B")) {
        $global:runError = (-Not (Install-Arch-WSL))

        if (-Not $global:runError) {
            Write-Host "Successfully installed Arch Linux!"
        } else {
            Write-Host "Failed to install Arch Linux!"
        }
    }

    pause
}

Main