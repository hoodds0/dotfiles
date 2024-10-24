#TODO: Automaticly install and setup the Winable branch. AKA Portable for Windows
<# File System Layout ╠ ║ ╔ ╚
.\
╠ .cache | cache files
╠ .conf  | config files
╠ .libs  | library files
╠ sbin   | program lanagues
╠ srv    | programs
╚ proj   | projects
#>

if ( -not (Test-Path -Path '.\TEMP') ) { New-Item -Path '.\' -Name 'TEMP' -ItemType Directory }
Invoke-Expression 'git clone https://github.com/hoodds0/dotfiles.git -b winable .\TEMP'


# Sets up Cache Folder
if ( -not (Test-Path -Path '.\.cache') ) { New-Item -Path '.\' -Name '.cache' -ItemType Directory }
if ( -not (Test-Path -Path '.\.cache\downloads')) { New-Item -Path '.\.cache' -Name 'downloads' -ItemType Directory }
if ( -not (Test-Path -Path '.\.cache\nuget')) { New-Item -Path '.\.cache' -Name 'nuget' -ItemType Directory }
if ( -not (Test-Path -Path '.\.cache\nuget\http')) { New-Item -Path '.\.cache\nuget' -Name 'http' -ItemType Directory }
if ( -not (Test-Path -Path '.\.cache\nuget\temp')) { New-Item -Path '.\.cache\nuget' -Name 'temp' -ItemType Directory }

# Sets up Config Folder
if ( -not (Test-Path -Path '.\.config') ) { New-Item -Path '.\' -Name '.config' -ItemType Directory }
if ( -not (Test-Path -Path '.\.config\powershell')) { New-Item -Path '.\.config' -Name 'powershell' -ItemType Directory }
if ( -not (Test-Path -Path '.\.config\powershell\modules')) { New-Item -Path '.\.config\powershell' -Name 'modules' -ItemType Directory }
if ( -not (Test-Path -Path '.\.config\powershell\scripts')) { New-Item -Path '.\.config\powershell' -Name 'scripts' -ItemType Directory }
if ( -not (Test-Path -Path '.\config\vscode')) { New-Item -Path '.\.config' -Name 'vscode' -ItemType Directory }

# Sets up Library Folder
if ( -not (Test-Path -Path '.\.libs') ) { New-Item -Path '.\' -Name '.libs' -ItemType Directory }
if ( -not (Test-Path -Path '.\.libs\fonts')) { New-Item -Path '.\.libs' -Name 'fonts' -ItemType Directory }
if ( -not (Test-Path -Path '.\.libs\nuget')) { New-Item -Path '.\.libs' -Name 'nuget' -ItemType Directory }

# Sets up Binary Folder
if ( -not (Test-Path -Path '.\sbin') ) { New-Item -Path '.\' -Name 'sbin' -ItemType Directory }

# Sets up Program Folder
if ( -not (Test-Path -Path '.\srv') ) { New-Item -Path '.\' -Name 'srv' -ItemType Directory }

# Sets up Project Folder
if ( -not (Test-Path -Path '.\proj') ) { New-Item -Path '.\' -Name 'proj' -ItemType Directory }


if (Test-Path -Path '.\TEMP') { Remove-Item -Path '.\TEMP' -Force -Recurse }