#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

audios=$1/audio
codes=$1/codes

mkdir "$codes"

mkdir "$codes/4.12"
mkdir "$codes/4.13"

rm $codes/4.12/*.fp
rm $codes/4.13/*.fp

length=`ls -1 $audios | wc -l`
i=1
for audio in $audios/*
do
  echo -e -n "\r[$i/$length] - $audio"

  name=$(basename "$audio")
  name="${name%.*}"
  v412="$codes/4.12/${name}.fp"
  v413="$codes/4.13/${name}.fp"

  $DIR/../bin/codegen-4.12 "$audio" > "$v412"
  $DIR/../bin/codegen-4.13 "$audio" > "$v413"

  i=$((i+1))
done

echo ""

