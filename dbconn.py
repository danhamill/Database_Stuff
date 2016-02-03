#On windows psycopg2 cant be imported from pip psycopg2
#Import from pip install git+https://github.com/nwcell/psycopg2-windows.git@win64-py27#egg=psycopg2
#To find all the correct dll's

import psycopg2

try:
    conn = psycopg2.connect("dbname='test' user='dhamill' host='localhost' password='nisplus' port='5435'")
except:
    print "I am unable to connect to the database"


#get table names from data base
cur = conn.cursor()
cur.execute("select relname from pg_class where relkind='r' and relname !~ '^(pg_|sql_)';")
print cur.fetchall()

#
#cur.execute("""SELECT * FROM seg_060_2009 Order By sed_class """)
#
#rows = cur.fetchall()
#
#Close Database
try:
    conn.close()
except:
    print "I cant close the database"

print ("I de connected from the database")