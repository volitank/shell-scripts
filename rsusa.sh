#!/bin/bash

for inputfile in *.dat; do
	[ -f "$inputfile" ] || break
tempfile=/tmp/"$(echo "$inputfile" | sed s/.dat/.tmp/g)"
	xmlstarlet ed \
-d "//game[contains(@name, '(Europe)')]" \
-d "//game[contains(@name, '(Europe, Australia)')]" \
-d "//game[contains(@name, '(Japan)')]" \
-d "//game[contains(@name, '(Germany)')]" \
-d "//game[contains(@name, '(Sweden)')]" \
-d "//game[contains(@name, '(Korea)')]" \
-d "//game[contains(@name, '(UK)')]" \
-d "//game[contains(@name, '(Asia)')]" \
-d "//game[contains(@name, '(Italy)')]" \
-d "//game[contains(@name, '(Israel)')]" \
-d "//game[contains(@name, '(Scandinavia)')]" \
-d "//game[contains(@name, '(Spain)')]" \
-d "//game[contains(@name, '(Netherlands)')]" \
-d "//game[contains(@name, '(Finland)')]" \
-d "//game[contains(@name, '(Denmark)')]" \
-d "//game[contains(@name, '(Greece)')]" \
-d "//game[contains(@name, '(Russia)')]" \
-d "//game[contains(@name, '(UK, Australia)')]" \
-d "//game[contains(@name, '(Japan, Asia)')]" \
-d "//game[contains(@name, '(France)')]" \
-d "//game[contains(@name, '(Australia)')]" \
-d "//game[contains(@name, '(Portugal)')]" \
-d "//game[contains(@name, '(China)')]" \
-d "//game[contains(@name, '(India)')]" \
-d "//game[contains(@name, '(Spain, Portugal)')]" \
-d "//game[contains(@name, '(Switzerland)')]" \
-d "//game[contains(@name, '(Belgium, Netherlands)')]" \
-d "//game[contains(@name, '(Poland)')]" \
-d "//game[contains(@name, '(Brazil)')]" \
-d "//game[contains(@name, '(Latin America)')]" \
-d "//game[contains(@name, '(Croatia)')]" \
-d "//game[contains(@name, '(Japan, Korea)')]" \
-d "//game[contains(@name, '(Austria)')]" \
-d "//game[contains(@name, '(Norway)')]" \
-d "//game[contains(@name, '(Ireland)')]" \
-d "//game[contains(@name, '(Taiwan)')]" \
-d "//game[contains(@name, '(Austria, Switzerland)')]" \
-d "//game[contains(@name, '(South Africa)')]" \
-d "//game[contains(@name, '(Belgium)')]" "$inputfile" > "$tempfile"


count=$(cat "$tempfile" | xmlstarlet sel -t -m '//game' -v '@name' -nl 2> /dev/null | wc -l)
desc=$(cat "$tempfile" | xmlstarlet sel -t -v '/datafile/header/description' 2> /dev/null)
system=$(echo "$desc" | grep -Eo '^.* - .* -')
date=$(echo "$desc" | grep -Eo '\([^)]*\)$')
outputfile="$system USA - Datfile ($count) $date.dat"
zipfile=$(echo "$outputfile" | sed s/.dat/.zip/g)

    xmlstarlet ed \
-u '/datafile/header/description' \
-v "$system USA - Discs ($count) $date" "$tempfile" | \

xmlstarlet fo --indent-tab > "$outputfile" ; echo "Created $outputfile"

zip "$zipfile" "$outputfile" > /dev/null 2>&1 ; echo "Created Archive $zipfile"
#zip "$(echo "$outputfile" | sed s/.dat/.zip/g)" "$outputfile" > /dev/null 2>&1

rm "$tempfile"

done
