#/bin/sh
#encoding: utf-8
#Shell Script to load asc files to postgres database
#

tablename='sept_2014_1'
pkey='_pkey12'
gist='_the_geom_gist'
rpkey=$reach$pkey
rgist=$reach$gist


files=$(find C:/Users/dan/Desktop/New_Folder/April_2015/SS/ -name "*_ss*.asc")

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename"(
  gid SERIAL NOT NULL,
  easting double precision,
  northing double precision,
  sidescan_intensity double precision,
  the_geom GEOMETRY,
  scan_line text,
  CONSTRAINT "$rpkey" PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 26949));"





#loop through all x_y_class*.asc files for the supplied reach    
for file in $files:
do
echo $file
if [ -f $file ]; then
echo "That directory exists"

#Import a chunk of 
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename" (easting,northing,sidescan_intensity) FROM "$file" DELIMITER ' ' CSV;"

#Find scan line for update query
filename="${file##*/}"
name="${filename%x_y_ss_raw0.asc}"

#Update scan line field with respective scan line
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET scan_line= '"$name"' WHERE scan_line IS NULL;"
else
echo "That directory doesn't exists"
fi
done

#Populate Geometry field For a survey date
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET the_geom = ST_SetSRID(ST_MakePoint(CAST(easting AS double precision), CAST(northing AS double precision)), 26949);"

