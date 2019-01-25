#!/usr/bin/env python
# -*- coding: utf8 -*-

import os
from utils.Bing_Utils import download_bing_pic, change_synology_conf


if __name__ == '__main__':
    pic_save_path = "/WHERE/IS/YOUR/PATH/bing.jpg"
    synology_conf = "/etc/synoinfo.conf"
    info_url = "http://bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
    source_url = "https://cn.bing.com"
    pic_info_url = "https://www4.bing.com/cnhp/coverstory"

    download_bing_pic(info_url, source_url, pic_save_path)
    change_synology_conf(pic_info_url, synology_conf)
    os.system("ln -sf " + pic_save_path + " /usr/syno/etc/login_background_hd.jpg")
    os.system("ln -sf " + pic_save_path + " /usr/syno/etc/login_background.jpg")
    os.system("ln -sf " + pic_save_path + " /usr/syno/etc/preference/admin/wallpaper")
