tag="v3.9.14"
tag="v3.9.43"
tag2="v3.9"
LOCALREG="kickstart.mclabs.us:5000"
function pull {
   itag=$*
   echo "docker pull $itag"
   docker pull $itag
   RC=$?
}
grep -v ^# /root/images | while read i
do
   pull ${i/<tag>/$tag}
   if [ $RC -ne 0 ]; then
      pull ${i/<tag>/$tag2}
      if [ $RC -ne 0 ]; then
         pull ${i/:<tag>/}
      fi
   fi
   if [ $RC -eq 0 ]; then
      INAME=${itag/\// }
      INAME=${INAME/* /}
      # echo "docker tag $i $LOCALREG/$INAME"
      # docker tag $i $LOCALREG/$INAME

      # echo "docker push $LOCALREG/$INAME"
      # docker push $LOCALREG/$INAME
   else
      echo "ERROR!!!  Failed to find any version of the image >>>$i"
   fi
done
