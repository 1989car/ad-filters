#!/bin/bash
#进入目录
cd $(cd "$(dirname "$0")";pwd)
#下载规则
urls=(
    "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_2_Base/filter.txt"
    "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_224_Chinese/filter.txt"
    "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"

    "https://easylist-downloads.adblockplus.org/easylist.txt"
    "https://easylist-downloads.adblockplus.org/easylistchina.txt"
    "https://easylist-downloads.adblockplus.org/easyprivacy.txt"

    "https://anti-ad.net/easylist.txt"
    "https://adrules.top/dns.txt"
)

for url in "${urls[@]}"; do
    curl -sS "$url" >> dns.txt
done
#添加自定义规则
cat ../rules/myrules.txt >> dns.txt
#修复换行符问题
sed -i 's/\r//' dns.txt
#去重
python sort.py dns.txt 
#压缩优化
hostlist-compiler -c dns.json -o dns-output.txt
#仅输出黑名单
cat dns-output.txt | grep -P "^\|\|.*\^$" > dns.txt
#再次排序
python sort.py dns.txt 
#移动规则
mv dns.txt ../rules/dns.txt
#清除缓存
rm -rf ./*.txt
