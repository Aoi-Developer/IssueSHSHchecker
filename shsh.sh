#取得可能なSHSHを検索し一覧にします
echo "#Issue SHSH checker Ver.1.0"
curl -s https://shsh.host >> cache.txt && tail cache.txt -n 3 | head -n 1 >> tes.txt && rm cache.txt
sed -e 's/var signed_array =//g' tes.txt > te.txt
rm tes.txt
cat te.txt | jq . >> test.txt 2>/dev/null
rm te.txt
cat test.txt | jq -S ' ."iPad6,11"' | sed -e 's/{//g' | sed -e 's/"//g' | sed -e 's/://g' | sed -e 's/}//g' | sed -e 's/,//g' |  sed -e '1d' | sed -e '$d'
echo 以上`cat test.txt | jq -S ' ."iPhone9,4"' | sed -e 's/{//g' | sed -e 's/"//g' | sed -e 's/://g' | sed -e 's/}//g' | sed -e 's/,//g' |  sed -e '1d' | sed -e '$d' | wc -l`個のSHSH取得が可能です。
rm test.txt
