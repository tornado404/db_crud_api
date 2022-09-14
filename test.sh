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

# 分割获取数字
aCount=$(echo $data|cut -d 'F' -f 2 | cut -d '|' -f 1) # 使用命令行赋值需要$()
bCount=$(echo $data|cut -d 'S' -f 2 | cut -d '|' -f 1)
cCount=$(echo $data|cut -d 'Y' -f 2 | cut -d '|' -f 1)

# 不含有的字段分割不对，进行判断
if [ "$aCount" -gt 0 ] 2>/dev/null ;then
      echo aCount: $aCount
else
       aCount=0
fi

if [ "$bCount" -gt 0 ] 2>/dev/null ;then
      echo bCount: $bCount
else
       bCount=0
fi

if [ "$cCount" -gt 0 ] 2>/dev/null ;then
      echo cCount: $cCount
else
      cCount=0
fi

echo aCount: $aCount bCount: $bCount cCount: $cCount
