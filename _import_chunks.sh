#list of side scan and texture chunks
ssfiles=$(find C:/Users/dan/Desktop/New_Folder/April_2015/ | egrep "R[0-9]{5}x_y_ss_raw[0-9]{1,2}.asc")
texfiles=$(find C:/Users/dan/Desktop/New_Folder/April_2015/ | egrep "*R[0-9]{5}x_y_class[0-9]{1,2}.asc")

#File paths for testing individual files
#ssfile=$(find C:/Users/dan/Desktop/New_Folder/Sept_2014/ | egrep "R01769x_y_ss_raw0.asc")
#texfile=$(find C:/Users/dan/Desktop/New_Folder/Sept_2014/ | egrep "*R01769x_y_class0.asc")

#Build Tables
survey='april_2014'
mosaic='mosaic_2015_04'
tablename='tmp'
tablename2='tmp2'
gist='_the_geom_gist'

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$survey"( gid SERIAL NOT NULL,
 easting double precision, northing double precision, texture double precision, sidescan_intensity double precision, the_geom GEOMETRY, scan_line text, CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2), CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL), CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 26949));"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename"(gid SERIAL NOT NULL, easting double precision, northing double precision, texture double precision, sidescan_intensity double precision, scan_line text);"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename2"(
  gid SERIAL NOT NULL,
  easting double precision,
  northing double precision,
  sidescan_intensity double precision,
  scan_line text
);"


#Array of side scan and texture chunks
array1=($ssfiles)
array2=($texfiles)

for i in "${!array1[@]}"; do

#set variable tex chunks file path
texfile=${array2[$i]}
echo $texfile

#Parse scan line from file name
filename="${texfile##*/}"
name="${filename%x_y_class*.asc}"


#Import texture chunk
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename" (easting,northing,texture) FROM "$texfile" DELIMITER ' ' CSV;"

#Update texture table field with respective scan line of the chunk
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET scan_line= '"$name"' WHERE scan_line IS NULL;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"

#set variable ss chunks file path
ssfile=${array1[$i]} 
echo $ssfile

#Import side scan chunk
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename2" (easting,northing,sidescan_intensity) FROM "$ssfile" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"

#Update texture chunk with SS intensity
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename" SET sidescan_intensity="$tablename2".sidescan_intensity FROM "$tablename2" WHERE "$tablename2".easting="$tablename".easting AND "$tablename2".northing="$tablename".northing;"

echo "Successfully merged side scan and texture chunks"

#Append to survey year main table
psql -h localhost -d reach_4a -U root -p 9000 -c "INSERT INTO "$survey" (easting,northing,texture,sidescan_intensity,scan_line) (SELECT easting,northing,texture,sidescan_intensity,scan_line FROM "$tablename");"

#Delete all data from temporary tables
psql -h localhost -d reach_4a -U root -p 9000 -c "DELETE FROM "$tablename";"
psql -h localhost -d reach_4a -U root -p 9000 -c "DELETE FROM "$tablename2";"

#Maintenance temporary tables for improved efficiency
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$survey";"
done

echo "Done importing chunks!!!"
#Create mosaic table
psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$mosaic" AS(SELECT tt.* FROM "$survey" tt INNER JOIN (SELECT easting, northing,texture, scan_line, MAX(sidescan_intensity) AS MaxSSIntensity FROM "$survey" GROUP BY (easting,northing,texture,scan_line)) groupedtt ON tt.easting = groupedtt.easting AND tt.northing = groupedtt.northing AND tt.texture = groupedtt.texture AND tt.scan_line = groupedtt.scan_line AND tt.sidescan_intensity = groupedtt.MaxSSIntensity);"


#Populate Geometry field For mosaic
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$mosaic" SET the_geom = ST_SetSRID(ST_MakePoint(CAST(easting AS double precision), CAST(northing AS double precision)), 26949);"

#Maintenance mosaic dataset from the geom update
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"

# #Drop temporary tables
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename" ;"
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename2" ;"