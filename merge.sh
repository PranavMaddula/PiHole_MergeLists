#!/bin/bash
#Download files on list
parallel -j 20 --gnu -a input/adlist.list wget -P output/

#Move and extract zips
mv output/*.zip zips/
unzip -d zips/output "zips/*.zip"

#renmae zips
cd zips/output/
rename 's/^/zip_/' *.txt
cd ..
cd ..

#merge back zips
#mv zips/output/* output/

#merge all files
cat output/*.* >> merge/merged_dirty.txt

#strip HTML
sed -e 's/<[^>]*>//g' merge/merged_dirty.txt >  merge/merged_clean.txt
cat  merge/merged_clean.txt >>  merge/merged.txt

#remove duplicates
#awk '{!seen[$0]++}' merge/merged.txt	#output supressed
awk '!seen[$0]++' merge/merged.txt	#with output
mv merge/merged.txt final.txt
cp final.txt final/final.txt

cd final
split -n l/5 --additional-suffix .txt final.txt merge.part_
rm -rf final.txt
cd ..


#cleanup
rm -rf output/*
rm -rf zips/*.zip
rm -rf zips/output/*
rm -rf  merge/*
