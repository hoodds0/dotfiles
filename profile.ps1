using namespace System

$local:Drive = (Get-Volume -FileSystemLabel 'Drive ( Remote )')
$RemoteDriveLetter = $local:Drive.DriveLetter
$RemoteDrive = "$RemoteDriveLetter" + ':'
$local:RemoteDriveRootFolders = @{
    'CACH' = "$RemoteDrive\.cache"
    'CONF' = "$RemoteDrive\.conf"
    'LIBS' = "$RemoteDrive\.libs"
    'SBIN' = "$RemoteDrive\sbin"
    'SRV'  = "$RemoteDrive\srv"
    'PROJ' = "$RemoteDrive\proj"
}
$local:Path = ($local:RemoteDriveRootFolders['SBIN'] + ';') `
    + ([String](Get-ChildItem $local:RemoteDriveRootFolders['SBIN'] | ForEach-Object -Process { 
            if ( $_ -match 'git' ) { return '' }
            if ( $_ -match 'starship' ) { return '' }
            else { return $_.FullName + ';' } 
        }) -replace ' ', '') `
    + ($local:RemoteDriveRootFolders['SBIN'] + '\git\bin;') `
    + ($local:RemoteDriveRootFolders['SRV'] + '\vscode\bin;')


$local:ModifiedEnvironment = $False

if ( [Environment]::GetEnvironmentVariable('RemoteDriveLetter', [EnvironmentVariableTarget]::User) -notmatch $RemoteDriveLetter ) 
{ [Environment]::SetEnvironmentVariable('RemoteDriveLetter', $RemoteDriveLetter, [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('RemoteDriveCache', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CACH']))
{ [Environment]::SetEnvironmentVariable('RemoteDriveCache', $local:RemoteDriveRootFolders['CACH'], [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('RemoteDriveSystemBin', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['SBIN']))
{ [Environment]::SetEnvironmentVariable('RemoteDriveSystemBin', $local:RemoteDriveRootFolders['SBIN'], [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:Path) ) 
{ [Environment]::SetEnvironmentVariable('Path', ( $local:Path + [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine) ), [EnvironmentVariableTarget]::User ); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('PSModulePath', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CONF'] + '\powershell\modules'))
{ [Environment]::SetEnvironmentVariable('PSModulePath', $local:RemoteDriveRootFolders['CONF'] + '\powershell\modules', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_PACKAGES', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['LIBS'] + '\nuget')) 
{ [Environment]::SetEnvironmentVariable('NUGET_PACKAGES', $local:RemoteDriveRootFolders['LIBS'] + '\nuget', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_HTTP_CACHE_PATH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CACH'] + '\nuget\http') )
{ [Environment]::SetEnvironmentVariable('NUGET_HTTP_CACHE_PATH', $local:RemoteDriveRootFolders['CACH'] + '\nuget\http', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_PLUGINS_CACHE_PATH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CACH'] + '\nuget\plugin') )
{ [Environment]::SetEnvironmentVariable('NUGET_PLUGINS_CACHE_PATH', $local:RemoteDriveRootFolders['CACH'] + '\nuget\plugin', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('NUGET_SCRATCH', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CACH'] + '\nuget\temp') )
{ [Environment]::SetEnvironmentVariable('NUGET_SCRATCH', $local:RemoteDriveRootFolders['CACH'] + '\nuget\temp', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('STARSHIP_CONFIG', [EnvironmentVariableTarget]::User) -notmatch [regex]::escape($local:RemoteDriveRootFolders['CONF'] + '\starship.toml') )
{ [Environment]::SetEnvironmentVariable('STARSHIP_CONFIG', $local:RemoteDriveRootFolders['CONF'] + '\starship.toml', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ( [Environment]::GetEnvironmentVariable('STARSHIP_CACHE'), [EnvironmentVariableTarget]::User -notmatch [regex]::escape($local:RemoteDriveRootFolders['CACH'] + '\starship') )
{ [Environment]::SetEnvironmentVariable('STARSHIP_CACHE', $local:RemoteDriveRootFolders['CACH'] + '\starship', [EnvironmentVariableTarget]::User); $local:ModifiedEnvironment = $True }

if ($local:ModifiedEnvironment)
{ [Environment]::GetEnvironmentVariables().GetEnumerator() | ForEach-Object -Process { Set-Item -Path ('Env:' + $_.Name) -Value $_.Value } }

function Invoke-Starship-TransientFunction {
    &starship module character
}

Invoke-Expression (&starship init powershell)
Enable-TransientPrompt

# Write-Host $RemoteDriveLetter
# Write-Host $RemoteDrive
# Write-Host $local:Path
Get-ChildItem ($local:RemoteDriveRootFolders['CONF'] + '\powershell\scripts') | ForEach-Object -Process { & $_ }