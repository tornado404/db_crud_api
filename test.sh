#!/bin/bash

a=ATEST
b=BTEST
c=CTEST

data="release-1.4.2-rc1"
# 字符替换
data=$(echo  $data | sed -e 's/'${a}'/F/' -e 's/'${b}'/S/' -e 's/'${c}'/Y/')
# data=${data/${delay} ${unkown}/F S}
echo $data
data=${data#*release}
data=${data#*/}
data=${data#*-}
echo $data

