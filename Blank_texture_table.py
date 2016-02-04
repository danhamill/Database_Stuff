#On windows psycopg2 cant be imported from pip psycopg2
#Import from pip install git+https://github.com/nwcell/psycopg2-windows.git@win64-py27#egg=psycopg2
#To find all the correct dll's
#dont forget to set up ssh tunnel forwarding to local host from cmd

import psycopg2

try:
    conn = psycopg2.connect("dbname='reach_4a' user='root' host='localhost' port='9000' password='myPassword'")
    tblname = 'Sept_2014'
    cur = conn.cursor()
    sql = "CREATE TABLE %s (gid serial NOT NULL, easting double precision, northing double precision, texture double precision, the_geom geometry, scan_line text, CONSTRAINT r4a_pkey1 PRIMARY KEY (gid), CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2), CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL), CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 26949)) WITH (  OIDS=FALSE);" % tblname
    sql2 = "ALTER TABLE %s OWNER TO postgres;" % tblname
    cur.execute(sql)
    cur.execute(sql2)
    #make changes to the database persistent
    conn.commit()
except:
    print "I am unable to connect to the database"


#get table names from data base


#Close Database
try:
    conn.close()
    print 'Database connection destroyed'
except:
    print "I cant close the database"

