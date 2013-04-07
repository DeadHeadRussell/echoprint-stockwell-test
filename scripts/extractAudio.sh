#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

videos=$1/video
audios=$1/audio

rm $audios/*

for video in $videos/*
do
  name=$(basename "$video")
  name="${name%.*}"
  audio="$audios/${name}.wav"
  ffmpeg -i "$video" -ar 11025 "$audio"
done

