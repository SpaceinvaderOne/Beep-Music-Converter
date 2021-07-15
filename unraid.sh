#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# #  Unraid wav/mp3 to beep converter                                   # #
# #  by - SpaceinvaderOne -                                             # # 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Copy files to appdata
if [ ! -e /config/converted_wavs ] ; then
rsync -avh --exclude-from '/beep/exclude-list.txt' /beep/ /config/ && chmod 777 -R /config/ 
fi

# change into convert directory
cd /config/file_to_convert/ || exit

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


# check if default or sample run
checkrun() {
    if [ "$custom" == "default" ] ; then
monowav
mode="Default convert from folder mode"

# play sample Indiana_Jones
elif [ "$custom" == "Indiana_Jones" ] ; then	
name="/config/examples/Indiana_Jones.wav"
mode="Sample Indiana Jones Mode"

# play sample monkey island
elif [ "$custom" == "Monkey_Island" ] ; then	
name="/config/examples/Monkey_Island.wav"
mode="Sample Monkey Island beep tune mode"

else
echo "nothing selected"

fi
}

monowav() {
	
# Check if file is wav file	(not using for loop so fails if more than one file present)
    if [ -e *.wav ] ; then
# get filename of wav file
	filename=$(ls -r *.wav | head -n 1) && echo $filename
	export filenamenoext=$(echo "$filename" | cut -f 1 -d '.') && echo $filenamenoext
# convert wav to mono wav file
echo "File is an wav. I will convert it to a 16bit 44100 wav file"
	sox -G /config/file_to_convert/"$filename" -b 16 /config/file_to_convert/"$filenamenoext"_tmp.wav rate -v -s -L -a 44100 dither -a -s
# remove original wav and rename temp wav
	rm /config/file_to_convert/"$filename"
	mv /config/file_to_convert/"$filenamenoext"_tmp.wav /config/file_to_convert/"$filename"
# Set name and path of file to be converted to beep
	name=/config/file_to_convert/"$filename"
	cleanup="yes"

# Check if file is mp3 file	(not using for loop so fails if more than one file present)

elif [ -e *.mp3 ] ; then	
# get filename of mp3 file
	filename=$(ls -r *.mp3 | head -n 1) && echo $filename
	export filenamenoext=$(echo "$filename" | cut -f 1 -d '.') && echo $filenamenoext
# convert mp3 to mono wav file
	echo "file is an mp3. I will convert it to a 16bit 44100 wav file"
	sox -G /config/file_to_convert/"$filename" -b 16 /config/file_to_convert/"$filenamenoext"_tmp.wav rate -v -s -L -a 44100 dither -a -s
# remove original mp3 and rename temp wav
	rm /config/file_to_convert/"$filename"
	mv /config/file_to_convert/"$filenamenoext"_tmp.wav /config/file_to_convert/"$filename"
# Set name and path of file to be converted to beep
		name=/config/file_to_convert/"$filename"
		cleanup="yes"

else
echo "Nothing here to convert (or more than one wav or mp3). I can only work with a single wav or mp3 file. Place a wav or mp3 in the folder file_to_convert in the appdata folder"

fi
}

convertnoisy() {
		
# Check wav file exists then convert it to beep and play beep file
    if [ -e "$name" ] ; then
nohup python /beep/wavtobeep.py -w "$time" --verbose "$name" > /config/converted_wavs/"$filenamenoext".sh
else
echo "Nothing here to convert. Place a wav or mp3 in the folder file_to_convert in the appdata folder"
fi

}

convertsilent() {
		
# Check wav file exists then convert it to beep
    if [ -e "$name" ] ; then
nohup python /beep/wavtobeep.py -w "$time" --verbose --silent "$name" > /config/converted_wavs/"$filenamenoext".sh
else
echo "Nothing here to convert. Place a wav or mp3 in the folder file_to_convert in the appdata folder"
fi

}

convert() {
		
# Check if set to be silent
    if [ "$silent" == "yes" ] ; then
convertsilent
else
convertnoisy
fi

}


clean() {
      if [ "$cleanup" == "yes" ] ; then
#move wav file which has been processed to folder converted_wavs
      rm /config/file_to_convert/"$filename"
	  chmod 777 -R /config
	echo ""
	echo ""
	echo ""
	echo "Done! Converted $filename you will find it in the converted_wavs folder in container appdata"
  else
    echo ""
    echo ""
    echo ""
    echo "Done. This was just a sample now run after putting a .wav file in the file_to_convert folder and set template to default"

fi
}

# run functions
checkrun
convert
clean

exit