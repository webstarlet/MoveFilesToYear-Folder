param([Parameter(Mandatory=$true)][string]$baseFolder)


function GetTakenData($image) {
	try {
		return $image.GetPropertyItem(36867).Value
	}	
	catch {
		return $null
	}
}

function exif-date {
param([string]$file)

[Reflection.Assembly]::LoadFile('C:\Windows\Microsoft.NET\Framework64\v4.0.30319\System.Drawing.dll') | Out-Null
$image = New-Object System.Drawing.Bitmap -ArgumentList $file
try {
	$takenData = GetTakenData($image)
	if ($takenData -eq $null) {
		return $null
	}
	$takenValue = [System.Text.Encoding]::Default.GetString($takenData, 0, $takenData.Length - 1)
	$taken = [DateTime]::ParseExact($takenValue, 'yyyy:MM:dd HH:mm:ss', $null)
	return $taken
}
finally {
	$image.Dispose()
}
}


   

    gci "$basefolder\*" | where-object { $_.FullName.Substring($_.FullName.Length-3,3).ToUpper() -in "MP4","MP3","JPG","PEG","3GP"} | % {

	            Write-Host "$_`t->`t" -ForegroundColor Cyan -NoNewLine 
	            try {
                $date = (exif-date $_.FullName)
                } catch {}

	            if ($date -eq $null -or $_.FullName.Substring($_.FullName.Length-3,3).ToUpper() -notin "JPG","PEG") {
                    if((Test-Path "$($baseFolder)\$($_.LastWriteTime.ToString('yyyy'))") -eq $false) {
                       New-Item "$($baseFolder)\$($_.LastWriteTime.ToString('yyyy'))" -ItemType directory 
                       Write-Host "Create Folder $($baseFolder)\$($_.LastWriteTime.ToString('yyyy'))"
                    }
		            Move-Item "$($_.FullName)" "$($baseFolder)/$($_.LastWriteTime.ToString('yyyy'))/$($_.Name)" -Force -Confirm:$false 
                    Write-Host "$($_.LastWriteTime.ToString('yyyy')) (WD)" -ForegroundColor cyan
		            return
	            }
        
        if((Test-Path "$($baseFolder)\$($date.ToString('yyyy'))") -eq $false) {
            New-Item -Path "$($baseFolder)\$($date.ToString('yyyy'))" -ItemType directory 
            
            Write-Host "Create Folder $($baseFolder)\$($date.ToString('yyyy'))"
        }
	    Move-Item "$($_.FullName)" "$($baseFolder)/$($date.ToString('yyyy'))/$($_.Name)" -Force -Confirm:$false 
	    Write-Host "$($date.ToString('yyyy')) (TD)" -ForegroundColor cyan
    }



 gci -Directory "$basefolder\*"  | % {
            $newBaseFolder = $_

            gci  -File "$_\*" | where-object { $_.FullName.Substring($_.FullName.Length-3,3).ToUpper() -in "MP4","MP3","JPG","PEG","3GP"} | % {
                        

	                    Write-Host "$_ ->`t" -ForegroundColor Cyan -NoNewLine 
                        
	                    try {
                             $date = (exif-date $_.FullName)
                             
                        } catch {}

	                    if ($date -eq $null -or $_.FullName.Substring($_.FullName.Length-3,3).ToUpper() -notin "JPG","PEG") {
                            if((Test-Path "$($newBasefolder)\$($_.LastWriteTime.ToString('MM'))") -eq $false) {
                               New-Item "$($newBasefolder)\$($_.LastWriteTime.ToString('MM'))" -ItemType directory
                               Write-Host "Create Folder $($newBasefolder)\$($_.LastWriteTime.ToString('MM'))"
                            }
		                    Move-Item "$($_.FullName)" "$($newBasefolder)/$($_.LastWriteTime.ToString('MM'))/$($_.Name)" -Force -Confirm:$false
                            Write-Host "$($_.LastWriteTime.ToString('MM')) (WD)" -ForegroundColor cyan
		                    return
	                    }
        
                if((Test-Path "$($newBasefolder)\$($date.ToString('MM'))") -eq $false) {
                    New-Item -Path "$($newBasefolder)\$($date.ToString('MM'))" -ItemType directory
            
                    Write-Host "Create Folder $($newBasefolder)\$($date.ToString('MM'))" 
                }
	            Move-Item "$($_.FullName)" "$($newBasefolder)/$($date.ToString('MM'))/$($_.Name)" -Force -Confirm:$false
	            Write-Host "$($date.ToString('MM')) (TD)" -ForegroundColor cyan
            }

    }