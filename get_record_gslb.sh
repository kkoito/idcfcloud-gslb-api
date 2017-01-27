#!/bin/bash
#変数読み込み
. ./var.list

curl -H "X-IDCF-APIKEY:${APIKEY}" -H "X-IDCF-Signature:${SIG_GET}" ${RECORDS_GET}|jq . > ${RECORDLOG}

#読み込んだファイルを一行ずつ読んで処理
FILE=$1
while read LINE ; do
        LABEL=`echo ${LINE}|awk -F, '{print $1}'`
        FIRST=`echo ${LINE}|awk -F, '{print $2}'`
        SECOND=`echo ${LINE}|awk -F, '{print $3}'`
	
	UUID1=`grep -B3 ${FIRST} ${RECORDLOG}|grep uuid|awk '{print $2}'|sed -e 's/\"//g'|sed -e 's/,//g'`
	UUID2=`grep -B3 ${SECOND} ${RECORDLOG}|grep uuid|awk '{print $2}'|sed -e 's/\"//g'|sed -e 's/,//g'`
	echo $UUID1
	echo $UUID2
	echo ""

done < ${FILE}


