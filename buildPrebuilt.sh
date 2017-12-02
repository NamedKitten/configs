rm -rf prebuilt/*pkg*
cd prebuilt/dev
DEVDIR=`pwd`
for item in `ls -1`; do	
	cd $item
	sh compile.sh
	cd $DEVDIR
done

