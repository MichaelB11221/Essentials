# Template to download individual raw files from a GitHub repo

# Define variables
$repoOwner = "MichaelB11221"
$repoName = "AutomatedInstalls"
$branch = "main"
$folderPathInRepo = "Appx"
$downloadPath = "$env:USERPROFILE\Desktop\DownloadedAppx"

# List of files to download (add your filenames here)
$files = @(
    "Microsoft.NET.Native.Framework.2.2_2.2.29512.0_x64__8wekyb3d8bbwe.Appx",
    "Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_x64__8wekyb3d8bbwe.Appx",
    "Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.Appx",
    "Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64__8wekyb3d8bbwe.Appx",
    "Microsoft.VCLibs.140.00_14.0.33519.0_x64__8wekyb3d8bbwe.Appx",
    "Microsoft.WindowsAppRuntime.1.6_6000.457.2140.0_x64__8wekyb3d8bbwe.Msix",
    "Microsoft.XboxIdentityProvider_12.64.28001.0_neutral___8wekyb3d8bbwe.AppxBundle",
    "UAPSignedBinary_Microsoft.DirectX.x64.appx",
    "Microsoft.GamingServices_2.42.5001.0_neutral___8wekyb3d8bbwe.AppxBundle",
    "Microsoft.GamingServices_2.42.24002.0_neutral___8wekyb3d8bbwe.AppxBundle",
    "Microsoft.GamingApp_2504.1001.26.0_neutral_~_8wekyb3d8bbwe.Msixbundle"
)

# Create the download directory if it doesn't exist
if (!(Test-Path $downloadPath)) { New-Item -ItemType Directory -Path $downloadPath | Out-Null }

foreach ($file in $files) {
    $rawUrl = "https://raw.githubusercontent.com/$repoOwner/$repoName/$branch/$folderPathInRepo/$file"
    $outFile = Join-Path $downloadPath $file
    Write-Output "Downloading $file..."
    try {
        Invoke-WebRequest -Uri $rawUrl -OutFile $outFile -ErrorAction Stop
        Write-Output "Downloaded $file to $downloadPath"
    } catch {
        Write-Output "Failed to download $file"
    }
}