#!/bin/sh
sed -i \
         -e 's/#0f0f12/rgb(0%,0%,0%)/g' \
         -e 's/#c0c0bf/rgb(100%,100%,100%)/g' \
    -e 's/#0f0f12/rgb(50%,0%,0%)/g' \
     -e 's/#5E5E61/rgb(0%,50%,0%)/g' \
     -e 's/#0f0f12/rgb(50%,0%,50%)/g' \
     -e 's/#c0c0bf/rgb(0%,0%,50%)/g' \
	$@
