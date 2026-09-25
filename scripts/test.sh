#!/usr/bin/env bash

set -euo pipefail 

if [ $1 = 'Downloads' ];then
	echo $1
else 
	echo "Not found ..."
fi
