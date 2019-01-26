# 这个路径在 6.1.7-15284 Update 3不可用，请修改为可访问路径，example /volume1/wallpaper/
save="/usr/syno/etc/bing.jpg"
#如果需要收集保存每日美图可去掉注释
#保存路径path，请设置自己的文件夹，在FileStation里面右键文件夹属性可以看到路径
#path="/volume1/wallpaper/"
#name="$(date +'%Y%m%d')_bing.jpg"
#save=$path$name
wget "https://bing.com$(curl -s "https://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"|sed 's/.\+"url"[:" ]\+//g'|sed 's/".\+//g')" -qO $save
story=$(curl -s https://www4.bing.com/cnhp/coverstory)
sed -i s/login_background_customize=.*//g /etc/synoinfo.conf
echo login_background_customize=\"yes\">>/etc/synoinfo.conf
ln -sf $save /usr/syno/etc/login_background_hd.jpg
ln -sf $save /usr/syno/etc/login_background.jpg
if (echo $story|grep attribute) then
sed -i s/login_welcome_title=.*//g /etc/synoinfo.conf
echo "login_welcome_title=\"$(echo $story|sed 's/.\+"title"[: "]\+//g'|sed 's/",".\+//g')\"">>/etc/synoinfo.conf
sed -i s/login_welcome_msg=.*//g /etc/synoinfo.conf
echo "login_welcome_msg=\"$(echo $story|sed 's/.\+"attribute"[: "]\+//g'|sed 's/",".\+//g')\"">>/etc/synoinfo.conf
fi
#设置用户桌面背景
#ln -sf $save /usr/syno/etc/preference/admin/wallpaper
