#!/bin/bash

nodeRunning=`ps -ef | grep -v grep | grep -cw node`

if [ $nodeRunning -eq 0 ]
then
  echo "Starting the server"
  cd ../server
  node index.js > /dev/null &
  cd ../test
fi

