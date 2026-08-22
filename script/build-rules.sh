#!/bin/bash
#进入目录
cd $(cd "$(dirname "$0")";pwd)
#下载规则
urls=(
    https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt
    https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Xiaomi-Extension.txt
    https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Huawei-AdBlock.txt
    https://raw.githubusercontent.com/durablenapkin/block/master/luminati.txt
    https://raw.githubusercontent.com/durablenapkin/block/master/tvstream.txt
    https://zerodot1.gitlab.io/CoinBlockerLists/list_browser.txt
    https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt
    https://easylist.to/easylist/easylist.txt
    https://easylist.to/easylist/easyprivacy.txt
    https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
    https://filters.adtidy.org/extension/ublock/filters/2_without_easylist.txt
    https://filters.adtidy.org/extension/ublock/filters/11_optimized.txt
    https://filters.adtidy.org/extension/ublock/filters/3_optimized.txt
    https://filters.adtidy.org/extension/ublock/filters/224_optimized.txt
    https://raw.githubusercontent.com/DandelionSprout/adfilt/master/GameConsoleAdblockList.txt
    https://perflyst.github.io/PiHoleBlocklist/SmartTV-AGH.txt
    https://ublockorigin.github.io/uAssetsCDN/filters/unbreak.min.txt
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
