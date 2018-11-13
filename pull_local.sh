tag="v3.9.14"
LOCALREG="kickstart.mclabs.us:5000"
grep -v ^# /root/images | while read i
do
   i=${i/<tag>/$tag}
   INAME=${i/\// }
   INAME=${INAME/* /}

   echo "docker pull $LOCALREG/$INAME"
   # docker pull $LOCALREG/$INAME

done
