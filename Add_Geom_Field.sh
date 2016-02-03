#/bin/sh
#encoding: utf-8

psql -h localhost -d R4a -U postgres -p 5432 -c "UPDATE tmp1 SET the_geom = ST_GeomFromText('POINT(' || easting || ' ' || northing || ')', 26949);"