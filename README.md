
# Annoying Context Menu For 7Zip

- Added menu option to 'compress' directories with the 0 compress storage option.
- I was sick of changing the GUI back and forth.

## Synopsis

Compress directories with 7z using the "store" method (no compression). Optionally, add or remove this script from the Windows context menu.

## Description

This script allows you to compress directories using the 7z "store" method, which means no compression is applied. You can also use this script to add or remove the context menu entry for easier access.

## Parameters

### `path`

The path of the directory to compress. If not provided, the script will prompt for selection.

### `AddContextMenu`

Adds the context menu entry for this script.

### `RemoveContextMenu`

Removes the context menu entry for this script.

### `help`

Displays this help message.

## Examples

### Add Context Menu

```powershell
.zStore.ps1 -AddContextMenu
```

Adds the context menu entry for compressing with 7z (no compression).

### Remove Context Menu

```powershell
.zStore.ps1 -RemoveContextMenu
```

Removes the context menu entry for compressing with 7z (no compression).

### Compress Directory

```powershell
.zStore.ps1 -path "C:\Path\To\Directory"
```

Compresses the specified directory with 7z using the "store" method.

## Notes

Ensure that the path to 7z.exe is correct and adjust it if necessary.
