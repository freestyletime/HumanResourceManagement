from app import create_app, db
from model import Administrator, DEmployee, DPost, DPostLevel, DDepartment, DSalary, DSalaryLevel, DAttendance, DAttendanceStatistic
from flask_script import Manager, Shell, Server
from flask_migrate import Migrate, MigrateCommand


# 初始化数据库表
def make_shell_context():
    return dict(app=app, db=db, Admin=Administrator, DEmployee=DEmployee, DPost=DPost, DPostLevel=DPostLevel,
        DDepartment=DDepartment, DSalary=DSalary, DSalaryLevel=DSalaryLevel, DAttendance=DAttendance, DAttendanceStatistic=DAttendanceStatistic)


# app 初始化
app = create_app()
# 命令行工具管理器初始化
manager = Manager(app)
# 数据库迁移工具初始化
migrate = Migrate(app, db)
# 添加 db 命令，并与 MigrateCommand 绑定
manager.add_command('db', MigrateCommand)
# 当导入的时候可以直接使用app db, user
manager.add_command("shell", Shell(make_context=make_shell_context))
# 启动服务器命令
manager.add_command('runserver', Server(host='0.0.0.0', port=80, use_debugger=True, threaded=True))


@manager.command
def deploy():
    # 插入公司基础数据
    Administrator.init_database()
    # 插入考勤数据
    DAttendance.init_attendance()
    # 按月统计考勤数据
    DAttendanceStatistic.init_attendance_static()
    # 按月统计薪酬数据
    DSalary.init_salary()


if __name__ == '__main__':
    manager.run()


