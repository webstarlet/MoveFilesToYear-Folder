# Author and Version
| Author | Nikolaus Schillinger © 2016-2018 |
|---|---|
| Type | PowerShell Script |
| Name & Version | MoveFilesToYear-Folder v2 |

# Information
Moves and sorts your Photos (JPG) based on the EXIF-Attribute "Taken" to folders - named by year.
Fallback for Photos and base for Movies: "last write time" 

Folders will be created within the baseFolder.

# Hot to use

### Parameters:
`PS .\move-files-to-year-folders.ps1 -baseFolder [FolderWithFilesToMove as String | Mandatory]`

### Example:
`PS .\move-files-to-year-folders.ps1 %UserProfile%\Pictures`

### Sort Dropox Camera Upload:
`C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe E:\Dropbox\scripts\file-year-mover\move-files-to-year-folders.ps1 `




