#!/bin/sh
#this script searches the a directory for shapefile names and creates empty tables in a postgresql database

for FILE in c:/workspace/CM/mb_sed_class/output2/*.shp
do
   
   echo $FILE
   filename="${FILE##*/}"
   nakedname="${filename%.shp}"
   (cd C:/Program\ Files/PostgreSQL/9.4/bin; psql -h localhost -d mb_sed_class -U postgres -c "CREATE TABLE "$nakedname" AS SELECT * FROM test WHERE 1=2;")

done

