#!/bin/bash
#This scirpt imports a directory of shapefiles into a postgres database
#-s= identify spatial reference 
#-D dump data instead of insert
pass='myPassword'
for f in D:/workspace/CM/mb_sed_class/output2012/*.shp
do
    shp2pgsql -s 26949 -D $f `basename $f .shp` | (cd C:/Program\ Files/PostgreSQL/9.4/bin; psql -h localhost -d test -U root -p 5435 -P $pass)
done
