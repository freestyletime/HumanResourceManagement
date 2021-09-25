#!/bin/sh
# 删除上次数据库及相关部署文件
rm -rf ./migrations
rm ./hrms.db
# 杀死python进程
ps -ef | grep python | cut -c 9-15| xargs kill -s 9
# 重新创建数据库
python index.py db init
python index.py db migrate -m "init"
python index.py db upgrade
# 插入测试数据
python index.py deploy
# 启动服务器
python index.py runserver