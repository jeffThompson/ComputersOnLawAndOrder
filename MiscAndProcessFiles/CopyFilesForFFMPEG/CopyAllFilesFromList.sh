
# COPY ALL FILES FROM LIST
# a little utility for creating a video of all 11k screenshots

i=0			# count to keep filenames in order

# read list of files, copy
while read -r line
do
	# print just base filename
	echo $(basename $line)
	
	# copy to new location
	new_filename=$(printf %06d.png $i)
	cp $line /Users/JeffThompson/Documents/ComputersOnLawAndOrder/AllScreenshotFiles/$new_filename
	echo '- copied!'

	# increment
	(( i++ ))
	
# pipe in from file
done < /Users/JeffThompson/Documents/ComputersOnLawAndOrder/MiscAndProcessFiles/CopyFilesForFFMPEG/AllScreenshotFiles.txt