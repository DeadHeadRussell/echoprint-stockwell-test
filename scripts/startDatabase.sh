#!/bin/bash

mysqlRunning=`ps -ef | grep -v grep | grep -cw mysqld`

if [ $mysqlRunning -eq 0 ]
then
  echo "Starting MySQL"
  /usr/sbin/mysqld 2> /dev/null &
fi

