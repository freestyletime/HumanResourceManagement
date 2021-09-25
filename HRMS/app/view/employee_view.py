# 员工管理模块
import datetime
from app import db
from model import Administrator, DEmployee, DPost, DDepartment, DAttendance, DSalary, DPostLevel
from .bean import HResponse, Message, EmployeeBean, Employee, Post, PostLevel, Department
from constants import const
from flask import Blueprint, request
from pypinyin import lazy_pinyin

# Blueprint初始化
employee = Blueprint("employee", __name__, url_prefix="/employee")


# 控制器 用于搭建数据库和接口之前的桥梁
class EmployeeController(object):

    @staticmethod
    def getEmployeeBean(e):
        tmp_emp = Employee(e.eid, e.name, e.gender, str(e.birthday), e.hometown, e.phone, e.email, e.school,
            e.education, str(e.entry_time), str(e.leave_time), e.salary, e.status, e.description)
        p = DPost.query.get(e.pid)
        tmp_post = Post(p.pid, p.post_name, p.description, p.status)
        pl = DPostLevel.query.get(p.lid)
        tmp_post_level = PostLevel(pl.lid, pl.level, pl.nick_name, pl.description)
        d = DDepartment.query.get(e.did)
        tmp_dept = Department(d.did, d.department_name, d.description, d.status)
        tmp_leader = None
        tmp_pdept = None
        if e.peid != 0:
            leader = DEmployee.query.get(e.peid)
            tmp_leader = Employee(leader.eid, leader.name, leader.gender, str(leader.birthday), leader.hometown,
                leader.phone, leader.email, leader.school, leader.education, str(leader.entry_time),
                str(leader.leave_time), leader.salary, leader.status, leader.description)
        if d.pdid != 0:
            pd = DDepartment.query.get(d.pdid)
            tmp_pdept = Department(pd.did, pd.department_name, pd.description, pd.status)

        return EmployeeBean(tmp_emp, tmp_leader, tmp_post, tmp_post_level, tmp_dept, tmp_pdept)

    @staticmethod
    def getAdministrator(username):
        return Administrator.query.filter_by(username=username).first()

    @staticmethod
    def getStatistic():
        data = list()
        totalD = DDepartment.query.count()
        totalE = DEmployee.query.count()
        quitE = DEmployee.query.filter(DEmployee.status == const.STATUS_QUIT).count()
        workE = totalE - quitE
        totalA = DAttendance.query.count()
        totalS = DSalary.query.count()
        data.append(Message(msg='公司目前共有%d个部门，总员工数%d人，其中%d人在职，%d人离职，共有员工考勤数据%d条，员工工资数据%d条' % (
            totalD, totalE, workE, quitE, totalA, totalS)))
        return data

    @staticmethod
    def getQuitEmployees():
        data = list()
        employees = DEmployee.query.filter(DEmployee.status == const.STATUS_QUIT).all()
        if employees:
            for emp in employees:
                data.append(EmployeeController.getEmployeeBean(emp))
        else:
            return None
        return data

    @staticmethod
    def getEmployees(eid=None):
        data = list()

        if eid is None:
            employees = DEmployee.query.filter(DEmployee.status == const.STATUS_WORK).all()
        else:
            employees = DEmployee.query.get(eid)

        if isinstance(employees, list):
            for emp in employees:
                data.append(EmployeeController.getEmployeeBean(emp))
        else:
            if employees:
                data.append(EmployeeController.getEmployeeBean(employees))
            else:
                return None
        return data

    @staticmethod
    def getEmployeesByDid(did):
        if did:
            data = list()
            employees = DEmployee.query.filter(DEmployee.did == did, DEmployee.status == const.STATUS_WORK).all()
            if employees:
                for e in employees:
                    data.extend(EmployeeController.getEmployees(e.eid))
                return data
        return None

    @staticmethod
    def getEmployeesByPid(pid):
        if pid:
            data = list()
            employees = DEmployee.query.filter(DEmployee.pid == pid, DEmployee.status == const.STATUS_WORK).all()
            if employees:
                for e in employees:
                    data.extend(EmployeeController.getEmployees(e.eid))
                return data
        return None

    @staticmethod
    def addEmployee(name, gender, year, month, day, school, hometown, phone, education, salary, description, pid, did, peid):
        # 自动生成email地址
        def getEmailAddress(content):
            cstrs = lazy_pinyin(content)
            email: str = ''
            if len(cstrs) > 1:
                sub_cstrs = cstrs[:(len(cstrs) - 1)]
                last_letter = cstrs[len(cstrs) - 1]
                for s in sub_cstrs:
                    email += s[0]
                email += last_letter
                for index in range(100):
                    count = DEmployee.query.filter(DEmployee.email.startswith(email)).count()
                    if count > 0:
                        email += str(count)
                        break

                email += const.EMAIL_SUFFIX
            else:
                email = cstrs[0] + const.EMAIL_SUFFIX

            return email

        try:
            # 检查职位是否存在/上级是否存在/部门是否存在
            post = DPost.query.get(pid)
            leader = DEmployee.query.get(peid)
            department = DDepartment.query.get(did)
            if post and leader and department:
                birthday = datetime.date(int(year), int(month), int(day))
                entry_time = datetime.date.today()
                leave_time = datetime.date(1, 1, 1)
                employee = DEmployee(name=name, gender=int(gender), birthday=birthday, hometown=hometown,
                    phone=phone, school=school, education=int(education), salary=int(salary), entry_time=entry_time,
                    leave_time=leave_time, status=const.STATUS_WORK, description=description,
                    email=getEmailAddress(name),
                    pid=int(pid), did=int(did), peid=int(peid))

                db.session.add(employee)
                db.session.commit()
                return True
            return False
        except Exception as e:
            print(e)
            return False

    @staticmethod
    def quitEmployee(id):
        employee = DEmployee.query.get(id)
        if employee:
            peid = employee.peid
            # 1. 更新状态和离职时间
            employee.status = const.STATUS_QUIT
            employee.leave_time = datetime.date.today()
            db.session.commit()
            # 2. 将下级人员移动到上级节点
            employees = DEmployee.query.filter(DEmployee.peid == id, DEmployee.status == const.STATUS_WORK).all()
            if employees:
                for e in employees:
                    e.peid = peid
                db.session.commit()
            return True
        else:
            return False

    @staticmethod
    def recoveryEmployee(id):
        # 向上搜索
        def getCurrentPeid(peid):
            tmp_leader = DEmployee.query.get(peid)
            if tmp_leader.status == const.STATUS_WORK:
                return peid
            else:
                return getCurrentPeid(tmp_leader.peid)

        employee = DEmployee.query.get(id)
        if employee:
            employee.status = const.STATUS_WORK
            employee.entry_time = datetime.date.today()
            employee.peid = getCurrentPeid(employee.peid)
            db.session.commit()
            return True
        else:
            return False

    @staticmethod
    def changeEmployee(eid, salary, pid, did, peid):
        employee = DEmployee.query.get(eid)
        if employee:
            employee.salary = int(salary)
            employee.pid = int(pid)
            employee.did = int(did)
            employee.peid = int(peid)
            db.session.commit()
            return True
        else:
            return False


# 管理员的特殊权限接口  START #
# # 登陆接口
@employee.route("/login", methods=['POST'])
def login():
    # 从管理员表里获取用户名密码
    username = request.form[const.LOGIN_USERNAME]
    password = request.form[const.LOGIN_PASSWORD]
    if username and password:
        administrator = EmployeeController.getAdministrator(username)
        if administrator:
            # 用户名存在
            if administrator.password != password:
                # 登陆密码错误
                res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_PWD_WRONG, code=const.CODE_PWD_WRONG)
                return res.make_response()
        else:
            # 用户名不存在
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_USER_NOT_EXIST,
                code=const.CODE_USER_NOT_EXIST)
            return res.make_response()
    else:
        # 关键信息不能为空
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()
    # 登陆成功 在客户端设置用户超时时间
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
    return res.make_response()
# 管理员的特殊权限接口  END #


# 获取公告
@employee.route("/banner", methods=['POST'])
def getStatistic():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=EmployeeController.getStatistic(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 添加员工
@employee.route("/add", methods=['POST'])
def addEmployee():
    name = request.form[const.EMP_NAME]
    gender = request.form[const.EMP_GENDER]
    year = request.form[const.EMP_YEAR]
    month = request.form[const.EMP_MONTH]
    day = request.form[const.EMP_DAY]
    hometown = request.form[const.EMP_HOMETOWN]
    phone = request.form[const.EMP_PHONE]
    school = request.form[const.EMP_SCHOOL]
    education = request.form[const.EMP_EDUCATION]
    salary = request.form[const.EMP_SALARY]
    description = request.form[const.DESCRIPTION]
    pid = request.form[const.POST_ID]
    did = request.form[const.DPT_ID]
    peid = request.form[const.EMP_PEID]
    if name and gender and year and month and day and school and hometown and phone and education and salary and pid and did and peid:
        if EmployeeController.addEmployee(name, gender, year, month, day, school, hometown, phone, education, salary,
                description, pid, did, peid):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_ADD, code=const.CODE_FAILURE_EMP_ADD)
            return res.make_response()
    else:
        # 关键信息不能为空
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 员工离职
@employee.route("/quit", methods=['POST'])
def quitEmployee():
    id = request.form[const.EMP_ID]
    if id:
        if EmployeeController.quitEmployee(id):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_QUIT, code=const.CODE_FAILURE_EMP_QUIT)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 员工复职
@employee.route("/recovery", methods=['POST'])
def recoveryEmployee():
    id = request.form[const.EMP_ID]
    if id:
        if EmployeeController.recoveryEmployee(id):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_RECOVERY, code=const.CODE_FAILURE_EMP_RECOVERY)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 员工异动
@employee.route("/change", methods=['POST'])
def changeEmployee():
    id = request.form[const.EMP_ID]
    salary = request.form[const.EMP_SALARY]
    pid = request.form[const.POST_ID]
    did = request.form[const.DPT_ID]
    peid = request.form[const.EMP_PEID]

    if id and salary and pid and did and peid:
        if EmployeeController.changeEmployee(id, salary, pid, did, peid):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_CHANGE, code=const.CODE_FAILURE_EMP_CHANGE)
            return res.make_response()
    else:
        # 关键信息不能为空
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 获取所有员工信息
@employee.route("/get_all", methods=['POST'])
def getAllEmployee():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=EmployeeController.getEmployees(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取所有离职员工信息
@employee.route("/get_all_quit", methods=['POST'])
def getAllQuitEmployee():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=EmployeeController.getQuitEmployees(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 根据员工ID获取员工信息
@employee.route("/get", methods=['POST'])
def getEmployee():
    id = request.form[const.EMP_ID]
    if id:
        employee = EmployeeController.getEmployees(id)
        if employee:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=employee, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_NOT_EXIST,
                code=const.CODE_FAILURE_EMP_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()
