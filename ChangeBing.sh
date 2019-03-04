#如需收集每日美图去掉下面注释设置保存文件夹路径
#savepath="/volume1/wallpaper"
#在FileStation里面右键文件夹属性可以看到路径
pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
if (echo $pic|grep -q enddate) then
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
date=$(echo $pic|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
tmpfile=/tmp/$date"_bing.jpg"
wget -t 5 --no-check-certificate  $link -qO $tmpfile
rm -rf /usr/syno/etc/login_background*.jpg
cp -f $tmpfile /usr/syno/etc/login_background.jpg &>/dev/null
cp -f $tmpfile /usr/syno/etc/login_background_hd.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default_wallpaper/01.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_01.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/2x/default_wallpaper/dsm6_01.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_02.jpg &>/dev/null
cp -f $tmpfile /usr/syno/synoman/webman/resources/images/default/2x/default_wallpaper/dsm6_02.jpg &>/dev/null
title=$(echo $pic|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $pic|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
word=$(echo $copyright|sed 's/(.\+//g')
if  [ ! -n "$title" ];then
cninfo=$(echo $copyright|sed 's/，/"/g'|sed 's/,/"/g'|sed 's/(/"/g'|sed 's/ //g'|sed 's/\//_/g'|sed 's/)//g')
title=$(echo $cninfo|cut -d'"' -f1)
word=$(echo $cninfo|cut -d'"' -f2)
fi
sed -i s/login_background_customize=.*//g /etc/synoinfo.conf
echo "login_background_customize=\"yes\"">>/etc/synoinfo.conf
sed -i s/login_welcome_title=.*//g /etc/synoinfo.conf
echo "login_welcome_title=\"$title\"">>/etc/synoinfo.conf
sed -i s/login_welcome_msg=.*//g /etc/synoinfo.conf
echo "login_welcome_msg=\"$word\"">>/etc/synoinfo.conf
if (echo $savepath|grep -q '/') then
cp -f $tmpfile $savepath/$date@$title-$word.jpg
fi
fi
rm -rf /tmp/*_bing.jpg
