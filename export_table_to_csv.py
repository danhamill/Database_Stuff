# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 12:31:41 2016

@author: dan
"""
import pandas as pd
import psycopg2

db_connect="dbname='reach_4a' user='root'  host='localhost' port='9000'"
conn = psycopg2.connect(db_connect)
df = pd.read_sql_query('SELECT * from ss_wa_160;', con=conn)
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\160.csv", sep =' ', index=False)
df = df[['easting','northing','texture','sidescan_intensity','scan_line']]

df.to_csv(r"C:\workspace\Merged_SS\window_analysis\subset\160_subset.csv",sep =' ', index=False)
del df

conn.close()

