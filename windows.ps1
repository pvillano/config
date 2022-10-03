#!/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -File

# remember to set the execution policy first
# (In an admin powershell)
# Set-ExecutionPolicy RemoteSigned
# also install wsl
# wsl --install
# reboot


$uninstall_app_ids = @(
    "Microsoft.549981C3F5F10_8wekyb3d8bbwe",
    "Microsoft.BingNews_8wekyb3d8bbwe",
    "Microsoft.BingWeather_8wekyb3d8bbwe",
    "Microsoft.Edge",
    "Microsoft.EdgeWebView2Runtime",
    "Microsoft.Getstarted_8wekyb3d8bbwe",
    "Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe",
    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
    "Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe",
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
    "Microsoft.OneDrive",
    "Microsoft.OneDriveSync_8wekyb3d8bbwe",
    "Microsoft.People_8wekyb3d8bbwe",
    "Microsoft.Todos_8wekyb3d8bbwe",
    "Microsoft.WindowsAlarms_8wekyb3d8bbwe",
    "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
    "Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe",
    "Microsoft.WindowsMaps_8wekyb3d8bbwe",
    "Microsoft.ZuneMusic_8wekyb3d8bbwe",
    "Microsoft.ZuneVideo_8wekyb3d8bbwe",
    "Microsoft Edge Update",
    "MicrosoftTeams_8wekyb3d8bbwe"
);
Foreach ($app_id in $uninstall_app_ids) {
    winget uninstall --silent --id $app_id
}

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
    "eloston.ungoogled-chromium" ,
    "EpicGames.EpicGamesLauncher" ,
    "GIMP.GIMP" ,
    "Git.Git" ,
    "GitHub.GitHubDesktop" ,
    "GOG.Galaxy" ,
    "Google.ChromeRemoteDesktop" ,
    "Inkscape.Inkscape" ,
    "ItchIo.Itch" ,
    "JetBrains.PyCharm.Community" ,
    "Julialang.Julia" ,
    "Microsoft.PowerShell" ,
    "Microsoft.VisualStudio.2022.BuildTools" ,
    "Microsoft.WindowsTerminal" ,
    "Microsoft.WindowsSDK" ,
    "Microsoft.YourPhone_8wekyb3d8bbwe" ,
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
    "RaspberryPiFoundation.RaspberryPiImager" ,
    "Resplendence.LatencyMon" ,
    "Rustlang.Rustup" ,
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


# registry tweaks - untested

# disable Bing in Start Menu
New-Item -Path HKCU:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Value 0


$app_urls = @(
    "https://www.autodesk.com/products/fusion-360/personal-download",
    "https://www.blizzard.com/en-us/download/confirmation?platform=windows&locale=en_US&product=bnetdesk",
    "https://lychee.mango3d.io/",
    "https://mobaxterm.mobatek.net/download-home-edition.html",
    "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"
);

Foreach ($app_url in $app_urls) {
    Start-Process $app_url
}

