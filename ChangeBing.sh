wget "https://cn.bing.com/$(curl -s "http://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"|grep -Po 'url[" :]+\K[^"]+')" -qO /volume1/web/bing.jpg
ln -sf /volume1/web/bing.jpg /usr/syno/etc/login_background_hd.jpg
ln -sf /volume1/web/bing.jpg /usr/syno/etc/login_background.jpg
story=$(curl -s https://cn.bing.com/cnhp/coverstory)
title=$(echo $story|grep -Po 'title[" :]+\K[^"]+')
attribute=$(echo $story|grep -Po 'attribute[" :]+\K[^"]+')
sed -i s/login_welcome_title=.*/login_welcome_title=\"$title\"/g /etc/synoinfo.conf
sed -i s/login_welcome_msg=.*/login_welcome_msg=\"$attribute\"/g /etc/synoinfo.conf
