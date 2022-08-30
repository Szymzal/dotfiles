mkdir logs -ErrorAction SilentlyContinue | Out-Null

function Install-Scoop {
    echo "INFO: Installing scoop..."

    irm get.scoop.sh -OutFile 'install-scoop.ps1'
    .\install-scoop.ps1 > .\logs\scoop.log
    rm .\install-scoop.ps1
}

function Command-Exists([string]$command) {
    try { if (Get-Command $command) { return $true } }
    Catch { $false }
}

function Install-Packages {
    scoop bucket add main
    scoop bucket add extras
    scoop install 
}

function Main {
    if (Command-Exists("scoop")) {
        echo "INFO: Skipping installation of scoop..."
        $SCOOPINSTALLED = $true
    }
    else {
        Install-Scoop
    }

    if ( $LASTEXITCODE -eq 0 -or $SCOOPINSTALLED -eq $true ) {
        Install-Packages
    } else {
        echo "ERROR: Failed to install scoop. Look in 'logs/scoop.log' to get more info."
    }
}

Main