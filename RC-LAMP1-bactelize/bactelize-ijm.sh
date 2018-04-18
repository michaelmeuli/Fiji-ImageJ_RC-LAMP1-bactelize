#!/bin/bash

OutDir=/media/mmeuli/WD-HD-ext4/20160531_BCG_Pasteur-Aeras_THP-1_LAMP1/data-results
InDir=/media/mmeuli/WD-HD-ext4/20160531_BCG_Pasteur-Aeras_THP-1_LAMP1/data-results-out
ResultFilename=1-1-A_result.txt

shopt -s nullglob

echo -e "cNr\tiNr\tlabel\tx\ty\tz\tpSize\tpixels\tmaxDiameter\tminDiameter\troundness\tlysosome\tmacrophage" > "$OutDir"/"$ResultFilename"

echo OK, collecting x-x-resut.txt into "$ResultFilename"
cat "$InDir"/*_result.txt >> "$OutDir"/"$ResultFilename"






