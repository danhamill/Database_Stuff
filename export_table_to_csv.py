# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 12:31:41 2016

@author: dan
"""
import pandas as pd
import psycopg2

db_connect="dbname='reach_4a' user='root'  host='localhost' port='9000'"
conn = psycopg2.connect(db_connect)
df = pd.read_sql_query('SELECT * from ss_2012_05;', con=conn)
df.to_csv(r"C:\workspace\Merged_SS\2014_04\2012_05_all.csv", sep =' ', index=False)


