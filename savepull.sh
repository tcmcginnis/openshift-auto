tag="v3.10.83"
tag2="v3.10"
IMAGEDIR="/nfs/images_v3.10.83"
function pull {
   itag=$*
   echo "docker pull $itag"
   docker pull $itag
   RC=$?
}
grep -v ^# ./images_3_10 | while read i
do
   imagerepo="${i/<tag>/$tag}"
   RESP=`docker images --format="{{.Repository}}:{{.Tag}}" $imagerepo`
   if [ "$RESP" = "" ]; then
      imagerepo="${i/<tag>/$tag2}"
      RESP=`docker images --format="{{.Repository}}:{{.Tag}}" $imagerepo`
      if [ "$RESP" = "" ]; then
         imagerepo="${i/:<tag>/}"
         RESP=`docker images --format="{{.Repository}}:{{.Tag}}" $imagerepo`
      fi
   fi
   if [ "$RESP" = "" ]; then
      echo "ERROR!!!  Failed to find any version of the image >>>$i"
   else
      # echo "$imagerepo"
      imagename=`basename $imagerepo`
      OUTFILE=$imagename.tgz
      if [ -f $IMAGEDIR/$OUTFILE ]; then
         echo "Bypassing $imagename"
      else
         echo "docker save $imagerepo | gzip -9 >$IMAGEDIR/$imagename.tgz"
         if [ "$1" != "-p" ]; then
            docker save $imagerepo | gzip -9 >$IMAGEDIR/$imagename.tgz
         fi
      fi
   fi
done
