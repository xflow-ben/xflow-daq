param (
    [string]$sourceFilePath,      # Source file path for the file to compress
    [string]$destinationFilePath  # Destination file path for the compressed file
)

# Start 7zip in the background for the given file
$7zipProcess = Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a -t7z `"$destinationFilePath`" `"$sourceFilePath`"" -NoNewWindow -PassThru

# Set 7zip process priority to Low using wmic
# wmic process where "ProcessId=$($7zipProcess.Id)" CALL setpriority 64

# Set CPU affinity to limit the number of cores 7zip can use (e.g., using 2 cores)
# $affinity = 1 # Binary 11 = CPU 0 and CPU 1, adjust as needed
# $processHandle = (Get-Process -Id $7zipProcess.Id).Handle
# $process = [System.Diagnostics.Process]::GetProcessById($7zipProcess.Id)
# $process.ProcessorAffinity = [intptr]$affinity

# Wait for 7zip to complete
$7zipProcess.WaitForExit()

Write-Host "7zip process for $sourceFilePath finished."
