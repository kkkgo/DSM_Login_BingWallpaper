# 如需收集保存壁纸,请去掉下面注释,设置保存文件夹路径
# 在FileStation里面右键文件夹属性可以看到路径
# If you want to collect and save Wallpapers, 
# please remove the comment below and set the savepath.
# Right click the folder property in FileStation to see the path.

#savepath="/volume1/myshare/wallpaper"

# 如需下载4k分辨率,请设置res=4k
# 如需下载体积更大的4k以上分辨率的原始图片,请设置res=raw
# To download 4K resolution, set res = 4K
# To download a larger original picture, set res = raw

#res=4k

# 修改用户桌面壁纸,注释后会替换系统的wallpaper1
# 你需要清空浏览器缓存查看效果，仅在DSM7.x上测试.
# Modify user desktop wallpaper.Only test for DMS7.x.
# System "Wallpaper1" will replaced by remove the comment.
# You need to clear the browser cache to see the effect.

#desktop=yes

echo "[x]Collecting information..."
pic="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
if [ "$res" != "" ]
then pic="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&uhd=1&uhdwidth=3840&uhdheight=2160"
fi
pic=$(wget -t 5 --no-check-certificate -qO- $pic)
echo $pic|grep -q startdate||exit
link=$(echo https://www.bing.com$(echo $pic|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g'))
if [ "$res" == "raw" ]
then link=$(echo $link|grep -Eo "https://[-=?/._a-zA-Z0-9]+")
fi
date=$(echo $pic|grep -Eo '"startdate":"[0-9]+'|grep -Eo '[0-9]+'|head -1)
if [ "$date" == "" ]
then date=$(date +%Y%m%d)
fi
title=$(echo $pic|sed 's/.\+"title":"//g'|sed 's/".\+//g')
copyright=$(echo $pic|sed 's/.\+"copyright[:" ]\+//g'|sed 's/".\+//g')
keyword=$(echo $copyright|sed 's/, /-/g'|cut -d" " -f1|grep -Eo '[^()\\/:*?"<>]+'|head -1)
filename="bing_"$date"_"$keyword".jpg"
echo "Link:"$link
echo "Date:"$date
echo "Title:"$title
echo "Copyright:"$copyright
echo "Keyword:"$keyword
echo "Filename:"$filename

echo "[x]Downloading wallpaper..."
tmpfile=/tmp/$filename
wget -t 5 --no-check-certificate  $link -qO $tmpfile
ls -lah $tmpfile||exit

echo "[x]Copying wallpaper..."
if [ "$savepath" != "" ]
then cp $tmpfile "$savepath"
echo "Save:"$savepath
ls -lah "$savepath"|grep $date
cd "$savepath"
chmod 777 $filename
else echo "savepath is not set, skip copy."
fi

echo "[x]Setting welcome msg..."
sed -i s/login_welcome_title=.*//g /etc/synoinfo.conf
echo "login_welcome_title=\"$title\"">>/etc/synoinfo.conf
sed -i s/login_welcome_msg=.*//g /etc/synoinfo.conf
echo "login_welcome_msg=\"$copyright\"">>/etc/synoinfo.conf

echo "[x]Applying login wallpaper..."
sed -i s/login_background_customize=.*//g /etc/synoinfo.conf
echo "login_background_customize=\"yes\"">>/etc/synoinfo.conf
sed -i s/login_background_type=.*//g /etc/synoinfo.conf
echo "login_background_type=\"fromDS\"">>/etc/synoinfo.conf
rm -rf /usr/syno/etc/login_background*.jpg
cp -f $tmpfile /usr/syno/etc/login_background.jpg
ln -sf /usr/syno/etc/login_background.jpg /usr/syno/etc/login_background_hd.jpg

echo "[x]Clean..."
rm -f /tmp/bing_*.jpg

if [ "$desktop" == "yes" ]
then echo "[x]Applying user desktop wallpaper..."
mkdir -p /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/
mkdir -p /usr/syno/synoman/webman/resources/images/1x/default_wallpaper/
mkdir -p /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/
mkdir -p /usr/syno/synoman/webman/resources/images/default_wallpaper/
#7.0
cp -f /usr/syno/etc/login_background.jpg /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/1x/default_wallpaper/dsm7_01.jpg
#6.0
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/default_wallpaper.jpg
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_01.jpg
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default/1x/default_wallpaper/dsm6_02.jpg
#5.2
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default_wallpaper/default_wallpaper.jpg
#5.1
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default_wallpaper/01.jpg
ln -sf /usr/syno/synoman/webman/resources/images/2x/default_wallpaper/dsm7_01.jpg /usr/syno/synoman/webman/resources/images/default_wallpaper/02.jpg
fi