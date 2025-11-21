# Detect active PostgreSQL service
$service = Get-Service | Where-Object { $_.Name -like "postgresql*" -and $_.Status -eq "Running" }

if (-not $service) {
    Write-Host "❌ No running PostgreSQL service found. Start one manually or check installation."
    exit
}

Write-Host "✅ Active PostgreSQL service: $($service.Name)"

# Extract version from service name
$version = ($service.Name -split "-")[-1]
$dataPath = "C:\Program Files\PostgreSQL\$version\data"

if (-not (Test-Path $dataPath)) {
    Write-Host "❌ Data directory not found at $dataPath"
    exit
}

Write-Host "✅ Found data directory: $dataPath"

# Update postgresql.conf
$confFile = Join-Path $dataPath "postgresql.conf"
if (Test-Path $confFile) {
    (Get-Content $confFile) -replace '#listen_addresses = ''localhost''', 'listen_addresses = ''*''' | Set-Content $confFile
    Write-Host "✅ Updated listen_addresses in postgresql.conf"
} else {
    Write-Host "❌ postgresql.conf not found"
}

# Update pg_hba.conf
$hbaFile = Join-Path $dataPath "pg_hba.conf"
if (Test-Path $hbaFile) {
    Add-Content $hbaFile "`nhost    all             all             127.0.0.1/32           md5"
    Add-Content $hbaFile "`nhost    all             all             ::1/128                md5"
    Write-Host "✅ Added IPv4 and IPv6 authentication rules to pg_hba.conf"
} else {
    Write-Host "❌ pg_hba.conf not found"
}

# Restart PostgreSQL service
Write-Host "🔄 Restarting PostgreSQL service..."
Stop-Service $service.Name
Start-Service $service.Name
Write-Host "✅ PostgreSQL service restarted successfully!"