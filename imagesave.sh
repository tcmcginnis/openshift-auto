docker images --format="{{.Repository}}" | sort -u | while read -r imagerepo
do
   imagename=`basename $imagerepo`
   OUTFILE=$imagename.tgz
   if [ -f $OUTFILE ]; then
      echo "Bypassing $imagename"
   else
      echo "docker save $imagerepo | gzip -9 >$OUTFILE"
      docker save $imagerepo | gzip -9 >$OUTFILE
   fi
done

