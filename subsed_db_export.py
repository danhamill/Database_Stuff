# -*- coding: utf-8 -*-
"""
Created on Mon Aug 22 13:16:36 2016

@author: dan
"""

import pandas as pd


fIn = r"C:\workspace\Merged_SS\2014_04_all.csv"
df = pd.read_csv(fIn, sep =' ' )
df = df[['easting','northing','texture','sidescan_intensity','scan_line']]
df.to_csv(r"C:\workspace\Merged_SS\subset\2014_04_analysis.csv", sep =' ', index=False )