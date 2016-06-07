#list of side scan and texture chunks
xyz=$(find C:/workspace/Reach_4a/Multibeam/xyz/2012_05/| egrep "seg_60_xyz_Resampled")
sed5=$(find C:/workspace/Reach_4a/Multibeam/mb_sed_class/ | egrep "*5class_25cm.xyz")

#Build Tables
survey='mb_may_2012'
mosaic='mb_2012_05'
tablename='tmp'
tablename2='tmp2'
gist='_the_geom_gist'

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$survey"( gid SERIAL NOT NULL,
 easting double precision, northing double precision, double precision, SedClass double precision, the_geom GEOMETRY,  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2), CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL), CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 26949));"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, SedClass double precision);"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename2"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, SedClass double precision);"


#Array of side scan and texture chunks
array1=($xyz)
array2=($sed5)

for i in "${!array1[@]}"; do

#set variable tex chunks file path
#xyzfile=${array1[$i]}
xyzfile=${array1[$1]}
echo $xyzfile

#Import xyz file
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename" (easting,northing,elevation) FROM "$xyzfile" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"


#set variable ss chunks file path
#sed5file=${array2[$i]}
sed5file=${array2[$1]} 
echo $sed5file

#Import sediment class chunk
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename2" (easting,northing,SedClass) FROM "$sed5file" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"

#Update sedclass chunk with SS elevation
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename2" SET SedClass="$tablename".SedClass FROM "$tablename" WHERE "$tablename".easting="$tablename2".easting AND "$tablename".northing="$tablename2".northing;"
echo "Successfully merged elevation and sediment classes!!"

#Append to survey year main table
psql -h localhost -d reach_4a -U root -p 9000 -c "INSERT INTO "$survey" (easting,northing,elevation,SedClass) (SELECT easting,northing,elevation,SedClass FROM "$tablename2");"

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
psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$mosaic" AS(SELECT tt.* FROM "$survey" tt INNER JOIN (SELECT easting, northing,texture, scan_line, MAX(sidescan_intensity) AS MaxSSIntensity FROM "$survey" GROUP BY ("$survey".easting,"$survey".northing,"$survey".texture,"$survey".scan_line)) groupedtt ON tt.easting = groupedtt.easting AND tt.northing = groupedtt.northing AND tt.texture = groupedtt.texture AND tt.scan_line = groupedtt.scan_line AND tt.sidescan_intensity = groupedtt.MaxSSIntensity);"


#Populate Geometry field For mosaic
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$mosaic" SET the_geom = ST_SetSRID(ST_MakePoint(CAST(easting AS double precision), CAST(northing AS double precision)), 26949);"

#Maintenance mosaic dataset from the geom update
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"

# #Drop temporary tables
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename" ;"
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename2" ;"