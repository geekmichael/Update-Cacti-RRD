#!/bin/bash
#
# A simple bash shell script to update all CACTI rrd files 
# Created by Michael Zhang <geek.michael@live.com>, 9 Jan 2019
#

# The path of RRD files on CACTI server
RRA_DIR=/var/www/html/cacti/rra

TMP_DIR=/tmp/update_cacti
BAK_DIR=$TMP_DIR/bak_rra
XML_DIR=$TMP_DIR/xml
NEW_RRA_DIR=$TMP_DIR/new_rra

# In order to locate the timestamp, you will need convert one rrd file into xml prior to run this script,
# and then find out the line with incorrect data.
#
# Be aware of escape backslash
INCORRECT_DATA_TIMESTAMP="<!-- 2019-01-08 19:05:00 CST \/ 1546945500 -->"

NEW_DATA="$INCORRECT_DATA_TIMESTAMP <row><v>NaN<\/v><v>NaN<\/v><\/row>"

if [ -d $TMP_DIR ]; then
  rmdir -rf $TMP_DIR 
fi

mkdir -pv $TMP_DIR/rra $XML_DIR $NEW_RRA_DIR
cd $RRA_DIR

for filename in *.rrd; do

   XML_FILE=$XML_DIR/"${filename/.rrd/.xml}"
   
   # Create backup 
   cp $filename $BAK_RRA/$filename

   # Convert rrd files to XML
   rrdtool dump $filename $XML_FILE

   # Use sed to update XML file
   # If you prefer other tool, feel free to change
   #
   sed -i -e "s/$INCORRECT_DATA_TIMESTAMP.*/$NEW_DATA/g" $XML_FILE

   # Restore XML file to RRD 
   rrdtool restore $XML_FILE $NEW_RRA_DIR/$filename -f

   # Transfer new RRD file to CACTI RRA folder
   cp -f $NEW_RRA_DIR/$filename $RRA_DIR/
   
   # Update file permissions, please update if you are using different CACTI username
   chown -R cacti.cacti $RRA_DIR/$filename

done
