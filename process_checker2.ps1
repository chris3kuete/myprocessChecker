# Welcome message
Write-Host "`nWelcome to the process checker!`n"

# Set up a persistent run count
$countFile = "runcount.txt"
if (Test-Path $countFile){
    $fileContent = Get-Content $countFile
    # Use Regex to ensure this String only contains numbers
    if ($fileContent -match '^\d+$'){
        $global:scriptRunCount = [int]$fileContent
    }else{
        Write-Host "Invalid content in count file. Resetting count"
        $global:scriptRunCount = 0
    }
}else{
    $global:scriptRunCount = 0
}
# Set up a run count
$global:scriptRunCount++

# Initialize counters
$runningCount = 0
$notRunningCount = 0

# Function to check if a process is running

function Check-ProcessStatus {
    param(
        [Parameter(Mandatory=$true)]
        [string]$processName
    )
    # Try to get the process
    $process = Get-Process -Name $processName

    if ($process){
        # Process is running, increment running count
        $script:runningCount++
        return $true
    }else{
        # Process is not running, increment not running count
        $script:notRunningCount++
        return $false

    }
}

# Check Windows Explorer
if (Check-ProcessStatus "explorer"){
    Write-Host "Windows Explorer is running"
}else{
    Write-Host "Windows Explorer is not running. This is unusual and may indicate a problem"
}

# Check Task Manager
if (Check-ProcessStatus "Taskmgr"){
    Write-Host "Task Manager is running"
}else{
    Write-Host "Task Manager is not running. This is normal if it hasn't been started."
}

# Check Windows Security
if (Check-ProcessStatus "SecurityHealthSystray"){
    Write-Host "Windows Security is running"
}else{
    Write-Host "Windows Security does not appear to be running. This might be a security concern"
}

# Check Windows Search
if (Check-ProcessStatus "SearchApp"){
    Write-Host "Windows search is running"
}else{
    Write-Host "Windows Search is not running. This might affect system search functionality"
}

# Display summary
Write-Host "`nProcess Check Summary:"
Write-Host "Total process checked: $($runningCount + $notRunningCount)"
Write-Host "Processes found running: $runningCount"
Write-Host "Processes not running: $notRunningCount"

# Set a global variable for the last run time
$global:lastRunTime = Get-Date

# Display run count
Write-Host "`nThis script has been run $global:scriptRunCount times."

# Save updated run count
$global:scriptRunCount | Out-File $countFile
