function Request-LatestPowerShell {
    process {
        try {
            $Response = Invoke-WebRequest -Uri 'https://api.github.com/repos/PowerShell/PowerShell/releases/latest'
            $Status = $Response.StatusCode
        }
        catch {
            $Status = $_.Exception.Response.StatusCode.value__
        }
    }
    end { 
        if ($Status -ne 200) { 
            Write-Error -Message 'Could not get Latest Powershell Version from Github.' -Category ConnectionError
            Exit 1
        }
        else { $Response.Content | ConvertFrom-Json }
    }
}
function Compare-PowerShell {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $True)]
        [PSCustomObject] $PowershellVersion
    )
    begin {
        if ($Null -eq $PowershellVersion) { $PowershellVersion = (Request-LatestPowerShell).tag_name }
    }
    end { $PowershellVersion -replace 'v' -gt $PSVersionTable.PSVersion }
}
function Get-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Switch] $Force,
        [PSCustomOBject] $Version
    )
    
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    
    process {
        if ( -not $PSCmdlet.ShouldProcess('PowerShell', 'Download')) { exit 1 }
        $CachePath = [System.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User)
        try { $Response = Invoke-WebRequest -Uri $Version.browser_download_url -OutFile ("$CachePath\downloads\" + $Version.name) }
        catch { $Status = $Response.StatusCode }
    }
    end {
        if ($Status -ne 200) { 
            Write-Error -Message 'Could not get download from Github.' -Category ConnectionError
            Exit 1
        }
    }
}

function Expand-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Switch] $Force
    )
    
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    
    process {
        $CachePath = [System.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User)
        $ZipArray = "$CachePath\downloads" | Get-ChildItem | ForEach-Object -Process { if ($_.GetType() -ne [System.IO.FileInfo] ) { return } if ($_.name -notmatch 'PowerShell-.*-win-x64\.zip') { return } $_ }
        if ($ZipArray.Length -eq 0) { 
            Write-Error -Message "No Zip file of PowerShell-*-win-x64.zip exists in $CachePath\downloads" -Category ResourceUnavailable 
            exit 1 
        }
        $ZipFile = $ZipArray | ForEach-Object -Begin { [System.Management.Automation.SemanticVersion] $Version = '0.0.0'; [System.IO.FileInfo] $Zip = $Null } -Process { $Void = $_.name -match '\d*\.\d*\.\d*'; if ([System.Management.Automation.SemanticVersion]$Matches[0] -gt $PSVersionTable.PSVersion -and [System.Management.Automation.SemanticVersion]$Matches[0] -gt $Version ) { $Version = $Matches[0]; $Zip = $_ } } -End { $Zip }
        if (-not $PSCmdlet.ShouldProcess('Expand', $ZipFile.Name)) { exit 1 }
        Expand-Archive -Path $ZipFile.Fullname -DestinationPath ("$CachePath\downloads\" + ($ZipFile.name -replace '\.zip')) -Confirm:($ConfirmPreference -ne 'None')
    }
}
function Backup-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High' )]
    param (
        [Switch] $Force
    )
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    process {
        $Folder = [System.Environment]::GetEnvironmentVariable('RemoteDriveSystemBin', [System.EnvironmentVariableTarget]::User)
        
        if (-not (Test-Path -Path "$Folder\.bkp")) { New-Item -Path $Folder -Name '.bkp' -ItemType Directory }
        $BackupFolder = "$Folder\.bkp"
        if (-not $PSCmdlet.ShouldProcess('Backup', 'Current PowerShell')) { exit 1 }
        Copy-Item -Path "$Folder\powershell" -Destination "$BackupFolder" -Recurse -Confirm:($ConfirmPreference -ne 'None')
    }
}

function Install-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Switch] $Force
    )
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    process {
        if (-not $PSCmdlet.ShouldProcess('Install', 'Downloaded PowerShell')) { exit 1 }
        $SystemBin = [System.Environment]::GetEnvironmentVariable('RemoteDriveSystemBin', [System.EnvironmentVariableTarget]::User)
        $Cache = [System.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User)
        $Folder = "$Cache\downloads" | Get-ChildItem | ForEach-Object -Begin { [System.Management.Automation.SemanticVersion] $Version = '0.0.0'; [System.IO.DirectoryInfo] $Folder = [System.IO.DirectoryInfo]::New('C:\') } -Process { if ($_.GetType() -ne [System.IO.DirectoryInfo]) { return } if ($_.name -notmatch 'PowerShell-.*-win-x64') { return } $Void = $_.name -match '\d*\.\d*\.\d*'; if ([System.Management.Automation.SemanticVersion]$Matches[0] -gt $PSVersionTable.PSVersion -and [System.Management.Automation.SemanticVersion]$Matches[0] -gt $Version ) { $Version = $Matches[0]; $Folder = $_ } } -End { $Folder }
        Move-Item -Path $Folder.FullName -Destination "$SystemBin\powershell" -Confirm:($ConfirmPreference -ne 'None')
    }
}
function Clear-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param 
    (
        [Switch] $Force
    )
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    process {
        $Cache = [Systen.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User)
        $Files = "$Cache\downloads" | Get-ChildItem | ForEach-Object -Process { if ($_.name -notmatch 'PowerShell-.*-win-x64') { return } $_ }
        if (-not $PSCmdlet.ShouldProcess('Clean up', 'PowerShell Folder & Files')) { exit 1 }
        $Files | ForEach-Object -Process { Remove-Item $_ -Confirm:($ConfirmPreference -ne 'None') }
    }

}
function Update-PowerShell {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param 
    (
        [Switch] $Force,
        [Switch] $Clean
    )
    begin {
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
    }
    process {
        if (-not $PSCmdlet.ShouldProcess('PowerShell', 'Update') ) { exit 1 }
        $LatestPowershell = Request-LatestPowerShell
        if ( -not (Compare-PowerShell -PowershellVersion $LatestPowershell.tag_name) ) { exit 0 }
        Backup-PowerShell -Force ($Force -or $ConfirmPreference -eq 'None')
        $Version = ($LatestPowershell.assets | ForEach-Object -Process { if ($_.name -match 'PowerShell-.*-win-x64\.zip') { $_ } })
        Get-PowerShell -Force ($Force -or $ConfirmPreference -eq 'None') -Version $Version
        Expand-PowerShell -Force ($Force -or $ConfirmPreference -eq 'None')
        Install-PowerShell -Force ($Force -or $ConfirmPreference -eq 'None')
        if ($Clean) { Clear-PowerShell }
    }
}