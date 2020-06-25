#!/bin/bash

# 最大的CPU占用率
maxCPUPercuentage=1
# 日志输出路径
logFilePath="temp.log"

containersInfo=`docker stats --no-stream --format '{{.Container}}:{{.CPUPerc}}' $*`
currentDate=`date +"%Y-%m-%d %H:%M:%S"`

echo "${containersInfo}" | while read line
do
    currentContainerId=`echo ${line} | cut -d ':' -f 1`
    currentContainerCPUPercuentage=`echo ${line} | cut -d ':' -f 2`
    currentContainerNeedRestart=$(echo "${currentContainerCPUPercuentage:0:-1} > ${maxCPUPercuentage}" | bc)
    echo "${currentDate} ${currentContainerId} 的CPU占用率是: ${currentContainerCPUPercuentage}"
    if [ ${currentContainerNeedRestart} = 1 ]
    then
        echo "${currentDate} 正在重启容器: ${currentContainerId}" >> ${logFilePath}
        docker restart ${currentContainerId}
    fi
done
