#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#121212/g' \
         -e 's/rgb(100%,100%,100%)/#e1eded/g' \
    -e 's/rgb(50%,0%,0%)/#121212/g' \
     -e 's/rgb(0%,50%,0%)/#2AA1A1/g' \
 -e 's/rgb(0%,50.196078%,0%)/#2AA1A1/g' \
     -e 's/rgb(50%,0%,50%)/#121212/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#121212/g' \
     -e 's/rgb(0%,0%,50%)/#e1eded/g' \
	$@
