param (
    [string]$sourceFilePath,      # Source file path for the file to copy
    [string]$destinationFilePath  # Destination file path for the copied file
)

# Define constants
$maxRetries = 5          # Maximum number of retries
$retryWaitTime = 10      # Wait time between retries in seconds
$ipgValue = 8           # Inter-Packet Gap (IPG) in milliseconds to control transfer rate (tune this to achieve desired speed)

$retryCount = 0
$success = $false

# Extract the directory and file names from the paths
$sourceDir = Split-Path $sourceFilePath
$sourceFileName = Split-Path $sourceFilePath -Leaf
$destinationDir = Split-Path $destinationFilePath

while (-not $success -and $retryCount -lt $maxRetries) {
    try {
        # Use robocopy for the file copy with bandwidth control
        $robocopyCommand = "robocopy `"$sourceDir`" `"$destinationDir`" `"$sourceFileName`" /IPG:$ipgValue /R:0 /W:0 /Z"

        Write-Host "Executing: $robocopyCommand"
        $result = Invoke-Expression $robocopyCommand

        # Check if robocopy succeeded (robocopy returns 1 for success)
        if ($LASTEXITCODE -eq 1) {
            $success = $true
            Write-Host "File copy completed successfully."
        } else {
            throw "robocopy failed with exit code $LASTEXITCODE"
        }

    } catch {
        # Handle failure and retry
        $retryCount++
        Write-Host "File copy failed. Retrying in $retryWaitTime seconds... (Attempt $retryCount of $maxRetries)"
        Start-Sleep -Seconds $retryWaitTime
    }
}

if (-not $success) {
    Write-Host "File copy failed after $maxRetries attempts."
}
