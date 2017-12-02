rm -rf prebuilt/*pkg*
cd prebuilt/dev
DEVDIR=`pwd`
for item in *; do
	cd $item
	sh compile.sh
	cd $DEVDIR
done

