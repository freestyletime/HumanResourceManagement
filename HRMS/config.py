# 系统环境配置模块
import os

# 项目所在路径
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    """环境配置"""
    DEBUG = True
    # 每次请求结束后自动commit
    SQLALCHEMY_COMMIT_ON_TEARDOWN = True
    # 设置sqlalchemy自动更跟踪数据库
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    SQLALCHEMY_COMMIT_TEARDOWN = True
    # SQLALCHEMY_ECHO = True
    # 数据库路径
    SQLALCHEMY_DATABASE_URI = 'sqlite:///%s' % os.path.join(basedir, 'hrms.db')
    # 私钥
    SECRET_KEY = 'christianhrms'
    # 管理员用户名
    ADMIN_USERNAME = 'admin'
    # 管理员密码
    ADMIN_PASSWORD = '3344'
    # 每页展示数
    HTTP_RESPONSE_PAGE = 20
