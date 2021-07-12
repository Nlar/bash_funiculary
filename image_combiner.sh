#!/bin/bash

# This script will take two image files and merge them based on your monitor resoultion.
# This script was created since some desktop background managers won't handle different resolutions of monitors

monitor_1_file=$1
monitor_2_file=$2
if [ -z "$monitor_1_file" ]; then
    echo "Syntax is image_combiner.sh image_1 image_2"
    exit 1
fi
if [ -z "$monitor_2_file" ]; then
    echo "Syntax is image_combiner.sh image_1 image_2"
    exit 1
fi
resolution_1=$(xrandr | awk '/connected\s*[0-9]{3,4}x[0-9]{3,4}\+0\+0/' | grep -oE '[0-9]{3,4}x[0-9]{3,4}')
resolution_2=$(xrandr | awk '/connected\s*[0-9]{3,4}x[0-9]{3,4}\+[^0]/' | grep -oE '[0-9]{3,4}x[0-9]{3,4}')
echo "Found Resolutions $resolution_1 and $resolution_2"
new_file_name_1="${monitor_1_file%.*}_${resolution_1}.${monitor_1_file##*.}"
new_file_name_2="${monitor_2_file%.*}_${resolution_2}.${monitor_2_file##*.}"
new_file_combined=${monitor_1_file%.*}_${monitor_2_file%.*}.${monitor_1_file##*.}
echo $new_file_name_1
echo $new_file_name_2
echo $new_file_combined
convert -resize $resolution_1 -background transparent -gravity center -extent $resolution_1 "$monitor_1_file" "$new_file_name_1"
convert -resize $resolution_2 -background transparent -gravity center -extent $resolution_2 "$monitor_2_file" "$new_file_name_2"
convert +append $new_file_name_1 $new_file_name_2 $new_file_combined
rm "$new_file_name_1"
rm "$new_file_name_2"
exit 0
