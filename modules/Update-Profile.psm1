function Compare-Profile {
    process { 
        try {
            $Response = Invoke-WebRequest -Uri https://raw.githubusercontent.com/hoodds0/dotfiles/refs/heads/readme/README.md
            $Status = $Response.StatusCode
        }
        catch {
            $Status = 400
        }
        if ($Status -ne 200) { Write-Error -Message 'Could not connect to Github Servers' -Category ConnectionError; exit 1 }
        $__ = $Response.Content -match '## Portable \*\(winable\)\* - .*'
        $__ = $Matches[0] -match '- .*'

        return [System.Environment]::GetEnvironmentVariable('RemoteDriveVersion', [System.EnvironmentVariableTarget]::User) -ne $Matches[0]
    }
}
function Clear-DownloadedProfile {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Switch] $Force
    ) 
    begin { 
        $Cache = [System.EnvironmentVariableTarget]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User) 
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' } 
        if (-not (Test-Path -Path "$Cache\downloads\winable")) { return }
        if (-not $PSCmdlet.ShouldProcess('Remove', 'Downloaded winable Profile')) { exit 1 }
    }
    process {
        "$Cache\downloads\winable" | Get-ChildItem | ForEach-Object -Process { Remove-Item -Force -Recurse -Path $_ }
    }
}

function Get-Profile {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Switch] $Force
    )
    begin { 
        $Cache = [System.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User)
        $NeedsCleared = (Test-Path -Path "$Cache\downloads\winable")
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
        if (-not $PSCmdlet.ShouldProcess('Download', 'Winable Profile')) { exit 1 }
    }
    process {
        if ($NeedsCleared) { Clear-DownloadedProfile -Confirm:($Force -or $ConfirmPreference -eq 'None') }
        Invoke-Expression -Command "git clone https://github.com/hoodds0/dotfiles.git -b winable $Cache\downloads\winable"
    }
}
function Install-Profile {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param( [Switch] $Force)
    begin { 
        $Root = [System.Environment]::GetEnvironmentVariable('RemoteDrive', [System.EnvironmentVariableTarget]::User)
        if ($Null -eq $Root) { exit 1 } 
        $Cache = [System.Environment]::GetEnvironmentVariable('RemoteDriveCache', [System.EnvironmentVariableTarget]::User) + '\download\winable'
        if ($Null -eq $Cache) { $Cache = '.\TEMP' }
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
        if ( -not $PSCmdlet.ShouldProcess('Install', 'Downloaded Winable Profile')) { exit 1 }
        $Confirm = -not $Force -or $ConfirmPreference -ne 'None'
    }
    process {
        Copy-Item -Confirm:$Confirm -Force -Path "$Cache\profile.ps1" -Destination "$Root\.conf\powershell"
        Copy-Item -Confirm:$Confirm -Force -Recurse -Path "$Cache\modules" -Destination "$Root\.conf\powershell"
        Copy-Item -Confirm:$Confirm -Force -Force -Recurse -Path "$Cache\scripts" -Destination "$Root\.conf\powershell"
    }
}
function Update-Profile {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Switch] $Force,
        [Switch] $Cleanup
    )
    begin { 
        if (-not (Compare-Profile)) { exit 1 }
        if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) { $ConfirmPreference = 'None' }
        if ( -not $PSCmdlet.ShouldProcess('Update', 'Winable Dotfiles') ) { exit 1 }
        $Confirm = -not $Force -or $ConfirmPreference -ne 'None'
    }
    process {
        Get-Profile -Confirm:$Confirm
        Install-Profile -Confirm:$Confirm
    }
    end { if ($Cleanup) { Clear-DownloadedProfile } }
}