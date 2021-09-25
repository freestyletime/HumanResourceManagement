# 数据库表结构模块
import os
import datetime
import calendar
from app import db
from flask import current_app
from constants import WorkDays
from sqlalchemy import extract


# 管理员表
class Administrator(db.Model):
    __tablename__ = 'administrator'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(50), nullable=False)

    def __repr__(self):
        return '<User %s>' % self.username

    def __str__(self):
        return self.username

    @staticmethod
    def init_database():
        admin = Administrator(username=current_app.config['ADMIN_USERNAME'], password=current_app.config['ADMIN_PASSWORD'])
        db.session.add(admin)
        db.session.commit()

        sql_list = []
        basedir = os.path.abspath(os.path.dirname(__file__))
        print('### ### ### ### ### ### ### ### ### ###')
        print('### 初始化数据库')
        # 读取并过滤sql
        with open(u'%s' % os.path.join(basedir, 'init.sql'), 'r+', encoding="utf-8") as f:
            for each_line in f.readlines():
                if each_line and len(each_line) != 0 and not each_line.startswith('--'):
                    sql_list.append(each_line)
        size_one = len(sql_list)
        print('### 插入%d 条部门/职位/职级/津贴数据' % size_one)
        with open(u'%s' % os.path.join(basedir, 'init_employee.sql'), 'r+', encoding="utf-8") as f:
            for each_line in f.readlines():
                if each_line and len(each_line) != 0 and not each_line.startswith('--'):
                    sql_list.append(each_line)
        size_two = len(sql_list) - size_one
        print('### 插入%d 条基本人员信息数据' % size_two)
        # with open(u'%s' % os.path.join(basedir, 'init_attendance.sql'), 'r+', encoding="utf-8") as f:
        #     for each_line in f.readlines():
        #         if each_line and len(each_line) != 0 and not each_line.startswith('--'):
        #             sql_list.append(each_line)
        # size_three = len(sql_list) - size_one - size_two
        # print('### 插入%d 条基本人员考勤数据' % size_three)

        # 执行sql
        for sql in sql_list:
            db.session.execute(sql)


# 员工表
class DEmployee(db.Model):
    __tablename__ = 'employee'
    # 员工ID
    eid = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 员工姓名
    name = db.Column(db.String(20), nullable=False)
    # 性别 0：女/1：男
    gender = db.Column(db.Integer, nullable=False)
    # 生日
    birthday = db.Column(db.Date, nullable=False)
    # 籍贯
    hometown = db.Column(db.String(50), nullable=False)
    # 手机号码
    phone = db.Column(db.String(20), unique=True, nullable=False)
    # 邮箱地址
    email = db.Column(db.String(50), unique=True, nullable=False)
    # 毕业院校
    school = db.Column(db.String(50), nullable=False)
    # 教育背景 1：高中及以下/2：大专/3：本科/4：硕士/5: 博士及以上
    education = db.Column(db.Integer, nullable=False)
    # 入职时间
    entry_time = db.Column(db.Date, nullable=False)
    # 离职时间
    leave_time = db.Column(db.Date, server_default='0001-01-01')
    # 员工基本工资
    salary = db.Column(db.Integer, nullable=False)
    # 员工状态 1: 在职/2: 离职
    status = db.Column(db.Integer, nullable=False, server_default='1')
    # 员工描述
    description = db.Column(db.String(200))
    # 职位ID (外键)
    pid = db.Column(db.Integer, nullable=False)
    # 部门ID (外键)
    did = db.Column(db.Integer, nullable=False)
    # 直接上级员工ID (外键)
    peid = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<employee #id:%d #name:%s>' % (self.eid, self.name)

    def __str__(self):
        return '#id:%d #name:%s' % (self.eid, self.name)


# 职位表
class DPost(db.Model):
    __tablename__ = 'post'
    # 职位ID
    pid = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 职位名称
    post_name = db.Column(db.String(20), unique=True, nullable=False)
    # 职位描述
    description = db.Column(db.String(200))
    # 职级ID (外键)
    lid = db.Column(db.String(10), nullable=False)
    # 职位状态 1: 启用/2: 停用
    status = db.Column(db.Integer, nullable=False, server_default='1')

    # 设置与职员的一对多关系
    # employee = db.relationship('DEmployee', backref='post', lazy='dynamic')

    def __repr__(self):
        return '<post #id:%d #name:%s>' % (self.pid, self.post_name)

    def __str__(self):
        return '#id:%d #name:%s' % (self.pid, self.post_name)


# 职级表
class DPostLevel(db.Model):
    __tablename__ = 'post_level'
    # 职级ID
    lid = db.Column(db.String(10), primary_key=True)
    # 职级
    level = db.Column(db.Integer, unique=True, nullable=False)
    # 职级名称
    nick_name = db.Column(db.String(20), unique=True, nullable=False)
    # 职级描述
    description = db.Column(db.String(200))

    # 设置与职位的一对多关系
    # post = db.relationship('DPost', backref='post_level', lazy='dynamic')

    def __repr__(self):
        return '<post_level #id:%s #name:%s>' % (self.lid, self.nick_name)

    def __str__(self):
        return '#id:%s #name:%s' % (self.lid, self.nick_name)


# 部门表
class DDepartment(db.Model):
    __tablename__ = 'department'
    # 部门ID
    did = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 部门名称
    department_name = db.Column(db.String(50), unique=True, nullable=False)
    # 部门描述
    description = db.Column(db.String(200))
    # 父部门ID (外键)
    pdid = db.Column(db.Integer, nullable=False)
    # 部门状态 1: 启用/2: 停用
    status = db.Column(db.Integer, nullable=False, server_default='1')

    def __repr__(self):
        return '<department #id:%d #name:%s>' % (self.did, self.department_name)

    def __str__(self):
        return '#id:%d #name:%s' % (self.did, self.department_name)


# 工资记录表 (月底最后一天的个人财务总结)
class DSalary(db.Model):
    __tablename__ = 'salary'
    # 记录ID
    id = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 薪酬日期
    date = db.Column(db.Date, nullable=False)
    # 员工基本工资
    salary = db.Column(db.Integer, nullable=False)
    # 应得底薪 (基本工资-扣款)
    real_salary = db.Column(db.Integer, nullable=False)
    # 社保 (具体五险一金细节由前端公式计算)
    insurance = db.Column(db.Integer, nullable=False)
    # 个税
    tax = db.Column(db.Integer, nullable=False)
    # 税前工资 (应得底薪 + 补贴 - 社保)
    pre_tax_salary = db.Column(db.Integer, nullable=False)
    # 税后工资 (税前工资 - 个税)
    post_tax_salary = db.Column(db.Integer, nullable=False)
    # 员工ID (外键)
    eid = db.Column(db.Integer, nullable=False)
    # 职级 (外键 与职级表中的level相对应 方便查询补贴明细和计算补贴总额)
    level = db.Column(db.Integer, nullable=False)
    # 考勤统计ID (外键 方便查询考勤情况)
    aid = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<salary #id:%d>' % self.id

    def __str__(self):
        return '#id:%d' % self.did

    @staticmethod
    def init_salary():
        # 计算个税及五险一金(需要跟移动端保持一致)
        def salary_calculate(opt_salary):
            personal_income_taxes = 0
            if opt_salary > 5000:
                taxable_salary = opt_salary - 5000 - opt_salary * 0.22
                if taxable_salary <= 0:
                    personal_income_taxes = 0
                elif 0 < taxable_salary <= 3000:
                    personal_income_taxes = taxable_salary * 0.03 - 0
                elif 3000 < taxable_salary <= 12000:
                    personal_income_taxes = taxable_salary * 0.1 - 210
                elif 12000 < taxable_salary <= 25000:
                    personal_income_taxes = taxable_salary * 0.2 - 1410
                elif 25000 < taxable_salary <= 35000:
                    personal_income_taxes = taxable_salary * 0.25 - 2660
                elif 35000 < taxable_salary <= 55000:
                    personal_income_taxes = taxable_salary * 0.3 - 4410
                elif 55000 < taxable_salary <= 80000:
                    personal_income_taxes = taxable_salary * 0.35 - 7160
                elif taxable_salary > 80000:
                    personal_income_taxes = taxable_salary * 0.45 - 15160

            # 个税(保留一位小数)
            real_tax = round(personal_income_taxes, 1)
            # 五险一金(22%的税率)
            five_one_gold = opt_salary * 0.22
            # 实发工资
            net_pay = opt_salary - real_tax - five_one_gold
            return net_pay, five_one_gold, real_tax
        # 获取前8个人
        # employees = DEmployee.query.filter(DEmployee.eid.in_([1, 2, 3, 4, 5, 6, 7, 8])).all()
        employees = DEmployee.query.filter().all()
        for employee in employees:
            statistics = DAttendanceStatistic.query.filter(DAttendanceStatistic.eid == employee.eid).order_by(DAttendanceStatistic.date).all()
            post = DPost.query.filter(DPost.pid == employee.pid).first()
            post_level = DPostLevel.query.filter(DPostLevel.lid == post.lid).first()
            salary_level = DSalaryLevel.query.filter(DSalaryLevel.level == post_level.level).first()
            # 每月固定所在职级补贴总额
            total_allowance = salary_level.bonus + salary_level.extra_subsidy + salary_level.level_subsidy + salary_level.phone_subsidy + salary_level.vehicle_subsidy + salary_level.lunch_subsidy + salary_level.house_subsidy
            salary = employee.salary
            print('### %d 号员工%s 插入%d 条薪酬数据' % (employee.eid, employee.name, len(statistics)))
            for statistic in statistics:
                # 整体工资计算
                real_salary = salary
                # 迟到一次扣 20；旷工一次扣500
                if statistic.day_work != statistic.day_in:
                    deduction = (statistic.day_late*20) + (statistic.day_out*500)
                    real_salary = salary - deduction

                after_real_salary, insurance, tax = salary_calculate(real_salary)
                # 税前工资
                pre_tax_salary = real_salary + total_allowance - insurance
                # 税后工资
                post_tax_salary = pre_tax_salary - tax
                tmp_salary = DSalary(date=statistic.date, salary=salary, real_salary=real_salary, insurance=insurance, tax=tax,
                                pre_tax_salary=pre_tax_salary, post_tax_salary=post_tax_salary, eid=employee.eid,
                                level=salary_level.level, aid=statistic.id)
                db.session.add(tmp_salary)
            db.session.commit()

        print('### 人事管理信息系统数据库初始化成功')
        print('### ### ### ### ### ### ### ### ### ###')


# 职级补贴等级表
class DSalaryLevel(db.Model):
    __tablename__ = 'salary_level'
    # 职级 (与职级表中的level相对应)
    level = db.Column(db.Integer, primary_key=True)
    # 奖金
    bonus = db.Column(db.Integer, nullable=False)
    # 绩效
    extra_subsidy = db.Column(db.Integer, nullable=False)
    # 等级补贴
    level_subsidy = db.Column(db.Integer, nullable=False)
    # 话费补贴
    phone_subsidy = db.Column(db.Integer, nullable=False)
    # 交通补贴
    vehicle_subsidy = db.Column(db.Integer, nullable=False)
    # 饭补
    lunch_subsidy = db.Column(db.Integer, nullable=False)
    # 住房补贴
    house_subsidy = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<salary_level #level:%d>' % self.level

    def __str__(self):
        return '#level:%d' % self.level


# 考勤表
class DAttendance(db.Model):
    __tablename__ = 'attendance'
    # 记录ID
    id = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 上班打卡时间
    time_start = db.Column(db.DateTime)
    # 下班打卡时间
    time_end = db.Column(db.DateTime)
    # 员工ID (外键)
    eid = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<attendance #id:%d #eid:%d>' % (self.id, self.eid)

    def __str__(self):
        return '#id:%d #eid:%d' % (self.id, self.eid)

    @staticmethod
    def init_attendance():
        # 获取前8个人
        # employees = DEmployee.query.filter(DEmployee.eid.in_([1, 2, 3, 4, 5, 6, 7, 8])).all()
        employees = DEmployee.query.filter().all()
        for employee in employees:
            start_date = datetime.date(employee.entry_time.year, employee.entry_time.month, employee.entry_time.day)
            end_date = datetime.date.today()
            work = WorkDays(start_date, end_date)
            print('### %d 号员工%s 插入%d 条考勤数据' % (employee.eid, employee.name, work.daysCount()))
            # 获取每一个工作日期 然后拼装数据后插入数据库
            for date in work.workDays():
                up_work_time = datetime.datetime(date.year, date.month, date.day, 8, 59, 0).replace(microsecond=0)
                down_work_time = datetime.datetime(date.year, date.month, date.day, 18, 1, 0).replace(microsecond=0)
                attendance = DAttendance(time_start=up_work_time, time_end=down_work_time, eid=employee.eid)
                db.session.add(attendance)
            db.session.commit()


# 考勤记录表 (月底最后一天对考勤记录表进行跑批总结得出)
class DAttendanceStatistic(db.Model):
    __tablename__ = 'attendance_statistic'
    # 记录ID
    id = db.Column(db.Integer, primary_key=True, index=True, autoincrement=True)
    # 统计日期
    date = db.Column(db.Date, nullable=False)
    # 应到天数
    day_work = db.Column(db.Integer, nullable=False)
    # 到岗天数
    day_in = db.Column(db.Integer, nullable=False)
    # 迟到天数
    day_late = db.Column(db.Integer, nullable=False)
    # 旷工天数
    day_out = db.Column(db.Integer, nullable=False)
    # 员工ID (外键)
    eid = db.Column(db.Integer, nullable=False)

    def __repr__(self):
        return '<attendanc_statistic #id:%d #eid:%d>' % (self.id, self.eid)

    def __str__(self):
        return '#id:%d #eid:%d' % (self.id, self.eid)

    @staticmethod
    def init_attendance_static():
        # 根据考勤数据计算考勤记录
        def create_attendance_static(eid, year, month):
            attemdances = DAttendance.query.filter(DAttendance.eid == eid,
                                                   extract('year', DAttendance.time_start) == year,
                                                   extract('month', DAttendance.time_start) == month
                                                   ).order_by(DAttendance.time_start).all()
            # 获取当前月的第一天的星期和当月总天数
            weekDay, monthCountDay = calendar.monthrange(year, month)
            # 获取当前月份第一天
            firstDay = datetime.date(year, month, day=1)
            # 获取当前月份最后一天
            lastDay = datetime.date(year, month, day=monthCountDay)
            # 计算每个月的工作日
            tmp_work = WorkDays(firstDay, lastDay)
            tmp_date_today = datetime.date.today()
            # 检查是否属于当月的最后一天
            if tmp_date_today.year == year and tmp_date_today.month == month and tmp_date_today < lastDay:
                return

            length = tmp_work.daysCount()
            tmp_date = datetime.date(year, month, attemdances[-1].time_start.day)
            late_time = 0
            # 计算迟到早退及矿工次数
            out_time = length - len(attemdances)
            for attemdance in attemdances:
                if attemdance.time_start.hour >= 9 or attemdance.time_end.hour < 18:
                    late_time += 1

            attendanc_statistic = DAttendanceStatistic(date=tmp_date, day_work=length,
                day_in=length - late_time - out_time,
                day_late=late_time, day_out=out_time, eid=employee.eid)
            db.session.add(attendanc_statistic)
            db.session.commit()

        # 获取前8个人
        # employees = DEmployee.query.filter(DEmployee.eid.in_([1, 2, 3, 4, 5, 6, 7, 8])).all()
        employees = DEmployee.query.filter().all()
        for employee in employees:
            # 统计每个月的情况 插入数据库
            date_today = datetime.date.today()
            start_year = employee.entry_time.year
            start_month = employee.entry_time.month
            end_year = date_today.year
            end_month = date_today.month
            # log
            start_date = datetime.date(employee.entry_time.year, employee.entry_time.month, employee.entry_time.day)
            work = WorkDays(start_date, date_today)
            print('### %d 号员工%s 计算并插入%d 周考勤统计数据' % (employee.eid, employee.name, work.weeksCount()))
            # 增加考勤数据
            while start_year <= end_year:
                if start_year == end_year:
                    while start_month <= end_month:
                        create_attendance_static(employee.eid, start_year, start_month)
                        start_month += 1
                    break
                elif start_month < 12:
                    create_attendance_static(employee.eid, start_year, start_month)
                    start_month += 1
                elif start_month == 12:
                    create_attendance_static(employee.eid, start_year, start_month)
                    start_month = 1
                    start_year += 1
