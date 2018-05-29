save="/volume1/web/bing.jpg"
wget "https://cn.bing.com/$(curl -s "http://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"|grep -Po 'url[" :]+\K[^"]+')" -qO $save
if !(cat /etc/synoinfo.conf|grep login_background_customize) then
echo "login_background_customize=1">>/etc/synoinfo.conf
fi
if !(cat /etc/synoinfo.conf|grep login_welcome_title) then
echo "login_welcome_title=1">>/etc/synoinfo.conf
echo "login_welcome_msg=1">>/etc/synoinfo.conf
fi
sed -i s/login_background_customize=.*/login_background_customize=\"yes\"/g /etc/synoinfo.conf
ln -sf $save /usr/syno/etc/login_background_hd.jpg
ln -sf $save /usr/syno/etc/login_background.jpg
story=$(curl -s https://www4.bing.com/cnhp/coverstory)
title=$(echo $story|grep -Po 'title[" :]+\K[^"]+')
attribute=$(echo $story|grep -Po 'attribute[" :]+\K[^"]+')
sed -i s/login_welcome_title=.*/login_welcome_title=\"$title\"/g /etc/synoinfo.conf
sed -i s/login_welcome_msg=.*/login_welcome_msg=\"$attribute\"/g /etc/synoinfo.conf
#ln -sf $save /usr/syno/etc/preference/admin/wallpaper
