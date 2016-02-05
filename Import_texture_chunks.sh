#/bin/sh
#encoding: utf-8
#Shell Script to load asc files to postgres database
#

tablename='sept_2014'
files=$(find C:/Users/dan/Desktop/New_Folder/Sept_2014/ -name "*_tex.asc")

#loop through all x_y_class*.asc files for the supplied reach    
for file in $files:
do
echo $file
if [ -f $file ]; then
echo "That directory exists"

#Import a chunk of 
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename" (easting,northing,texture) FROM "$file" DELIMITER ' ' CSV;"

#Find scan line for update query
filename="${file##*/}"
name="${filename%_tex.asc}"

#Update scan line field with respective scan line
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET scan_line= '"$name"' WHERE scan_line IS NULL;"
else
echo "That directory doesn't exists"
fi
done

#Populate Geometry field 
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET the_geom = ST_SetSRID(ST_MakePoint(CAST(easting AS double precision), CAST(northing AS double precision)), 26949);"

