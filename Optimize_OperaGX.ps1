<#
Opera GX Flag Optimiser – Performance & Privacy
Compatible with malformed Preferences files
#>

Set-ExecutionPolicy Bypass -Scope Process -Force

# -------- locate profile & preferences --------
$profilePath = "$env:APPDATA\Opera Software\Opera GX Stable"
$prefFile    = Join-Path $profilePath "Preferences"
if (!(Test-Path $prefFile)) {
    Write-Error "Preferences not found – run Opera GX once, close it, then rerun this script."
    exit 1
}

# -------- safety backup --------
$backup = "$prefFile.bak_{0:yyyyMMdd_HHmmss}" -f (Get-Date)
Copy-Item $prefFile $backup -Force

# -------- read JSON as hashtable --------
$json = Get-Content $prefFile -Raw | ConvertFrom-Json -AsHashtable

# helper to ensure nested keys
function Ensure-Key {
    param($obj, $key, $default)
    if (-not $obj.ContainsKey($key)) {
        $obj[$key] = $default
    }
}

Ensure-Key $json        'browser' @{}
Ensure-Key $json.browser 'enabled_labs_experiments' @()
Ensure-Key $json.browser 'disabled_labs_experiments' @()
Ensure-Key $json        'profile' @{}

# ----- flag lists -----
$enable = @(
    "enable-parallel-downloading@2",
    "enable-quic@2",
    "back-forward-cache@2",
    "enable-zero-copy@2",
    "enable-gpu-rasterization@2",
    "enable-oop-rasterization@2",
    "threaded-scrolling@2",
    "smooth-scrolling@2",
    "enable-lazy-image-loading@2",
    "enable-lazy-frame-loading@2",
    "enable-webrtc-hide-local-ips-with-mdns@2",
    "strict-origin-isolation@2",
    "reduce-referrer-granularity@2"
)

$disable = @(
    "privacy-sandbox-ads-apis@2",
    "enable-fledge-api@2",
    "enable-topics-api@2",
    "enable-conversion-measurement@2",
    "interest-cohort@2",
    "hyperlink-auditing@2",
    "idle-detection@2"
)

# Merge unique
$json.browser.enabled_labs_experiments  = ($json.browser.enabled_labs_experiments + $enable ) | Sort-Object -Unique
$json.browser.disabled_labs_experiments = ($json.browser.disabled_labs_experiments + $disable) | Sort-Object -Unique

# Extra privacy prefs
$json.profile['dns_prefetching']             = 0
$json.profile['network_prediction_options']  = 2
$json.profile['metrics_reporting_enabled']   = 0

# Write back JSON properly formatted
$json | ConvertTo-Json -Depth 99 | Set-Content $prefFile -Encoding UTF8

Write-Host "`n✅  Opera GX flags optimised. Relaunch to apply changes." -ForegroundColor Green
