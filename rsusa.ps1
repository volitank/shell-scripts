Get-ChildItem -Filter *.dat |
Foreach-Object {
	$inputfile=$_.FullName
	$tempfile=($inputfile -replace "\.dat$",".tmp")
#	$outputfile=($inputfile -replace "Datfile","USA - Datfile")
.\xml.exe ed `
-d "//game[contains(@name, '(Europe)')]" `
-d "//game[contains(@name, '(Europe, Australia)')]" `
-d "//game[contains(@name, '(Japan)')]" `
-d "//game[contains(@name, '(Germany)')]" `
-d "//game[contains(@name, '(Sweden)')]" `
-d "//game[contains(@name, '(Korea)')]" `
-d "//game[contains(@name, '(UK)')]" `
-d "//game[contains(@name, '(Asia)')]" `
-d "//game[contains(@name, '(Italy)')]" `
-d "//game[contains(@name, '(Israel)')]" `
-d "//game[contains(@name, '(Scandinavia)')]" `
-d "//game[contains(@name, '(Spain)')]" `
-d "//game[contains(@name, '(Netherlands)')]" `
-d "//game[contains(@name, '(Finland)')]" `
-d "//game[contains(@name, '(Denmark)')]" `
-d "//game[contains(@name, '(Greece)')]" `
-d "//game[contains(@name, '(Russia)')]" `
-d "//game[contains(@name, '(UK, Australia)')]" `
-d "//game[contains(@name, '(Japan, Asia)')]" `
-d "//game[contains(@name, '(France)')]" `
-d "//game[contains(@name, '(Australia)')]" `
-d "//game[contains(@name, '(Portugal)')]" `
-d "//game[contains(@name, '(China)')]" `
-d "//game[contains(@name, '(India)')]" `
-d "//game[contains(@name, '(Spain, Portugal)')]" `
-d "//game[contains(@name, '(Switzerland)')]" `
-d "//game[contains(@name, '(Belgium, Netherlands)')]" `
-d "//game[contains(@name, '(Poland)')]" `
-d "//game[contains(@name, '(Brazil)')]" `
-d "//game[contains(@name, '(Latin America)')]" `
-d "//game[contains(@name, '(Croatia)')]" `
-d "//game[contains(@name, '(Japan, Korea)')]" `
-d "//game[contains(@name, '(Austria)')]" `
-d "//game[contains(@name, '(Norway)')]" `
-d "//game[contains(@name, '(Ireland)')]" `
-d "//game[contains(@name, '(Taiwan)')]" `
-d "//game[contains(@name, '(Austria, Switzerland)')]" `
-d "//game[contains(@name, '(South Africa)')]" `
-d "//game[contains(@name, '(Belgium)')]" $inputfile | Out-File -Encoding utf8 $tempfile
$count= (cat $tempfile | ./xml sel -t -m '//game' -v '@name' -nl | Measure-Object -Line)
$lines= (echo $count.lines)
$desc= (cat $tempfile | ./xml sel -t -v '/datafile/header/description')
$system= ($desc | Select-String '^.* - .* -' -AllMatches | Foreach-Object {$_.Matches.Value})
$date= ($desc | Select-String '\([^)]*\)$' -AllMatches | Foreach-Object {$_.Matches.Value})
$outputfile="$system USA - Datfile ($lines) $date.dat"
.\xml.exe ed -u '/datafile/header/description' -v "$system USA - Discs ($lines) $date" $tempfile | .\xml.exe fo --indent-tab | Out-File -Encoding utf8 $outputfile

#Compression Section.
#Switch Comments to use native Zip instead of 7z
#Compress-Archive $outputfile ($outputfile -replace "\.dat$",".zip"
& 'C:\Program Files\7-Zip\7z.exe' a ($outputfile -replace "\.dat$",".zip") $outputfile

rm $tempfile
}