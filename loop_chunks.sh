#list of side scan and texture chunks
ssfiles=$(find C:/Users/dan/Desktop/New_Folder/Sept_2014/ | egrep "R[0-9]{5}x_y_ss_raw[0-9]{1,2}.asc")
texfiles=$(find C:/Users/dan/Desktop/New_Folder/Sept_2014/ | egrep "*R[0-9]{5}x_y_class[0-9]{1,2}.asc")

#Array of side scan and texture chunks
array1=($ssfiles)
array2=($texfiles)

count=${#array1[@]}

for i in "${!array1[@]}"; do


ssfile=${array1[$i]} 
texfile=${array2[$i]}	
echo $ssfile
echo $texfile
done

