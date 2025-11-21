# ...existing code...
# Ensure PGPASSWORD is set for this session
$env:PGPASSWORD = "admin123"

# Create the database (run against postgres DB)
Write-Host "Creating database from database\create_database.sql..." -ForegroundColor Yellow
psql -U postgres -d postgres -f .\database\create_database.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create database. See psql output above." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Database created or already replaced." -ForegroundColor Green

# Apply schema to alliance_property
Write-Host "Applying schema from database\schema.sql..." -ForegroundColor Yellow
psql -U postgres -d alliance_property -f .\database\schema.sql
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to apply schema. See psql output above." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Schema applied successfully." -ForegroundColor Green
# ...existing code...

pause