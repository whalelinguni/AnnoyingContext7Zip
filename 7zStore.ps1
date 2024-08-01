<#
.SYNOPSIS
    Compress directories with 7z using the "store" method (no compression).
    Optionally, add or remove this script from the Windows context menu.

.DESCRIPTION
    This script allows you to compress directories using the 7z "store" method, which means no compression is applied.
    You can also use this script to add or remove the context menu entry for easier access.

.PARAMETER path
    The path of the directory to compress. If not provided, the script will prompt for selection.

.PARAMETER AddContextMenu
    Adds the context menu entry for this script.

.PARAMETER RemoveContextMenu
    Removes the context menu entry for this script.

.PARAMETER help
    Displays this help message.

.EXAMPLE
    .\7zStore.ps1 -AddContextMenu
    Adds the context menu entry for compressing with 7z (no compression).

.EXAMPLE
    .\7zStore.ps1 -RemoveContextMenu
    Removes the context menu entry for compressing with 7z (no compression).

.EXAMPLE
    .\7zStore.ps1 -path "C:\Path\To\Directory"
    Compresses the specified directory with 7z using the "store" method.

.NOTES
    Ensure that the path to 7z.exe is correct and adjust it if necessary.
#>

param (
    [string]$path,
    [switch]$AddContextMenu,
    [switch]$RemoveContextMenu,
    [switch]$help
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Clear-Host

function Show-Help {
    @"
SYNOPSIS
    Compress directories with 7z using the "store" method (no compression).
    Optionally, add or remove this script from the Windows context menu.

DESCRIPTION
    This script allows you to compress directories using the 7z "store" method, which means no compression is applied.
    You can also use this script to add or remove the context menu entry for easier access.

PARAMETERS
    -path
        The path of the directory to compress. If not provided, the script will prompt for selection.

    -AddContextMenu
        Adds the context menu entry for this script.

    -RemoveContextMenu
        Removes the context menu entry for this script.

    -help
        Displays this help message.

EXAMPLES
    .\7zStore.ps1 -AddContextMenu
        Adds the context menu entry for compressing with 7z (no compression).

    .\7zStore.ps1 -RemoveContextMenu
        Removes the context menu entry for compressing with 7z (no compression).

    .\7zStore.ps1 -path "C:\Path\To\Directory"
        Compresses the specified directory with 7z using the "store" method.

NOTES
    Ensure that the path to 7z.exe is correct and adjust it if necessary.
"@
    exit 0
}

if ($help) {
    Show-Help
}

$scriptPath = Join-Path -Path $PWD.Path -ChildPath "7zStore.ps1"

function Add-ContextMenuEntry {
    Write-Host "Adding context menu entry..." -ForegroundColor Yellow
    try {
        $keyPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\7zStore"
        Write-Host "Creating registry key at $keyPath" -ForegroundColor Cyan
        if (-not (Test-Path $keyPath)) {
            New-Item -Path $keyPath -Force | Out-Null
        }
        Write-Host "Setting default property for $keyPath" -ForegroundColor Cyan
        Set-ItemProperty -Path $keyPath -Name "(Default)" -Value "Compress with 7z (No Compression)"

        $cmdPath = "$keyPath\command"
        Write-Host "Creating registry key at $cmdPath" -ForegroundColor Cyan
        if (-not (Test-Path $cmdPath)) {
            New-Item -Path $cmdPath -Force | Out-Null
        }
        Write-Host "Setting command property for $cmdPath" -ForegroundColor Cyan
        Set-ItemProperty -Path $cmdPath -Name "(Default)" -Value "powershell -NoProfile -WindowStyle Hidden -File `"$scriptPath`" -path `"%V`""

        Write-Host "Context menu entry added successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to add context menu entry: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Remove-ContextMenuEntry {
    Write-Host "Removing context menu entry..." -ForegroundColor Yellow
    try {
        $keyPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\7zStore"
        if (Test-Path -Path $keyPath) {
            Write-Host "Removing registry key at $keyPath" -ForegroundColor Cyan
            Remove-Item -Path $keyPath -Recurse -Force -ErrorAction Stop
            Write-Host "Removed directory context menu entry: 7zStore" -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to remove context menu entry: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-InputDialog {
    param (
        [string]$text,
        [string]$defaultValue
    )

    $form = New-Object Windows.Forms.Form
    $form.Text = "Enter Archive Name"
    $form.StartPosition = "CenterScreen"
    $form.Width = 400
    $form.Height = 150

    $label = New-Object Windows.Forms.Label
    $label.Text = $text
    $label.Left = 10
    $label.Top = 20
    $label.Width = 380
    $form.Controls.Add($label)

    $textBox = New-Object Windows.Forms.TextBox
    $textBox.Text = $defaultValue
    $textBox.Left = 10
    $textBox.Top = 50
    $textBox.Width = 360
    $form.Controls.Add($textBox)

    $okButton = New-Object Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Left = 300
    $okButton.Top = 80
    $okButton.Width = 75
    $okButton.DialogResult = [Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $form.Topmost = $true

    $result = $form.ShowDialog()
    if ($result -eq [Windows.Forms.DialogResult]::OK) {
        return $textBox.Text
    } else {
        return $null
    }
}

if ($AddContextMenu) {
    Add-ContextMenuEntry
    exit 0
}

if ($RemoveContextMenu) {
    Remove-ContextMenuEntry
    exit 0
}

if ($path) {
    $defaultArchiveName = [System.IO.Path]::GetFileNameWithoutExtension($path) + "[store]"
    $archiveName = Show-InputDialog "Enter Archive Name (or press Enter for default)" $defaultArchiveName
    if ([string]::IsNullOrWhiteSpace($archiveName)) {
        $archiveName = $defaultArchiveName
    }

    $sevenZip = "C:\Program Files\7-Zip\7z.exe"
    $archiveName = [System.IO.Path]::Combine($PWD.Path, "$archiveName.7z")

    Write-Host "Compressing $path to $archiveName using 7z (no compression)..." -ForegroundColor Yellow
    $command = "& `"$sevenZip`" a -mx=0 `"$archiveName`" `"$path`""
    Invoke-Expression $command

    Write-Host "Compression completed. Archive created at $archiveName" -ForegroundColor Green
	Write-Host "Good you!! Rocket ship! (_)_)====D~~~"
    Start-Sleep -Seconds 2  # Brief pause before closing
    exit 0
} else {
    Write-Host "No directory selected. Exiting." -ForegroundColor Red
    exit 0
}
