using namespace System

$Drive = (Get-Volume -FileSystemLabel 'Drive ( Remote )')
$RemoteDriveLetter = $Drive.DriveLetter
$RemoteDrive = "$RemoteDriveLetter" + ':'
$RemoteDriveRootFolders = @{
    'CACH' = "$RemoteDrive\.cache"
    'CONF' = "$RemoteDrive\.conf"
    'LIBS' = "$RemoteDrive\.libs"
    'SBIN' = "$RemoteDrive\sbin"
    'SRV'  = "$RemoteDrive\srv"
    'PROJ' = "$RemoteDrive\proj"
}
$Path = ($RemoteDriveRootFolders['SBIN'] + ';') `
    + ([String](Get-ChildItem $RemoteDriveRootFolders['SBIN'] | ForEach-Object -Process { 
            if ( $_ -match 'git' ) { return '' }
            if ( $_ -match 'starship' ) { return '' }
            else { return $_.FullName + ';' } 
        }) -replace ' ', '') `
    + ($RemoteDriveRootFolders['SBIN'] + '\git\bin;') `
    + ($RemoteDriveRootFolders['SRV'] + '\vscode\bin;')


$ModifiedEnvironment = $False

if ( [Environment]::GetEnvironmentVariable('RemoteDriveLetter', [EnvironmentVariableTarget]::User) -notmatch $RemoteDriveLetter ) 
{ [Environment]::SetEnvironmentVariable('RemoteDriveLetter', $RemoteDriveLetter, [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetENvironmentVariable('RemoteDrive') -ne $RemoteDrive)
{ [Environment]::SetEnvironmentVariable('RemoteDrive', $RemoteDrive, [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $true }

if ( [Environment]::GetEnvironmentVariable('RemoteDriveCache', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CACH']))
{ [Environment]::SetEnvironmentVariable('RemoteDriveCache', $RemoteDriveRootFolders['CACH'], [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('RemoteDriveSystemBin', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['SBIN']))
{ [Environment]::SetEnvironmentVariable('RemoteDriveSystemBin', $RemoteDriveRootFolders['SBIN'], [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($Path) ) 
{ [Environment]::SetEnvironmentVariable('Path', ( $Path + [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine) ), [EnvironmentVariableTarget]::User ); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('PSModulePath', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CONF'] + '\powershell\modules'))
{ [Environment]::SetEnvironmentVariable('PSModulePath', $RemoteDriveRootFolders['CONF'] + '\powershell\modules', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_PACKAGES', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['LIBS'] + '\nuget')) 
{ [Environment]::SetEnvironmentVariable('NUGET_PACKAGES', $RemoteDriveRootFolders['LIBS'] + '\nuget', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_HTTP_CACHE_PATH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CACH'] + '\nuget\http') )
{ [Environment]::SetEnvironmentVariable('NUGET_HTTP_CACHE_PATH', $RemoteDriveRootFolders['CACH'] + '\nuget\http', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_PLUGINS_CACHE_PATH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CACH'] + '\nuget\plugin') )
{ [Environment]::SetEnvironmentVariable('NUGET_PLUGINS_CACHE_PATH', $RemoteDriveRootFolders['CACH'] + '\nuget\plugin', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_SCRATCH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CACH'] + '\nuget\temp') )
{ [Environment]::SetEnvironmentVariable('NUGET_SCRATCH', $RemoteDriveRootFolders['CACH'] + '\nuget\temp', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('STARSHIP_CONFIG', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($RemoteDriveRootFolders['CONF'] + '\starship.toml') )
{ [Environment]::SetEnvironmentVariable('STARSHIP_CONFIG', $RemoteDriveRootFolders['CONF'] + '\starship.toml', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('STARSHIP_CACHE'), [EnvironmentVariableTarget]::User -notmatch [regex]::escape($RemoteDriveRootFolders['CACH'] + '\starship') )
{ [Environment]::SetEnvironmentVariable('STARSHIP_CACHE', $RemoteDriveRootFolders['CACH'] + '\starship', [EnvironmentVariableTarget]::User); $ModifiedEnvironment = $True }

if ($ModifiedEnvironment)
{ [Environment]::GetEnvironmentVariables().GetEnumerator() | ForEach-Object -Process { Set-Item -Path ('Env:' + $_.Name) -Value $_.Value } }

function Invoke-Starship-TransientFunction {
    &starship module character
}

Invoke-Expression (&starship init powershell)
Enable-TransientPrompt

# Write-Host $RemoteDriveLetter
# Write-Host $RemoteDrive
# Write-Host $Path
Get-ChildItem ($RemoteDriveRootFolders['CONF'] + '\powershell\scripts') | ForEach-Object -Process { & $_ }