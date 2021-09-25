# 接口数据模型模块
from typing import Optional, Dict, Any

from flask import Response
from constants import const
from dataclasses import dataclass
from dataclasses_json import dataclass_json

''' 
    基本数据模型
    1.status 整数型 / 0 表示请求成功 / 1表示请求失败
    2.msg 字符串 / 表示请求返回的信息或业务失败消息
    3.data jsonArray / 请求成功后返回的数据 / 没有数据时返回"[]"
    4.code 字符串 / 表示请求失败后返回的业务错误类型，通常配合msg使用

    such as : {"status" : 0, "msg" : "请求成功"}
'''


# 基本接口返回对象
@dataclass_json
@dataclass
class HResponse:
    status: int
    msg: str
    data: list
    code: str

    def __init__(self, status, msg, code, data=None):
        self.status = status
        self.msg = msg
        self.code = code
        self.data = data

    def __del__(self):
        pass

    # 返回响应数据
    def make_response(self):
        return Response(response=self.to_json(), content_type=const.MIMETYPE)


@dataclass_json
@dataclass
class Message:
    msg: str

    def __init__(self, msg):
        self.msg = msg


@dataclass_json
@dataclass
class Employee:
    eid: int
    # 员工姓名
    name: str
    # 性别 0：女/1：男
    gender: int
    # 生日
    birthday: str
    # 籍贯
    hometown: str
    # 手机号码
    phone: str
    # 邮箱地址
    email: str
    # 毕业院校
    school: str
    # 教育背景 1：高中及以下/2：大专/3：本科/4：硕士/5: 博士及以上
    education: int
    # 入职时间
    entry_time: str
    # 离职时间
    leave_time: str
    # 员工基本工资
    salary: int
    # 员工状态 1: 在职/2: 离职
    status: int
    # 雇员描述
    description: str

    def __init__(self, eid, name, gender, birthday, hometown, phone, email, school, education, entry_time, leave_time, salary, status, description):
        self.eid = eid
        self.name = name
        self.gender = gender
        self.birthday = birthday
        self.hometown = hometown
        self.phone = phone
        self.email = email
        self.school = school
        self.education = education
        self.entry_time = entry_time
        self.leave_time = leave_time
        self.salary = salary
        self.status = status
        self.description = description


@dataclass_json
@dataclass
class Post:
    pid: int
    # 职位名称
    post_name: str
    # 职位描述
    description: str
    # 职位状态 1: 启动/2: 弃用
    status: int

    def __init__(self, pid, post_name, description, status):
        self.pid = pid
        self.post_name = post_name
        self.description = description
        self.status = status


@dataclass_json
@dataclass
class PostLevel:
    # 职级ID
    lid: str
    # 职级
    level: int
    # 职级名称
    nick_name: str
    # 职级描述
    description: str

    def __init__(self, lid, level, nick_name, description):
        self.lid = lid
        self.level = level
        self.nick_name = nick_name
        self.description = description


@dataclass_json
@dataclass
class Department:
    # 部门ID
    did: int
    # 部门名称
    department_name: str
    # 部门描述
    description: str
    # 部门状态 1: 启动/2: 弃用
    status: int

    def __init__(self, did, department_name, description, status):
        self.did = did
        self.department_name = department_name
        self.description = description
        self.status = status


@dataclass_json
@dataclass
class Salary:
    # 员工id
    eid: int
    # 对应考勤id
    aid: int
    # 薪酬日期
    date: str
    # 员工基本工资
    salary: str
    # 扣款
    divide: str
    # 应得底薪 (基本工资-扣款)
    real_salary: str
    # 社保 (具体五险一金细节由前端公式计算)
    insurance: str
    # 个税
    tax: str
    # 税前工资 (应得底薪 + 补贴 - 社保)
    pre_tax_salary: str
    # 税后工资 (税前工资 - 个税)
    post_tax_salary: str

    def __init__(self, eid, aid, date, salary, divide, real_salary, insurance, tax, pre_tax_salary, post_tax_salary):
        self.eid = eid
        self.aid = aid
        self.date = date
        self.salary = salary
        self.divide = divide
        self.real_salary = real_salary
        self.insurance = insurance
        self.tax = tax
        self.pre_tax_salary = pre_tax_salary
        self.post_tax_salary = post_tax_salary


@dataclass_json
@dataclass
class SalaryLevel:
    # 奖金
    bonus: int
    # 绩效
    extra_subsidy: int
    # 职级补贴
    level_subsidy: int
    # 话费补贴
    phone_subsidy: int
    # 交通补贴
    vehicle_subsidy: int
    # 饭补
    lunch_subsidy: int
    # 住房补贴
    house_subsidy: int

    def __init__(self, bonus, extra_subsidy, level_subsidy, phone_subsidy, vehicle_subsidy, lunch_subsidy, house_subsidy):
        self.bonus = bonus
        self.extra_subsidy = extra_subsidy
        self.level_subsidy = level_subsidy
        self.phone_subsidy = phone_subsidy
        self.vehicle_subsidy = vehicle_subsidy
        self.lunch_subsidy = lunch_subsidy
        self.house_subsidy = house_subsidy


@dataclass_json
@dataclass
class Attendance:
    # 日期
    date: str
    # 上班打卡时间
    time_start: str
    # 下班打卡时间
    time_end: str

    def __init__(self, date, time_start, time_end):
        self.date = date
        self.time_start = time_start
        self.time_end = time_end


@dataclass_json
@dataclass
class AttendanceStatistic:
    # 员工id
    eid: int
    # 考勤统计时间
    date: str
    # 应到天数
    day_work: str
    # 到岗天数
    day_in: str
    # 迟到天数
    day_late: str
    # 旷工天数
    day_out: str

    def __init__(self, eid, date, day_work, day_in, day_late, day_out):
        self.eid = eid
        self.date = date
        self.day_work = day_work
        self.day_in = day_in
        self.day_late = day_late
        self.day_out = day_out


@dataclass_json
@dataclass
class EmployeeBean:
    # 员工信息
    employee: Employee
    # 直属领导信息
    leader: Employee
    # 职位信息
    post: Post
    # 职级信息
    postLevel: PostLevel
    # 部门信息
    dept: Department
    # 父部门信息
    pdept: Department

    def __init__(self, employee, leader, post, postLevel, dept, pdept):
        self.employee = employee
        self.leader = leader
        self.post = post
        self.postLevel = postLevel
        self.dept = dept
        self.pdept = pdept


@dataclass_json
@dataclass
class DepartmentBean:
    # 部门信息
    dept: Department
    # 父部门信息
    pdept: Department
    # 部门人员信息
    employees: list

    def __init__(self, dept, pdept, employees):
        self.dept = dept
        self.pdept = pdept
        self.employees = employees


@dataclass_json
@dataclass
class PostBean:
    # 职位信息
    post: Post
    # 职位人员信息
    employees: list

    def __init__(self, post, employees):
        self.post = post
        self.employees = employees


@dataclass_json
@dataclass
class PostLevelBean:
    # 职级信息
    postLevel: PostLevel
    # 职位信息信息
    posts: list

    def __init__(self, postLevel, posts):
        self.postLevel = postLevel
        self.posts = posts


@dataclass_json
@dataclass
class SalaryEmployeeBean:
    # 职级
    lid: str
    # 员工信息
    employee: Employee
    # 工资数目
    count: int

    def __init__(self, lid, employee, count):
        self.lid = lid
        self.employee = employee
        self.count = count


@dataclass_json
@dataclass
class SalaryBean:
    # 补贴级别
    salaryLevel: SalaryLevel
    # 工资信息（支持按月查询）
    salarys: list

    def __init__(self, salaryLevel, salarys):
        self.salaryLevel = salaryLevel
        self.salarys = salarys


@dataclass_json
@dataclass
class AttendanceEmployeeBean:
    # 员工信息
    employee: Employee
    # 考勤打卡天数
    count: int

    def __init__(self, employee, count):
        self.employee = employee
        self.count = count


@dataclass_json
@dataclass
class AttendanceBean:
    # 员工信息
    employee: Employee
    # 考勤打卡明细
    attendances: list

    def __init__(self, employee, attendances):
        self.employee = employee
        self.attendances = attendances