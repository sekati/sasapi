#!/bin/sh
####################################################################
#
# SLOCCount.sh - Source Lines Of Code Counter v1.0 - sekati.com
#
####################################################################

DIR="../../"
PROJECT="Sekati Actionscript API"
EXT="*.as"
SLOC=`find . -name $EXT -print0 | xargs -0 cat | wc -l`
FILE="../../sloc.txt"

cd $DIR

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" > $FILE
echo "                $PROJECT contains:" >> $FILE
echo "                   $SLOC lines of code." >> $FILE
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $FILE

cat $FILE

exit 0
