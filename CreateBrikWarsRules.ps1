Write-Output "Installing MergPdf. Hit yes."
Install-Module -Name MergePdf
$brikWarsPath = $env:USERPROFILE + '\Downloads\BrikWars\'
New-Item -Path $brikWarsPath -ItemType Directory

$toPdf = 'C:\Program Files\wkhtmltopdf\bin'

if (Test-Path $toPdf){
        Write-Output "wkhtmltopdf found."
        $regexAddPath = [regex]::Escape($toPdf)
        $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch 
"^$regexAddPath\\?"}
        $env:Path = ($arrPath + $toPdf) -join ';'
    } else {
         Write-Output "wkhtmltopdf not Installed. Downloading installer. Please wait..."
         $URL = 'https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.msvc2015-win64.exe'
         $downloadsPath= $env:USERPROFILE + '\Downloads\wkhtmltox-0.12.6-1.msvc2015-win64.exe'
         Invoke-WebRequest -URI $URL -OutFile $downloadsPath
         Write-Output "wkhtmltopdf Installer Downloaded. Follow Prompts."
         Start-Process -FilePath $downloadsPath -Wait
         $regexAddPath = [regex]::Escape($toPdf)
        $arrPath = $env:Path -split ';' | Where-Object {$_ -notMatch 
"^$regexAddPath\\?"}
        $env:Path = ($arrPath + $toPdf) -join ';'
    }

$pages = @('https://brikwars.com/rules/2020/cover.htm',
	       'https://brikwars.com/rules/2020/title.htm',
           'https://brikwars.com/rules/2020/contents.htm',
           'https://brikwars.com/rules/2020/brikpocalypse.htm',
           'https://brikwars.com/rules/2020/universe.htm',
           'https://brikwars.com/rules/2020/legal.htm',
           'https://brikwars.com/rules/2020/tanks.htm',
           'https://brikwars.com/rules/2020/core-rules.htm',
           'https://brikwars.com/rules/2020/1.htm',
           'https://brikwars.com/rules/2020/2.htm',
           'https://brikwars.com/rules/2020/3.htm',
           'https://brikwars.com/rules/2020/4.htm',
           'https://brikwars.com/rules/2020/5.htm',
           'https://brikwars.com/rules/2020/6.htm',
           'https://brikwars.com/rules/2020/h.htm',
           'https://brikwars.com/rules/2020/moc-combat.htm',
           'https://brikwars.com/rules/2020/spirits.htm',
           'https://brikwars.com/rules/2020/mc.htm',
           'https://brikwars.com/rules/2020/7.htm',
           'https://brikwars.com/rules/2020/8.htm',
           'https://brikwars.com/rules/2020/9.htm',
           'https://brikwars.com/rules/2020/10.htm',
           'https://brikwars.com/rules/2020/sq.htm',
           'https://brikwars.com/rules/2020/f.htm',
           'https://brikwars.com/rules/2020/escapades.htm',
           'https://brikwars.com/rules/2020/11.htm',
           'https://brikwars.com/rules/2020/12.htm',
           'https://brikwars.com/rules/2020/13.htm',
           'https://brikwars.com/rules/2020/s.htm',
           'https://brikwars.com/rules/2020/d.htm'
           )

For ($i=0; $i -lt $pages.Length; $i++) {
    $page = $pages[$i]
    $split = $page.Split('/')
    $file = $split[$split.Length - 1] + '.pdf'
    $outLocation = $brikWarsPath + $i + '.pdf' #keeps em in order
    wkhtmltopdf.exe $page $outLocation
}

#combine
cd $brikWarsPath
Merge-Pdf -OutputPath BrikWarsRules.pdf 