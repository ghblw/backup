#!/bin/bash
source .back.rc
date=`date +"%Y-%m-%d %H:%M"`
date_file=`date +"%Y_%m_%d_%H_%M"`
paths=`echo $backup_path | tr ":" "\n"`
#备份
for file in $paths ; do
    echo "start backup"
    name=`echo $file | cut -d "/" -f 2- | tr "/" "_"`    #文件名
    name=${name}_${date_file}.tgz
    tar -czPf ${dest_dir}/${name} $file
    if [[ $? -eq 0 ]]; then
        size=`du -h ${dest_dir}/${name} | cut -d " " -f 1`  
        echo "$date backup $file --> $name +${size}" >>$log 
    else
        echo "$date ERROR" >> $log
    fi
done
#删除
del=`find $dest_dir -name "*.tgz" -mtime +3`  #找出三天前的文件
for file in $del; do
    size=`du -h $file | cut -d " " -f 1`
    rm -f $file
    echo "$date delete $file    remove -${size}">>$log    #删除三天前的文件写入日志
done
