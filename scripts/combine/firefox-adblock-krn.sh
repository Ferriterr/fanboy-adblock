#!/bin/bash
#
# Fanboy-Merge (Korean) Adblock list grabber script v1.0 (12/06/2011)
# Dual License CCby3.0/GPLv2
# http://creativecommons.org/licenses/by/3.0/
# http://www.gnu.org/licenses/gpl-2.0.html
#
# Variables for directorys
#
MAINDIR="/var/www/adblock"
GOOGLEDIR="/home/fanboy/google/fanboy-adblock-list"
TESTDIR="/tmp/ramdisk"
ZIP="/usr/local/bin/7za"

# Make Ramdisk.
#
$GOOGLEDIR/scripts/ramdisk.sh
# Fallback if ramdisk.sh isn't excuted.
#
if [ ! -d "/tmp/ramdisk/" ]; then
  rm -rf /tmp/ramdisk/
  mkdir /tmp/ramdisk; chmod 777 /tmp/ramdisk
  mount -t tmpfs -o size=30M tmpfs /tmp/ramdisk/
  mkdir /tmp/ramdisk/opera/
fi




# Trim off header file (first 2 lines)
#
sed '1,2d' $GOOGLEDIR/firefox-regional/fanboy-adblocklist-krn.txt > $TESTDIR/fanboy-krn-temp2.txt

# Remove Empty Lines
#
sed '/^$/d' $TESTDIR/fanboy-krn-temp2.txt > $TESTDIR/fanboy-krn-temp.txt

# Remove Bottom Line
#
sed '$d' < $TESTDIR/fanboy-krn-temp.txt > $TESTDIR/fanboy-krn-temp2.txt

# Merge to the files together
#
cat $MAINDIR/fanboy-adblock.txt $TESTDIR/fanboy-krn-temp2.txt > $TESTDIR/fanboy-krn-merged.txt
perl $MAINDIR/addChecksum.pl $TESTDIR/fanboy-krn-merged.txt

# Copy Merged file to main dir
#
cp $TESTDIR/fanboy-krn-merged.txt $MAINDIR/r/fanboy+korean.txt

# Compress file
#
rm -f $MAINDIR/r/fanboy+korean.txt.gz
$ZIP a -mx=9 -y -tgzip $MAINDIR/r/fanboy+korean.txt.gz $MAINDIR/r/fanboy+korean.txt > /dev/null
