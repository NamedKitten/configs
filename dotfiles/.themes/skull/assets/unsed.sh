#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#0f0f12/g' \
         -e 's/rgb(100%,100%,100%)/#c0c0bf/g' \
    -e 's/rgb(50%,0%,0%)/#0f0f12/g' \
     -e 's/rgb(0%,50%,0%)/#5E5E61/g' \
 -e 's/rgb(0%,50.196078%,0%)/#5E5E61/g' \
     -e 's/rgb(50%,0%,50%)/#0f0f12/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#0f0f12/g' \
     -e 's/rgb(0%,0%,50%)/#c0c0bf/g' \
	$@