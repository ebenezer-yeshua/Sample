#!/bin/bash

BUCKET=backupsblog
MULBATH=/opt/multipart
COULIMIT=1000
DAT=$(date +%F)
FILESIZE=`ls -l --b=M ${1}  | cut -d " " -f5 | sed 's/M//g'`
rm -rf ${MULBATH}/*.tar.gz
rm -rf ${MULBATH}/*.json
dd if=${1} of=${MULBATH}/${2}.tar.gz bs=1024k count=${FILESIZE}
PARTFILESIZE=`ls -l --b=G ${MULBATH}/${2}.tar.gz  | cut -d " " -f5 | sed 's/G//g'`
COUSUM=`expr ${FILESIZE} / ${COULIMIT}`
COUNTSUM=`expr ${COUSUM} + 1`
echo $COUNTSUM
if [ ${COUNTSUM} -ge ${COUNTSUM} ]; then
 echo "Good sign"
for ((i=1;i<=${COUNTSUM};i++));
do
     dd if=${MULBATH}/${2}.tar.gz of=${MULBATH}/${2}${i}.tar.gz bs=1024k skip=$[i*1000 - 1000] count=1000
done
     aws s3api create-multipart-upload --bucket ${BUCKET} --key ${2}_${DAT}.tar.gz > ${MULBATH}/basemultipartuploadid.json
     UPLOADID=`cat ${MULBATH}/basemultipartuploadid.json | grep  UploadId | cut -d'"' -f4`
for ((j=1;j<=${COUNTSUM};j++));
do
     aws s3api upload-part --bucket ${BUCKET} --key ${2}_${DAT}.tar.gz --upload-id ${UPLOADID} --part-number $j --body ${MULBATH}/${2}${j}.tar.gz > ${MULBATH}/baseEtag-${2}${j}.json
done
     echo  '{ "Parts": [' > ${MULBATH}/basecompletemultipart.json
for ((x=1;x<=${COUNTSUM};x++));
do
     echo '{' >>  ${MULBATH}/basecompletemultipart.json
     VAL=`cat ${MULBATH}/baseEtag-${2}${x}.json | grep ETag`
     echo "${VAL}," >> ${MULBATH}/basecompletemultipart.json
     echo '    "PartNumber":' ${x} >>  ${MULBATH}/basecompletemultipart.json
     if [[ ${COUNTSUM} == ${x} ]]; then
     echo '}' >> ${MULBATH}/basecompletemultipart.json
     else
     echo '},' >> ${MULBATH}/basecompletemultipart.json
     fi

done
     echo  ']' >> ${MULBATH}/basecompletemultipart.json
     echo  '}' >> ${MULBATH}/basecompletemultipart.json
     aws s3api complete-multipart-upload --bucket ${BUCKET} --key ${2}_${DAT}.tar.gz --upload-id ${UPLOADID} --multipart-upload file://${MULBATH}/basecompletemultipart.json > ${MULBATH}/baseFinishupload.json
else
 echo "Oops"
fi
