#!/bin/bash

#########################################
#変数読み込み
. ./var.list
#########################################
#古いexec_api.shがあれば削除
if [ -e ${API_PUT} ]
	then
		rm ${API_PUT}
fi

#########################################
#関数
put_var(){
        SIG_PUT=`php sigu_put.php`
	CURL_PUT="curl -X PUT -H 'Content-Type: application/json' -H \"X-IDCF-APIKEY:${APIKEY}\" -H \"X-IDCF-Signature:${SIG_PUT}\" -d"
}

chweight_F0(){
	sed -i "s/record-uuid/${UUID1}/g" ${SIG_PUT_PHP}
	put_var
        echo ${CURL_PUT} \'{\"content\": \"${FIRST}\",\"ttl\": 5,\"weight\":\"0\" }\' ${RECORDS_PUT}/${UUID1} >> ${API_PUT}
	sed -i "s/${UUID1}/record-uuid/g" ${SIG_PUT_PHP}
}
chweight_F1(){
        sed -i "s/record-uuid/${UUID1}/g" ${SIG_PUT_PHP}
        put_var
	echo ${CURL_PUT} \'{\"content\": \"${FIRST}\",\"ttl\": 5,\"weight\":\"1\" }\' ${RECORDS_PUT}/${UUID1} >> ${API_PUT}
        sed -i "s/${UUID1}/record-uuid/g" ${SIG_PUT_PHP}
}
chweight_S0(){
        sed -i "s/record-uuid/${UUID2}/g" ${SIG_PUT_PHP}
        put_var
	echo ${CURL_PUT} \'{\"content\": \"${SECOND}\",\"ttl\": 5,\"weight\":\"0\" }\' ${RECORDS_PUT}/${UUID2} >> ${API_PUT}
        sed -i "s/${UUID2}/record-uuid/g" ${SIG_PUT_PHP}
}
chweight_S1(){
        sed -i "s/record-uuid/${UUID2}/g" ${SIG_PUT_PHP}
        put_var
	echo ${CURL_PUT} \'{\"content\": \"${SECOND}\",\"ttl\": 5,\"weight\":\"1\" }\' ${RECORDS_PUT}/${UUID2} >> ${API_PUT}
        sed -i "s/${UUID2}/record-uuid/g" ${SIG_PUT_PHP}
}
##############################################
#対象ゾーンに登録されているレコードを取得
curl -H "X-IDCF-APIKEY:${APIKEY}" -H "X-IDCF-Signature:${SIG_GET}" ${RECORDS_GET}|jq . > ${RECORDLOG}
##############################################
#読み込んだファイルを一行ずつ読んで処理
FILE=$1
while read LINE ; do
	LABEL=`echo ${LINE}|awk -F, '{print $1}'`
	FIRST=`echo ${LINE}|awk -F, '{print $2}'`
	SECOND=`echo ${LINE}|awk -F, '{print $3}'`
        UUID1=`grep -B3 ${FIRST} ${RECORDLOG}|grep uuid|awk '{print $2}'|sed -e 's/\"//g'|sed -e 's/,//g'`
        UUID2=`grep -B3 ${SECOND} ${RECORDLOG}|grep uuid|awk '{print $2}'|sed -e 's/\"//g'|sed -e 's/,//g'`


        case "${2}" in
                '10' )
	chweight_F1
	chweight_S0	
                ;;

                '01' )
	chweight_F0
	chweight_S1
                ;;

                '11' )
	chweight_F1
	chweight_S1
		;;

                '00' )
	chweight_F0
	chweight_S0
		;;

                * )
        echo "FAIL:そのオプションは無効です(10,11,01のいずれかを指定してください)"
        exit 1
                ;;

esac

done < ${FILE}

echo "CSVファイル:"
wc -l ${1}
echo ""
echo "APIファイル:"
wc -l ${API_PUT}

exit 0
