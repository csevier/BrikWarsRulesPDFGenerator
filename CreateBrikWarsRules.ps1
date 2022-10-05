Write-Output "Installing MergPdf. Hit yes."
Install-Module -Name MergePdf
$brikWarsPath = $env:USERPROFILE + '\Downloads\BrikWars\'
New-Item -Path $brikWarsPath -ItemType Directory

$toPdf = 'C:\Program Files\wkhtmltopdf\bin'

if (Test-Path $toPdf)
{
    Write-Output "wkhtmltopdf found."
    $regexAddPath = [regex]::Escape($toPdf)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $toPdf) -join ';'
} 
else 
{
    Write-Output "wkhtmltopdf not Installed. Downloading installer. Please wait..."
    $URL = 'https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.msvc2015-win64.exe'
    $downloadsPath= $env:USERPROFILE + '\Downloads\wkhtmltox-0.12.6-1.msvc2015-win64.exe'
    Invoke-WebRequest -URI $URL -OutFile $downloadsPath
    Write-Output "wkhtmltopdf Installer Downloaded. Follow Prompts."
    Start-Process -FilePath $downloadsPath -Wait
    $regexAddPath = [regex]::Escape($toPdf)
    $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch "^$regexAddPath\\?"}
    $env:Path = ($arrPath + $toPdf) -join ';'
}

if($args.Count -lt 1) 
{
    Write-Output "No year provided defaulting to 2020"
    $year = '2020'
}
else 
{
    $year = $args[0]
}

$pages = [System.Collections.ArrayList]@()
$pages.Add('https://brikwars.com/rules/'+ $year + '/cover.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/title.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/contents.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/brikpocalypse.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/universe.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/legal.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/tanks.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/core-rules.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/1.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/2.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/3.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/4.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/5.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/6.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/h.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/moc-combat.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/spirits.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/mc.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/7.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/8.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/9.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/10.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/sq.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/f.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/escapades.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/11.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/12.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/13.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/s.htm')
$pages.Add('https://brikwars.com/rules/'+ $year + '/d.htm')

$files = [System.Collections.ArrayList]@()
For ($i=0; $i -lt $pages.Count; $i++) {
    $page = $pages[$i]
    $outLocation = $brikWarsPath + $i + '.pdf' #keeps em in order
    $files.Add($outLocation)
    wkhtmltopdf.exe $page $outLocation
}

#combine
Set-Location $brikWarsPath
$title = 'BrikWarsRules' + $year + '.pdf'
$files | Merge-Pdf -OutputPath $title -Force