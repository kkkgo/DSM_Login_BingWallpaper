#如需收集每日美图去掉下面注释设置保存文件夹路径，在FileStation里面右键文件夹属性可以看到路径
#savepath="/volume1/wallpaper"
#如需将收集的图片同时应用于用户桌面，请注释掉下面的用户名变量并改为对应用户名，并在“DSM桌面右上角-个人设置-桌面”启用“自定义壁纸”后任意选择一张图片
#username="admin"
pic=$(wget -t 5 --no-check-certificate -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
echo $pic|grep -q enddate||exit
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
date=$(echo $pic|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
tmpfile=/tmp/$date"_bing.jpg"
wget -t 5 --no-check-certificate  $link -qO $tmpfile
[ -s $tmpfile ]||exit
rm -rf /usr/syno/etc/login_background*.jpg
cp -f $tmpfile /usr/syno/etc/login_background.jpg &>/dev/null
cp -f $tmpfile /usr/syno/etc/login_background_hd.jpg &>/dev/null
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
synoindex -a $savepath/$date@$title-$word.jpg
fi
if (! -n "$username") then
cp -f $tmpfile /usr/syno/etc/preference/$username/wallpaper
chown $user:users /usr/syno/etc/preference/$username/wallpaper
fi
rm -rf /tmp/*_bing.jpg
