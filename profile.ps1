#TODO: Update and/or Change Environment Variables
#TODO: Edit and Change Modules path to .\modules
#///TODO: Read and automaticly run ps1 files in .\scripts

<# File System Layout ╠ ║ ╔ ╚
.\
╠ .cache | cache files
╠ .conf  | config files
╠ .libs  | library files
╠ sbin   | program lanagues
╠ srv    | programs
╚ proj   | projects
#>

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


Write-Host $RemoteDriveLetter
Write-Host $RemoteDrive

Get-ChildItem .\scripts | ForEach-Object -Process { & $_ }
