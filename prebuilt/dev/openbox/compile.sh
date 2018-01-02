BDIR=`pwd`
for dir in `ls | sed "s/compile.sh//g"`; do
	cd $dir
	sh compile.sh
	cd $BDIR 
done
