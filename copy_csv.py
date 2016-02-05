#On windows psycopg2 cant be imported from pip psycopg2
#Import from pip install git+https://github.com/nwcell/psycopg2-windows.git@win64-py27#egg=psycopg2
#To find all the correct dll's
#dont forget to set up ssh tunnel forwarding to local host from cmd
#Abandoned.....  Server client permission issues.  You need to either import data from pgAdminIII graphically or use `\copy` and psql.

import psycopg2
import os

conn = psycopg2.connect("dbname='reach_4a' user='root' host='localhost' port='9000' password='myPassword'")
tblname = "sept_2014"
file = r"C:\\Users\\dan\\Desktop\\New_folder\\Sept_2014\\R01761\\R01761_tex.asc"
#file = os.path.normpath(os.path.join('c:\\','Users','dan','Desktop','New_Folder','Sept_2014','R01762','R01762_tex.asc'))
print file
cur = conn.cursor()
sql = "COPY %s (easting,northing,texture) FROM '%s' DELIMITERS ' ';" % (tblname,file)
print sql
cur.execute(sql)
conn.commit()


#Close Database
try:
    conn.close()
    print 'Database connection destroyed'
except:
    print "I cant close the database"
    
    