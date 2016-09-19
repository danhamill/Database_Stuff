# -*- coding: utf-8 -*-
"""
Created on Fri Jun 24 12:31:41 2016

@author: dan
"""
import pandas as pd
import psycopg2

db_connect="dbname='reach_4a' user='root'  host='localhost' port='9000'"
conn = psycopg2.connect(db_connect)

##50
#df = pd.read_sql_query('SELECT * from wa_50;', con=conn)
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\50.csv", sep =' ', index=False)
#df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\50_subset.csv",sep =' ', index=False)
#del df

#55
df = pd.read_sql_query('SELECT * from wa_55;', con=conn)
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\55.csv", sep =' ', index=False)
df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\55_subset.csv",sep =' ', index=False)
del df

#60
df = pd.read_sql_query('SELECT * from wa_60;', con=conn)
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\60.csv", sep =' ', index=False)
df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\60_subset.csv",sep =' ', index=False)
del df

#65
df = pd.read_sql_query('SELECT * from wa_65;', con=conn)
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\65.csv", sep =' ', index=False)
df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\65_subset.csv",sep =' ', index=False)
del df

##70
#df = pd.read_sql_query('SELECT * from wa_70;', con=conn)
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\70.csv", sep =' ', index=False)
#df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\70_subset.csv",sep =' ', index=False)
#del df
#
##80
#df = pd.read_sql_query('SELECT * from wa_80;', con=conn)
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\80.csv", sep =' ', index=False)
#df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\80_subset.csv",sep =' ', index=False)
#del df
#
##120
#df = pd.read_sql_query('SELECT * from wa_120;', con=conn)
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\120.csv", sep =' ', index=False)
#df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\120_subset.csv",sep =' ', index=False)
#del df
#
##160
#df = pd.read_sql_query('SELECT * from wa_160;', con=conn)
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\160.csv", sep =' ', index=False)
#df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
#df.to_csv(r"C:\workspace\Merged_SS\window_analysis\10_percent_shift\subset\160_subset.csv",sep =' ', index=False)
#del df

conn.close()

