# 初始化模块
from config import Config
from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# 数据库操作对象
db = SQLAlchemy()


# 创建app
def create_app():
    # flask操作对象
    app = Flask(__name__)
    # 通过配置文件读取并应用配置
    app.config.from_object(Config)
    # 初始化数据库
    db.init_app(app)

    # 员工管理子系统
    from app.view import employee
    # 职位管理子系统
    from app.view import post
    # 部门管理子系统
    from app.view import department
    # 工资管理子系统
    from app.view import salary
    # 考勤管理子系统
    from app.view import attendance
    # 统一对外接口蓝本
    app.register_blueprint(employee)
    app.register_blueprint(post)
    app.register_blueprint(department)
    app.register_blueprint(salary)
    app.register_blueprint(attendance)

    return app
