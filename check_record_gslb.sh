#!/bin/bash

#########################################
#変数読み込み
. ./var.list
#########################################
#古いcheck_record.logがあれば削除
if [ -e ${LOG} ]
        then
                rm ${LOG}
fi
#########################################
#読み込んだファイルを一行ずつ読んで処理
FILE=$1

first_func(){
dig ${LABEL}${GSLBDOMAIN} +noall +answer +time=2 ${NS} |grep ${FIRST}
if [ $? -eq 0 ]
        then
                echo "OK: LABEL=${LABEL}${GSLBDOMAIN} Arecord=${FIRST}" >> ${LOG}
        else
                echo "NG: LABEL=${LABEL}${GSLBDOMAIN} Arecord=${FIRST}" >> ${LOG}
fi
}

second_func(){
dig ${LABEL}${GSLBDOMAIN} +noall +answer +time=2 ${NS} |grep ${SECOND}
if [ $? -eq 0 ]
        then
                echo "OK: LABEL=${LABEL}${GSLBDOMAIN} Arecord=${SECOND}" >> ${LOG}
        else
                echo "NG: LABEL=${LABEL}${GSLBDOMAIN} Arecord=${SECOND}" >> ${LOG}
fi
}

while read LINE ; do
        LABEL=`echo ${LINE}|awk -F, '{print $1}'`
        FIRST=`echo ${LINE}|awk -F, '{print $2}'`
        SECOND=`echo ${LINE}|awk -F, '{print $3}'`

        case "${2}" in
                '10' )
        first_func
                ;;

                '01' )
        second_func
                ;;

                '11' )
        first_func
        second_func
                ;;

                * )
        echo "FAIL:そのオプションは無効です(10,11,01のいずれかを指定してください)"
        exit 1
                ;;

esac

done < ${FILE}
echo "CVEファイル行数"
wc -l ${1}
echo ""
echo "LOGファイル行数"
wc -l ${LOG}
grep NG ${LOG}
if [ $? -eq 1 ]
        then
                echo "OK: チェック失敗レコード件数 0 "
        else
		NGCHECK=`grep NG ${LOG}|wc -l`
                echo "NG: チェック失敗レコード件数 ${NGCHECK}件"
fi


exit 0
