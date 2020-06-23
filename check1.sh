#!/bin/bash


for((i=1;i<=20;i++));do

	  /root/check.sh 2>/dev/null &
	    sleep 10
    done
