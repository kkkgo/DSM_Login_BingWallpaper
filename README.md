# DSM_Login_BingWallpaper
把脚本加入群晖DSM的计划任务（请选择root用户）里面即可自动更换登录界面的背景为bing今日美图，并且替换欢迎信息为美图简介.   
Add the script to the scheduled task of Synology DSM (please select the root user) to automatically change the background of the login interface to Bing Today's wallpaper, and replace the welcome message with wallpaper's introduction.
![scheduled](https://i.loli.net/2019/01/11/5c378d53206a0.png)
![login](https://s2.loli.net/2022/08/23/AGm1wq3lUskbYTL.png)
Test for DSM5.x,DSM6.x. DSM 7.x 
```sh
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
```
![save](https://s2.loli.net/2022/08/23/YRUFpG4kK1iV7dy.png)
More info ：https://03k.org/dsm-bing.html    
