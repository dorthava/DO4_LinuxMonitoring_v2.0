#!/bin/bash

# Параметр 1 - это абсолютный путь. dir=$1

# Параметр 2 - количество вложенных папок. folders_num=$2
# Параметр 3 - список букв английского алфавита, используемый в названии папок (не более 7 знаков). folders_names=$3
# Параметр 4 - количество файлов в каждой созданной папке. files_num=$4
# Параметр 5 - список букв английского алфавита, используемый в имени файла и расширении (не более 7 знаков для имени, не более 3 знаков для расширения). files_names=$5
# Параметр 6 - размер файлов (в килобайтах, но не более 100). file_size=$6

source input.sh

function create_arr() {
arr_name=$1
n="0"
for (( i = 0; i < ${#arr_name}; ++i)); do
if ! [ "${arr_name:$i:1}" == "${arr_name:$(($i+1)):1}" ]; then
simb_array[$n]="${arr_name:$i:1}"
n=$(($n+1))
fi
done
echo "${simb_array[@]}"
}

function generate_name() {
chars_in_name=$2
simbs_array=($(create_arr $2))
index_arr=$(($1%${#chars_in_name}))
repetition=$(($1/${#chars_in_name}))
new_name=""
    for (( j = 0; j < ${#chars_in_name}; j++ )); do
    local simb=${simbs_array[j]}
    new_name=${new_name}${simb}
    if [ "$j" -eq "$index_arr" ]; then 
        for ((k = 0; k <= ${repetition}; k++)); do
        new_name="${new_name}${simb}"
        done
    fi
    done
    echo "$new_name"
}

function create_folders { 

    new_fo=$(generate_name $i $folders_names)
    new_fo+="_"$(date +"%d%m%y")
    mkdir $dir/$new_fo
    echo "PATH: $dir/$new_fo, DATE: $(date +"%d:%m:%y")", NAME: $new_fo >> report.log
    for (( k = 0; k < $files_num; k++ )); do
    if [ $(memcheck) -eq 1 ]; then
    echo "Memory is full"
    exit 1
    fi
    new_fi=$(generate_name $k ${array_fi[0]})"_"$(date +"%d%m%y").${array_fi[1]}
    touch "$dir/$new_fo/$new_fi"
    truncate -s +$file_size "$dir/$new_fo/$new_fi"
    echo "PATH: $dir/$new_fo/$new_fi, DATE: $(date +"%d:%m:%y")", NAME: $new_fi, SIZE: $file_size >> report.log
    done

}

function memcheck() {
avail=`df -h | grep "/$" | awk '{print $4}'`
error="0"
if [[ "${avail: -1}" =~ ^G$ ]];then
avail="$(echo "$avail" | sed 's/.$//')"
    if [ $avail -eq "1" ]; then
    error="1"
    fi
else 
error="1"
fi
echo "$error"
}

