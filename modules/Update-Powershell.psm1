# Group 3

<# 
Verb        AliasPrefix Group          Description
----        ----------- -----          -----------
Add         a           Common         Adds a resource to a container, or attaches an item to another item
Clear       cl          Common         Removes all the resources from a container but does not delete the container
Close       cs          Common         Changes the state of a resource to make it inaccessible, unavailable, or unusable
Copy        cp          Common         Copies a resource to another name or to another container
Enter       et          Common         Specifies an action that allows the user to move into a resource
Exit        ex          Common         Sets the current environment or context to the most recently used context
Find        fd          Common         Looks for an object in a container that is unknown, implied, optional, or specified
Format      f           Common         Arranges objects in a specified form or layout
Get         g           Common         Specifies an action that retrieves a resource
Hide        h           Common         Makes a resource undetectable
Join        j           Common         Combines resources into one resource
Lock        lk          Common         Secures a resource
Move        m           Common         Moves a resource from one location to another
New         n           Common         Creates a resource
Open        op          Common         Changes the state of a resource to make it accessible, available, or usable
Optimize    om          Common         Increases the effectiveness of a resource
Push        pu          Common         Adds an item to the top of a stack
Pop         pop         Common         Removes an item from the top of a stack
Redo        re          Common         Resets a resource to the state that was undone
Remove      r           Common         Deletes a resource from a container
Rename      rn          Common         Changes the name of a resource
Reset       rs          Common         Sets a resource back to its original state
Resize      rz          Common         Changes the size of a resource
Search      sr          Common         Creates a reference to a resource in a container
Select      sc          Common         Locates a resource in a container
Set         s           Common         Replaces data on an existing resource or creates a resource that contains some data
Show        sh          Common         Makes a resource visible to the user
Skip        sk          Common         Bypasses one or more resources or points in a sequence
Split       sl          Common         Separates parts of a resource
Step        st          Common         Moves to the next point or resource in a sequence
Switch      sw          Common         Specifies an action that alternates between two resources, such as to change between two locations, responsibil…
Undo        un          Common         Sets a resource to its previous state
Unlock      uk          Common         Releases a resource that was locked
Watch       wc          Common         Continually inspects or monitors a resource for changes
Connect     cc          Communications Creates a link between a source and a destination
Disconnect  dc          Communications Breaks the link between a source and a destination
Read        rd          Communications Acquires information from a source
Receive     rc          Communications Accepts information sent from a source
Send        sd          Communications Delivers information to a destination
Write       wr          Communications Adds information to a target
Backup      ba          Data           Stores data by replicating it
Checkpoint  ch          Data           Creates a snapshot of the current state of the data or of its configuration
Compare     cr          Data           Evaluates the data from one resource against the data from another resource
Compress    cm          Data           Compacts the data of a resource
Convert     cv          Data           Changes the data from one representation to another when the cmdlet supports bidirectional conversion or when t…
ConvertFrom cf          Data           Converts one primary type of input (the cmdlet noun indicates the input) to one or more supported output types
ConvertTo   ct          Data           Converts from one or more types of input to a primary output type (the cmdlet noun indicates the output type)
Dismount    dm          Data           Detaches a named entity from a location
Edit        ed          Data           Modifies existing data by adding or removing content
Expand      en          Data           Restores the data of a resource that has been compressed to its original state
Export      ep          Data           Encapsulates the primary input into a persistent data store, such as a file, or into an interchange format
Group       gp          Data           Arranges or associates one or more resources
Import      ip          Data           Creates a resource from data that is stored in a persistent data store (such as a file) or in an interchange fo…
Initialize  in          Data           Prepares a resource for use, and sets it to a default state
Limit       l           Data           Applies constraints to a resource
Merge       mg          Data           Creates a single resource from multiple resources
Mount       mt          Data           Attaches a named entity to a location
Out         o           Data           Sends data out of the environment
Publish     pb          Data           Makes a resource available to others
Restore     rr          Data           Sets a resource to a predefined state, such as a state set by Checkpoint
Save        sv          Data           Preserves data to avoid loss
Sync        sy          Data           Assures that two or more resources are in the same state
Unpublish   ub          Data           Makes a resource unavailable to others
Update      ud          Data           Brings a resource up-to-date to maintain its state, accuracy, conformance, or compliance
Debug       db          Diagnostic     Examines a resource to diagnose operational problems
Measure     ms          Diagnostic     Identifies resources that are consumed by a specified operation, or retrieves statistics about a resource
Ping        pi          Diagnostic     Use the Test verb
Repair      rp          Diagnostic     Restores a resource to a usable condition
Resolve     rv          Diagnostic     Maps a shorthand representation of a resource to a more complete representation
Test        t           Diagnostic     Verifies the operation or consistency of a resource
Trace       tr          Diagnostic     Tracks the activities of a resource
Approve     ap          Lifecycle      Confirms or agrees to the status of a resource or process
Assert      as          Lifecycle      Affirms the state of a resource
Build       bd          Lifecycle      Creates an artifact (usually a binary or document) out of some set of input files (usually source code or decla…
Complete    cmp         Lifecycle      Concludes an operation
Confirm     cn          Lifecycle      Acknowledges, verifies, or validates the state of a resource or process
Deny        dn          Lifecycle      Refuses, objects, blocks, or opposes the state of a resource or process
Deploy      dp          Lifecycle      Sends an application, website, or solution to a remote target[s] in such a way that a consumer of that solution…
Disable     d           Lifecycle      Configures a resource to an unavailable or inactive state
Enable      e           Lifecycle      Configures a resource to an available or active state
Install     is          Lifecycle      Places a resource in a location, and optionally initializes it
Invoke      i           Lifecycle      Performs an action, such as running a command or a method
Register    rg          Lifecycle      Creates an entry for a resource in a repository such as a database
Request     rq          Lifecycle      Asks for a resource or asks for permissions
Restart     rt          Lifecycle      Stops an operation and then starts it again
Resume      ru          Lifecycle      Starts an operation that has been suspended
Start       sa          Lifecycle      Initiates an operation
Stop        sp          Lifecycle      Discontinues an activity
Submit      sb          Lifecycle      Presents a resource for approval
Suspend     ss          Lifecycle      Pauses an activity
Uninstall   us          Lifecycle      Removes a resource from an indicated location
Unregister  ur          Lifecycle      Removes the entry for a resource from a repository
Wait        w           Lifecycle      Pauses an operation until a specified event occurs
Use         u           Other          Uses or includes a resource to do something
Block       bl          Security       Restricts access to a resource
Grant       gr          Security       Allows access to a resource
Protect     pt          Security       Safeguards a resource from attack or loss
Revoke      rk          Security       Specifies an action that does not allow access to a resource
Unblock     ul          Security       Removes restrictions to a resource
Unprotect   up          Security       Removes safeguards from a resource that were added to prevent it from attack or loss #>

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
        [Switch] $Clean #TODO: Will clean up after install 
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