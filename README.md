# Annoying Context Menu For 7Zip
- added menu option to 'compress' directories with the 0 compress storage option.

- I was sick of changing the gui back and fourth



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

