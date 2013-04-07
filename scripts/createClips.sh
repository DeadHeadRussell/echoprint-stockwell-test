#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

input=$1/audio
noise=$2
output=$3/audio

mkdir $output
rm $output/*

for audio in $input/*
do
  echo ""
  echo "Creating clips for $audio"

  name=$(basename "$audio")
  name="${name%.*}"
  clip="$output/${name}"

  length=`ffmpeg -i "$audio" 2>&1 | grep Duration | cut -d " " -f 4 | cut -d . -f 1`
  hours=`echo $length | cut -d : -f 1`
  mins=`echo $length | cut -d : -f 2`

  printf -v hours_pad "%02d" $hours
  printf -v mins_pad "%02d" $mins

  hour=0
  min=0
  while [ $hour -lt $hours -o $min -lt $mins ]
  do
    printf -v hour_pad "%02d" $hour
    printf -v min_pad "%02d" $min

    echo -n -e "\rCreating $hour_pad:$min_pad/$hours_pad:$mins_pad"

    ffmpeg -i "$noise" -ss $hour_pad:$min_pad:00 -i "$audio" -filter_complex amerge -t 00:00:30 -ar 11025 "${clip}_${hour_pad}:${min_pad}:00.wav" 2>/dev/null > /dev/null
    ffmpeg -i "$noise" -ss $hour_pad:$min_pad:30 -i "$audio" -filter_complex amerge -t 00:00:30 -ar 11025 "${clip}_${hour_pad}:${min_pad}:30.wav" 2>/dev/null > /dev/null

    min=$((min+1))
    if [ $min -gt 59 ]
    then
      min=0
      hour=$((hour+1))
    fi
  done
  echo -n -e "\rDone creating.      \n"
done

