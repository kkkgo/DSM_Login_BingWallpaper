#!/usr/bin/env python
# -*- coding: utf8 -*-

import requests
import json
import sys
import configobj
from urllib.parse import urljoin

headers = {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) "
                  "Version/12.0.2 Safari/605.1.15",
    "Accept-Language": "zh-cn",
    "Accept-Encoding": "gzip, deflate",
    # "Host": "bing.com"
}


def download_bing_pic(info_url, source_url, pic_save_path):
    # true = True
    # false = False
    real_source_url = ""
    dict_source = json.loads(requests.get(info_url, headers=headers).__dict__["_content"].decode())
    if dict_source["images"]:
        for each_dict in dict_source["images"]:
            if "url" in each_dict.keys():
                real_source_url = urljoin(source_url, each_dict["url"])
    if not real_source_url:
        print("获取真实图片地址失败！")
        sys.exit(1)
    else:
        try:
            pic = requests.get(real_source_url, headers=headers)
            with open(pic_save_path, "wb") as picfile:
                picfile.write(pic.content)
        except Exception as e:
            print("下载Bing图片失败！")
            print(str(e))
            sys.exit(2)
    print("壁纸下载成功，位于 " + pic_save_path)


def change_synology_conf(pic_info_url, synology_conf):
    conf = configobj.ConfigObj(synology_conf, encoding="utf8")
    conf["login_background_customize"] = "yes"
    conf["login_welcome_title"] = "Synology"
    conf["login_welcome_msg"] = "欢迎使用"
    dict_source = json.loads(requests.get(pic_info_url, headers=headers).__dict__["_content"].decode())
    if dict_source["title"]:
        conf["login_welcome_title"] = dict_source["title"]
    if dict_source["attribute"]:
        conf["login_welcome_msg"] = dict_source["attribute"]
    conf.write()
    print("配置修改成功，刷新页面即可展示Bing壁纸。")
