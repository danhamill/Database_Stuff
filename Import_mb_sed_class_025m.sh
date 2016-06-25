#list of side scan and texture chunks
xyz=$(find C:/workspace/Reach_4a/Multibeam/xyz/2012_05/ | egrep "025m.xyz")
sed5=$(find C:/workspace/Reach_4a/Multibeam/mb_sed_class/ | egrep "*5class_25cm.xyz")
sed3=$(find C:/workspace/Reach_4a/Multibeam/mb_sed_class/ | egrep "*3class_25cm.xyz")
stdev=$(find C:/workspace/Reach_4a/Multibeam/xyz/2012_05/stats/025m/ | egrep "*resampled_025m.txt")

#Build Tables
survey='mb_may_2012_025m'
tablename='tmp1'
tablename2='tmp21'
tablename3='tmp31'
tablename4='tmp4'
gist='_the_geom_gist'

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$survey"( gid SERIAL NOT NULL,
 easting double precision, northing double precision, elevation double precision, Sed5Class double precision, Sed3Class double precision, StDev double precision, the_geom GEOMETRY,  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2), CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL), CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 26949));"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, Sed5Class double precision, Sed3Class double precision, StDev double precision);"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename2"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, Sed5Class double precision, Sed3Class double precision, StDev double precision);"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename3"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, Sed5Class double precision, Sed3Class double precision, StDev double precision);"

psql -h localhost -d reach_4a -U root -p 9000 -c "CREATE TABLE "$tablename4"(gid SERIAL NOT NULL, easting double precision, northing double precision, elevation double precision, Sed5Class double precision, Sed3Class double precision, StDev double precision);"
#Array of side scan and texture chunks
array1=($xyz)
array2=($sed5)
array3=($stdev)
array4=($sed3)

sed5file=${array2[$1]} 
stdevfile=${array3[$1]} 
sed3file=${array4[$1]} 

#Import mb xyz pool by pool
for i in "${!array1[@]}"; do
xyzfile=${array1[$i]}
echo $xyzfile
#Import xyz file
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename" (easting,northing,elevation) FROM "$xyzfile" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"
done

#Import sediment 5 class file
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename2" (easting,northing,Sed5Class) FROM "$sed5file" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"

#Import stdev file
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename3" (easting,northing,StDev) FROM "$stdevfile" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename3";"

#Import sediment 3 class file
psql -h localhost -d reach_4a -U root -p 9000 -c "\COPY "$tablename4" (easting,northing,Sed3Class) FROM "$sed3file" DELIMITER ' ' CSV;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename4";"

#Update sed5class (tmp2) chunk with elevation
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename2" SET elevation="$tablename".elevation FROM "$tablename" WHERE "$tablename".easting="$tablename2".easting AND "$tablename".northing="$tablename2".northing;"

#Update sed5class (tmp2) with stdev
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename2" SET StDev="$tablename3".StDev FROM "$tablename3" WHERE "$tablename3".easting="$tablename2".easting AND "$tablename3".northing="$tablename2".northing;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"

#Updtate sed5class (tmp2) with sed3Class
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$tablename2" SET Sed3Class="$tablename4".Sed3Class FROM "$tablename4" WHERE "$tablename4".easting="$tablename2".easting AND "$tablename4".northing="$tablename2".northing;"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"
echo "Successfully merged elevation, standard deviation, and sediment classes!!"

#Append to survey year main table
psql -h localhost -d reach_4a -U root -p 9000 -c "INSERT INTO "$survey" (easting,northing,elevation,Sed5Class,Sed3Class,StDev) (SELECT easting,northing,elevation,Sed5Class,Sed3Class,StDev FROM "$tablename2");"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$survey";"

#Delete all data from temporary tables
psql -h localhost -d reach_4a -U root -p 9000 -c "DELETE FROM "$tablename";"
psql -h localhost -d reach_4a -U root -p 9000 -c "DELETE FROM "$tablename2";"
psql -h localhost -d reach_4a -U root -p 9000 -c "DELETE FROM "$tablename3";"

#Maintenance temporary tables for improved efficiency
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename";"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$tablename2";"
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$survey";"


echo "Done importing chunks!!!"


#Populate Geometry field For survey
psql -h localhost -d reach_4a -U root -p 9000 -c "UPDATE "$survey" SET the_geom = ST_SetSRID(ST_MakePoint(CAST(easting AS double precision), CAST(northing AS double precision)), 26949);"

#Maintenance mosaic dataset from the geom update
psql -h localhost -d reach_4a -U root -p 9000 -c "VACUUM "$survey";"

# #Drop temporary tables
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename" ;"
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename2" ;"
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename3" ;"
psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$tablename4" ;"

#psql -h localhost -d reach_4a -U root -p 9000 -c "DROP TABLE "$survey" ;"