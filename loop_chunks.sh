

#list of side scan and texture chunks
ssfiles=$(find /Users/danielhamill/Documents/Sept2014 -name 'x_y_ss*.asc')
texfiles=$(find /Users/danielhamill/Documents/Sept2014 -name 'x_y_class*.asc')

#Array of side scan and texture chunks
array1=($ssfiles)
array2=($texfiles)

count=${#array1[@]}


for i in `seq 1 $count`
do
ssfile=${array1[$i-1]} 
texfile=${array2[$i-1]}	
done

