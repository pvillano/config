#!/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -File

# remember to set the execution policy first
# (In an admin powershell)
# Set-ExecutionPolicy RemoteSigned

$app_ids = @(
    "7zip.7zip" ,
    "Amazon.Games" ,
    "angryziber.AngryIPScanner" ,
    "Balena.Etcher" ,
    "BlenderFoundation.Blender" ,
    "Canonical.Ubuntu" ,
    "CodeSector.TeraCopy" ,
    "CPUID.CPU-Z" ,
    "CPUID.HWMonitor" ,
    "CrystalDewWorld.CrystalDiskInfo" ,
    "CrystalDewWorld.CrystalDiskMark" ,
    "Discord.Discord" ,
    "ElectronicArts.EADesktop" ,
    "EpicGames.EpicGamesLauncher" ,
    "GIMP.GIMP" ,
    "Git.Git" ,
    "GitHub.GitHubDesktop" ,
    "GOG.Galaxy" ,
    "Google.ChromeRemoteDesktop" ,
    "Inkscape.Inkscape" ,
    "JetBrains.Toolbox" ,
    "Julialang.Julia" ,
    "Microsoft.PowerShell" ,
    "Microsoft.WindowsTerminal" ,
    "Mozilla.Firefox" ,
    "Mozilla.Firefox.DeveloperEdition" ,
    "MullvadVPN.MullvadVPN" ,
    "NexusMods.Vortex" ,
    "Notepad++.Notepad++" ,
    "OBSProject.OBSStudio" ,
    "OpenSCAD.OpenSCAD" ,
    "OpenWhisperSystems.Signal" ,
    "osk.tetr" ,
    "Prusa3D.PrusaSlicer" ,
    "Python.Python.3" ,
    "qBittorrent.qBittorrent" ,
    "QMK.QMKToolbox" ,
    "Spotify.Spotify" ,
    "Ubisoft.Connect" ,
    "Ultimaker.Cura" ,
    "Valve.Steam" ,
    "VideoLAN.VLC" ,
    "WinDirStat.WinDirStat"
);
# From https://chrislayers.com/2021/08/01/scripting-winget/
Foreach ($app_id in $app_ids) {
    #check if the app is already installed
    $listApp = winget list --id $app_id
    if (![String]::Join("", $listApp).Contains($app_id)) {
        winget install --silent --accept-package-agreements --id $app_id
    }
    else {
        Write-host $app_id already installed
    }
}

# Shutdown Timer doesn't have a semantic ID, so I'm making double sure
winget install --silent --accept-package-agreements --name "Shutdown Timer Classic" --id "9NTDG6C9BTTW"

# Autodesk Fusion 360
Start-Process "https://www.autodesk.com/products/fusion-360/personal-download"
# Battle.net
Start-Process "https://www.blizzard.com/en-us/download/confirmation?platform=windows&locale=en_US&product=bnetdesk"
# MobaXterm
Start-Process "https://mobaxterm.mobatek.net/download-home-edition.html"
# Rockstar Games Launcher
Start-Process "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"
