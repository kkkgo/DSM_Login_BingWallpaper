#如需收集每日美图去掉下面注释设置保存文件夹路径
#savepath="/volume1/wallpaper"
#在FileStation里面右键文件夹属性可以看到路径
pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
if (echo $pic|grep enddate &>/dev/null) then
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
date=$(echo $pic|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
tmpfile=/tmp/$date"_bing.jpg"
wget -t 5 --no-check-certificate  $link -qO $tmpfile
rm -rf /usr/syno/etc/login_background*.jpg
cp -f $tmpfile /usr/syno/etc/login_background.jpg
cp -f $tmpfile /usr/syno/etc/login_background_hd.jpg
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default_wallpaper/01.jpg
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_01.jpg
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/2x/default_wallpaper/dsm6_01.jpg
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_02.jpg
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/2x/default_wallpaper/dsm6_02.jpg
story=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/cnhp/life?mkt=zh-CN")
if (echo $story|grep hplaTtl &>/dev/null) then
title=$(echo $story|sed 's/.\+"hplaTtl">//g'|sed 's/<.\+//g')
word=$(echo $story|sed 's/.\+"hplaAttr">//g'|sed 's/<.\+//g')
if (echo $savepath|grep /&>/dev/null) then
cp -f $tmpfile $savepath/$date@$title-$word.jpg
fi
sed -i s/login_background_customize=.*//g /etc/synoinfo.conf
echo "login_background_customize=\"yes\"">>/etc/synoinfo.conf
sed -i s/login_welcome_title=.*//g /etc/synoinfo.conf
echo "login_welcome_title=\"$title\"">>/etc/synoinfo.conf
sed -i s/login_welcome_msg=.*//g /etc/synoinfo.conf
echo "login_welcome_msg=\"$word\"">>/etc/synoinfo.conf
fi
fi
rm -rf /tmp/*_bing.jpg
