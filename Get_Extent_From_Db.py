#On windows psycopg2 cant be imported from pip psycopg2
#Import from pip install git+https://github.com/nwcell/psycopg2-windows.git@win64-py27#egg=psycopg2
#ALso need to install the msi from http://www.stickpeople.com/projects/python/win-psycopg/
#To find all the correct dll's

import psycopg2
import math


try:
    conn = psycopg2.connect("dbname='GC' user='postgres' host='localhost' password='daniel'")
except:
    print "I am unable to connect to the database"

print ("I connected to the database")

#get table names from data base
cur = conn.cursor()
#cur.execute("select relname from pg_class where relkind='r' and relname !~ '^(pg_|sql_)';")
#print cur.fetchall()

cur.execute("""SELECT max(segment_060_2009_x_y_sedclass_dt_topo_25cm.northing) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm """)
max_y = cur.fetchone()[0]

cur.execute("""SELECT max(segment_060_2009_x_y_sedclass_dt_topo_25cm.easting) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm WHERE segment_060_2009_x_y_sedclass_dt_topo_25cm.northing=(SELECT max(segment_060_2009_x_y_sedclass_dt_topo_25cm.northing) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm)""")
max_x = cur.fetchone()[0]

cur.execute("""SELECT min(segment_060_2009_x_y_sedclass_dt_topo_25cm.northing) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm """)
min_y = cur.fetchone()[0]

cur.execute("""SELECT min(segment_060_2009_x_y_sedclass_dt_topo_25cm.easting) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm WHERE segment_060_2009_x_y_sedclass_dt_topo_25cm.northing=(SELECT min(segment_060_2009_x_y_sedclass_dt_topo_25cm.northing) FROM public.segment_060_2009_x_y_sedclass_dt_topo_25cm)""")
min_x = cur.fetchone()[0]

print int(math.ceil(max_x))
print int(math.ceil(max_y))
print int(min_x)
print int(min_y)

#Close Database
try:
    conn.close()
except:
    print "I cant close the database"

print ("I de connected from the database")