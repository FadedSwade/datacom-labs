# This script searches all subfolders for .md files and looks
# for a matching .pdf file. If no .pdf is found, it will be
# created using pandoc. If a .pdf is found, the dates are 
# checked. If the .md file was modified later than the
# .pdf, the .pdf will be regenerated.
#
# pandoc.exe must be in the PATH Windows environment variable.
#
$start_location = Get-Location
Write-Host "Searching $(Get-Location) and subfolders for for .md files that need PDFs"
$mdfiles = gci -rec -filter *.md
foreach ($md in $mdfiles)
{
    $pdfpath = "$($md.DirectoryName)\$($md.BaseName).pdf"
    if (-Not (Test-Path $pdfpath))
    {
        Write-Host "Creating $($md.BaseName).pdf"
        Set-Location $md.DirectoryName
        pandoc.exe "$($md.FullName)" -t latex -o $pdfpath
    } else {
        $pdf = gci $pdfpath
        if ($pdf.LastWriteTime -lt $md.LastWriteTime)
        {
            Write-Host "Updating $($md.BaseName).pdf"
            Set-Location $md.DirectoryName
            pandoc.exe "$($md.FullName)" -t latex -o $pdfpath
        }
    }
}
Set-Location $start_location
Write-Host "Done."