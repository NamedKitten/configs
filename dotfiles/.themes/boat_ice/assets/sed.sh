#!/bin/sh
sed -i \
         -e 's/#08070E/rgb(0%,0%,0%)/g' \
         -e 's/#b4cad8/rgb(100%,100%,100%)/g' \
    -e 's/#08070E/rgb(50%,0%,0%)/g' \
     -e 's/#DF6104/rgb(0%,50%,0%)/g' \
     -e 's/#08070E/rgb(50%,0%,50%)/g' \
     -e 's/#b4cad8/rgb(0%,0%,50%)/g' \
	$@