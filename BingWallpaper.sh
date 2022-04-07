#设置拥有图片权限的用户名
username="shenhaiyu"
#如需将图片应用于登陆界面，就去掉下面注释
loginbkg="true"
#如需将图片应用于用户桌面，就去掉下面注释改为对应用户名，并在“DSM桌面右上角-个人设置-桌面”启用“自定义壁纸”后任意选择一张图片
#userbkg="/usr/syno/etc/preference/$username/wallpaper"
userbkg7="/usr/syno/etc/preference/$username/wallpaper_dir/wallpaper"
userbkg7_hd="/usr/syno/etc/preference/$username/wallpaper_dir/wallpaper_hd"
#如需将图片保存到指定路径，就去掉下面注释设置保存文件夹路径（在 FileStation 里面右键文件夹属性可以看到路径）
savepath="/volume1/photo/BingWallpaper"
savepathUHD="/volume1/photo/BingWallpaper/UHD"

#以下内容无需修改
#以下内容无需修改
#以下内容无需修改

#解析壁纸的下载地址，获取1080p与4k以上分辨率的壁纸
api=$(wget -t 5 --no-check-certificate -qO- "https://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1")
echo $api|grep -q enddate||exit
link=$(echo https://bing.com$(echo $api|sed 's/.\+"urlbase"[:" ]\+//g'|sed 's/".\+//g')_1920x1080.jpg)
linkUHD=$(echo https://bing.com$(echo $api|sed 's/.\+"urlbase"[:" ]\+//g'|sed 's/".\+//g')_UHD.jpg)
date=$(echo $api|sed 's/.\+enddate[": ]\+//g'|grep -Eo 2[0-9]{7}|head -1)
#下载壁纸至临时文件夹
tmpfile=/tmp/$date"_bing.jpg"
tmpfileUHD=/tmp/$date"_bingUHD.jpg"
wget -t 5 --no-check-certificate $link -qO $tmpfile
wget -t 5 --no-check-certificate $linkUHD -qO $tmpfileUHD
[ -s $tmpfile ]||exit
#解析壁纸著作权信息
title=$(echo $api|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $api|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
word=$(echo $copyright|sed 's/(.\+//g'|sed 's/\//,/g'|sed 's/ //g')
if [ ! -n "$title" ]; then
	cninfo=$(echo $copyright|sed 's/，/"/g'|sed 's/,/"/g'|sed 's/(/"/g'|sed 's/ //g'|sed 's/\//_/g'|sed 's/)//g')
	title=$(echo $cninfo|cut -d'"' -f1)
	word=$(echo $cninfo|cut -d'"' -f2)
fi
#修改登陆页面信息
if [ -n "$loginbkg" ]; then
	rm -rf /usr/syno/etc/login_background*.jpg
	cp -f $tmpfile /usr/syno/etc/login_background.jpg &>/dev/null
	cp -f $tmpfile /usr/syno/etc/login_background_hd.jpg &>/dev/null
	if grep -q login_background_customize /etc/synoinfo.conf; then
		sed -i "s/login_background_customize=.*/login_background_customize=\"yes\"/g" /etc/synoinfo.conf
		sed -i "s/login_welcome_title=.*/login_welcome_title=\"$title\"/g" /etc/synoinfo.conf
		sed -i "s/login_welcome_msg=.*/login_welcome_msg=\"$word\"/g" /etc/synoinfo.conf
	else
		echo "#ChangeBing.sh">>/etc/synoinfo.conf
		echo "login_background_customize=\"yes\"">>/etc/synoinfo.conf
		echo "login_welcome_title=\"$title\"">>/etc/synoinfo.conf
		echo "login_welcome_msg=\"$word\"">>/etc/synoinfo.conf
	fi
fi
#将图片应用于用户桌面
#if [ -n "$userbkg" ]; then
#	cp -f $tmpfile $userbkg
#	chown $username:users $userbkg
#fi
if [ -n "$userbkg7" ]; then
	cp -f $tmpfile $userbkg7
	chown $username:users $userbkg7
fi
if [ -n "$userbkg7_hd" ]; then
	cp -f $tmpfile $userbkg7_hd
	chown $username:users $userbkg7_hd
fi
#将图片保存到指定路径
if [ -n "$savepath" ]; then
	cp -f $tmpfile $savepath/$date@${title}-${word}.jpg
	chown $username:users $savepath/$date@${title}-${word}.jpg
	synoindex -a $savepath/$date@${title}-${word}.jpg
fi
#将UHD图片保存到指定路径
if [ -n "$savepathUHD" ]; then
	cp -f $tmpfileUHD $savepathUHD/$date@${title}-${word}_UHD.jpg
	chown $username:users $savepathUHD/$date@${title}-${word}_UHD.jpg
	synoindex -a $savepathUHD/$date@${title}-${word}_UHD.jpg
fi
rm -rf /tmp/*_bing.jpg
rm -rf /tmp/*_bingUHD.jpg
