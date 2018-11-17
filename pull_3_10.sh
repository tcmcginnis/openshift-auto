tag="v3.10.45"
tag2="v3.10"
function pull {
   itag=$*
   echo "docker pull $itag"
   docker pull $itag
   RC=$?
}
grep -v ^# ./images_3_10 | while read i
do
   pull ${i/<tag>/$tag}
   if [ $RC -ne 0 ]; then
      pull ${i/<tag>/$tag2}
      # if [ $RC -ne 0 ]; then
         # pull ${i/:<tag>/}
      # fi
   fi
   if [ $RC -ne 0 ]; then
      echo "ERROR!!!  Failed to find any version of the image >>>$i"
   fi
done
