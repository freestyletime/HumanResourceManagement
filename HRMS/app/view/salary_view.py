# 薪酬管理模块
from app import db
from flask import Blueprint, request

# Blueprint初始化
from app.view.bean import HResponse, SalaryEmployeeBean, Employee, SalaryBean, SalaryLevel, Salary
from constants import const
from model import DEmployee, DPost, DSalary, DSalaryLevel, DPostLevel

salary = Blueprint("salary", __name__, url_prefix="/salary")


# 控制器 用于搭建数据库和接口之前的桥梁
class SalaryController(object):
    @staticmethod
    def getAllSalaryEmployee():
        data = list()
        employees = DEmployee.query.filter(DEmployee.status == const.STATUS_WORK).all()
        if employees:
            for e in employees:
                tmp_emp = Employee(e.eid, e.name, e.gender, str(e.birthday), e.hometown, e.phone, e.email, e.school,
                    e.education, str(e.entry_time), str(e.leave_time), e.salary, e.status, e.description)
                p = DPost.query.get(e.pid)
                count = DSalary.query.filter(DSalary.eid == e.eid).count()
                data.append(SalaryEmployeeBean(p.lid, tmp_emp, count))
        else:
            return None

        return data

    @staticmethod
    def getDalary(id, lid):
        data = list()
        postLevel = DPostLevel.query.get(lid)
        salaryLevel = DSalaryLevel.query.get(postLevel.level)
        salarys = DSalary.query.filter(DSalary.eid == id).order_by(DSalary.date.desc()).all()
        tmp_sl = SalaryLevel(salaryLevel.bonus, salaryLevel.extra_subsidy, salaryLevel.level_subsidy,
            salaryLevel.phone_subsidy, salaryLevel.vehicle_subsidy, salaryLevel.lunch_subsidy,
            salaryLevel.house_subsidy)

        tmp_salarys = None
        if salarys:
            tmp_salarys = list()
            for s in salarys:
                tmp_salarys.append(Salary(s.eid, s.aid, str(s.date), str(s.salary), str(s.salary - s.real_salary), str(s.real_salary),
                    str(s.insurance), str(s.tax), str(s.pre_tax_salary), str(s.post_tax_salary)))

        data.append(SalaryBean(tmp_sl, tmp_salarys))
        return data


# 获取所有工资人员
@salary.route("/get_all_emp", methods=['POST'])
def getAllSalaryEmployee():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=SalaryController.getAllSalaryEmployee(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取工资详细列表
@salary.route("/get_all", methods=['POST'])
def getAllSalary():
    id = request.form[const.EMP_ID]
    lid = request.form[const.POST_LID]

    if id and lid:
        salary = SalaryController.getDalary(id, lid)
        if salary:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=salary, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_NOT_EXIST,
                code=const.CODE_FAILURE_EMP_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()
