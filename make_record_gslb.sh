#!/bin/bash

#########################################
#変数読み込み
. ./var.list
#########################################
#古いexec_api.shがあれば削除
if [ -e ${API} ]
	then
		rm ${API}
fi

#########################################
#読み込んだファイルを一行ずつ読んで処理
FILE=$1
while read LINE ; do
	LABEL=`echo ${LINE}|awk -F, '{print $1}'`
	FIRST=`echo ${LINE}|awk -F, '{print $2}'`
	SECOND=`echo ${LINE}|awk -F, '{print $3}'`

	echo ${CURL_POST} \'{\"name\": \"${LABEL}${GSLBDOMAIN}\",\"type\": \"A\",\"content\": \"${FIRST}\",\"ttl\": 5,\"weight\":\"1\" }\' ${RECORDS_POST} >> ${API}
	echo ${CURL_POST} \'{\"name\": \"${LABEL}${GSLBDOMAIN}\",\"type\": \"A\",\"content\": \"${SECOND}\",\"ttl\": 5,\"weight\":\"0\" }\' ${RECORDS_POST} >> ${API}


done < ${FILE}

echo "CSVファイル:"
wc -l ${1}
echo ""
echo "APIファイル:"
wc -l ${API}

exit 0
