#!/usr/bin/sh
#
# BATCH OCR
# Jeff Thompson | 2014 | www.jeffreythompson.org
#
# USAGE
# sh BatchOCR.sh [input folder of images] [output filename.txt] [delete individual files (true/false)]
#
# Based on code by Ben Schmidt:
# http://benschmidt.org/dighist13/?page_id=129
# 
# ...which is in turn adapted from Barry Hubbard's code:
# http://www.barryhubbard.com/articles/37-general/74-converting-a-pdf-to-text-in-linux

inputFolder=$1
outputFilename=$2
deleteIndividualFiles=$3

# clear, say hello
clear
echo "BATCH OCR"
echo "Reading all image files from \"$inputFolder\""
echo ""

# extract text, write to individual text files
echo "Extracting text from files (may take a while...)"
i=0
for f in $inputFolder/*; do
	echo "\n$f"
	tesseract $f $inputFolder/OCR_`printf %04d $i`		# automatically adds .txt, otherwise becomes .txt.txt
	((i++))
done

# combine into a nice new file!
echo "\nMerging resulting files to \"$outputFilename\""
for f in $inputFolder/OCR_*.txt; do
	echo $f
	cat $f >> $outputFilename
done
# cat $inputFolder/*.txt > $outputFilename

# delete individual files created during the process, if specified
if $deleteIndividualFiles; then
	echo "\nDeleting individual files creating during OCR..."
	for f in $inputFolder/OCR_*.txt; do		# a little nicety, prevents deleting other files (hopefully)
		rm $f
	done
fi

echo "\n\nALL DONE!\n\n\n"