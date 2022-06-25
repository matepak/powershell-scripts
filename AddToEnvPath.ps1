<#
.Synopsis
   Adds persistant Path to the $Env:Path
.DESCRIPTION

.EXAMPLE
   PS>  Add-EnvPath -Path C:\PathToDir\
#>
function Add-EnvPath {
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true)]
        [string]$Path
    )
    Begin {
        $IsInEnvPath = [Environment]::GetEnvironmentVariables(
            [System.EnvironmentVariableTarget]::Machine
        )::Path.Contains($Path)
    }
    Process {
        if ( -not $IsInEnvPath ) {
            try {
                [Environment]::SetEnvironmentVariable(
                    "PATH", $Env:PATH  + $Path + ';', [EnvironmentVariableTarget]::Machine)
                Write-Host "Path $Path added to `$Env:Path"
            }
            catch [System.Security.SecurityException] {
                Write-Host -ForegroundColor Green `
                    "Running Add-EnvPath requires elevated command shell."
                Write-Host -ForegroundColor Red $_
            }
        } 
        else {
            Write-Host "$Path is already in `$Env:Path"
        }
    }
}
