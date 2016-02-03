#encoding: utf-8

# Parse a delimited text file of volcano data and create a shapefile
#Adpated from https://pcjericks.github.io/py-gdalogr-cookbook/vector_layers.html#create-a-new-shapefile-and-add-data

import osgeo.ogr as ogr
import osgeo.osr as osr
import csv
from glob import glob
import os

root = "C:\\workspace\\Reach_4a\\XYZ"
out = "C:\\workspace\\Reach_4a\\test_out\\"

list = glob(root + '/*.xyz')
# use a dictionary reader so we can access by field name
for afile in list:
    print (afile + "\n")
    reader = csv.DictReader(open(afile,"rb"),
        fieldnames=("Easting","Northing","Sed_Class"),
        delimiter=',',
        quoting=csv.QUOTE_NONE)
    
    # set up the shapefile driver
    driver = ogr.GetDriverByName("ESRI Shapefile")
    
    filename = os.path.basename(os.path.splitext(afile)[0])
    #create the data source
    data_source = driver.CreateDataSource(out + filename + ".shp")
    
    # create the spatial reference, AZ Central SP
    srs = osr.SpatialReference()
    srs.ImportFromEPSG(26949)
    
    # create the layer
    layer = data_source.CreateLayer(filename, srs, ogr.wkbPoint)
    
    # Add the fields we're interested in
    field_name = ogr.FieldDefn("Easting", ogr.OFTReal)
    #field_name.SetWidth(100)
    layer.CreateField(field_name)
    layer.CreateField(ogr.FieldDefn("Northing", ogr.OFTReal))
    layer.CreateField(ogr.FieldDefn("Sed_Class", ogr.OFTReal))
    
    # Process the text file and add the attributes and features to the shapefile
    for row in reader:
        # create the feature
        feature = ogr.Feature(layer.GetLayerDefn())
        # Set the attributes using the values from the delimited text file
        feature.SetField("Easting", row['Easting'])
        feature.SetField("Northing", row['Northing'])
        feature.SetField("Sed_Class", row['Sed_Class'])
    
        # create the WKT for the feature using Python string formatting
        wkt = "POINT(%f %f)" %  (float(row['Easting']) , float(row['Northing']))
    
        # Create the point from the Well Known Txt
        point = ogr.CreateGeometryFromWkt(wkt)
    
        # Set the feature geometry using the point
        feature.SetGeometry(point)
        # Create the feature in the layer (shapefile)
        layer.CreateFeature(feature)
        # Destroy the feature to free resources
        feature.Destroy()
    
    # Destroy the data source to free resources
    data_source.Destroy()