## Introduction
This is a bash shell script for updating all CACTI rrd files usually located in the folder of /var/www/html/cacti/rrd.

## Why do we need it?
There are various reasons that will cause CACTI populating incorrect data into RRD file, e.g. incorrect system time. It will be painful to update every RRD file manually.

## How it works?
- Step 1 use rrdtool to export rrd file into XML
- Step 2 use command tools, such as sed to update XML
- Step 3 convert XML back to rrd
