# 部门管理模块
from app import db
from flask import Blueprint, request

from model import DEmployee, DDepartment
from .bean import HResponse, DepartmentBean, Department
from constants import const
from .employee_view import EmployeeController

# Blueprint初始化
department = Blueprint("department", __name__, url_prefix="/department")


# 控制器 用于搭建数据库和接口之前的桥梁
class DepartmentController(object):
    @staticmethod
    def getDepartmentBean(d):
        tmp_dpt = Department(d.did, d.department_name, d.description, d.status)
        tmp_pdpt = None
        if d.pdid != 0:
            pdpt = DDepartment.query.get(d.pdid)
            tmp_pdpt = Department(pdpt.did, pdpt.department_name, pdpt.description, d.status)
        return DepartmentBean(tmp_dpt, tmp_pdpt, EmployeeController.getEmployeesByDid(d.did))

    @staticmethod
    def getQuitDepartment():
        data = list()
        departments = DDepartment.query.filter(DDepartment.status == const.STATUS_QUIT).all()
        if departments:
            for dpt in departments:
                data.append(DepartmentController.getDepartmentBean(dpt))
        else:
            return None
        return data

    @staticmethod
    def getDepartment(did=None):
        data = list()
            # 只返回Employee类型的简易做法
            # tmp_employees = None
            # employees = DEmployee.query.filter(DEmployee.did == d.did).all()
            # if employees:
            #     tmp_employees = list()
            #     for e in employees:
            #         tmp_emp = Employee(e.eid, e.name, e.gender, str(e.birthday), e.hometown, e.phone, e.email, e.school,
            #             e.education, str(e.entry_time), str(e.leave_time), e.salary, e.status, e.description)
            #         tmp_employees.append(tmp_emp)
            # return DepartmentBean(tmp_dpt, tmp_pdpt, tmp_employees)

        if did is None:
            departments = DDepartment.query.filter(DDepartment.status == const.STATUS_WORK).all()
        else:
            departments = DDepartment.query.get(did)

        if isinstance(departments, list):
            for dpt in departments:
                data.append(DepartmentController.getDepartmentBean(dpt))
        else:
            if departments:
                data.append(DepartmentController.getDepartmentBean(departments))
            else:
                return None
        return data

    @staticmethod
    def addDepartment(name, pdid, description):
        try:
            department = DDepartment(department_name=name, pdid=int(pdid), description=description, status=const.STATUS_WORK)
            db.session.add(department)
            db.session.commit()
            return True
        except Exception as e:
            print(e)
            return False

    @staticmethod
    def changeDepartmentStatus(id, status):
        # 向上搜索
        def getCurrentPdid(pdid):
            tmp_pdept = DDepartment.query.get(pdid)
            if tmp_pdept.status == const.STATUS_WORK:
                return pdid
            else:
                return getCurrentPdid(tmp_pdept.peid)

        department = DDepartment.query.get(id)
        if department:
            department.status = status
            if status == const.STATUS_WORK:
                department.pdid = getCurrentPdid(department.pdid)
            else:
                departments = DDepartment.query.filter(DDepartment.pdid == id, DDepartment.status == const.STATUS_WORK).all()
                employees = DEmployee.query.filter(DEmployee.did == id, DEmployee.status == const.STATUS_WORK).all()
                if departments:
                    for d in departments:
                        d.pdid = department.pdid
                if employees:
                    for e in employees:
                        e.did = department.pdid
            db.session.commit()
            return True
        else:
            return False

    @staticmethod
    def changeDepartment(id, name, pdid, description):
        dept = DDepartment.query.get(id)
        if dept:
            dept.department_name = name
            dept.pdid = int(pdid)
            dept.description = description
            db.session.commit()
            return True
        else:
            return False


# 获取所有无效部门
@department.route("/get_all_quit", methods=['POST'])
def getAllQuitDepartment():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=DepartmentController.getQuitDepartment(), code=const.CODE_SUCCESS)
    return res.make_response()


# 获取所有部门
@department.route("/get_all", methods=['POST'])
def getAllDepartment():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=DepartmentController.getDepartment(), code=const.CODE_SUCCESS)
    return res.make_response()


# 添加部门
@department.route("/add", methods=['POST'])
def addDepartment():
    name = request.form[const.DPT_NAME]
    pdid = request.form[const.DPT_PDID]
    description = request.form[const.DESCRIPTION]

    if name and pdid:
        if DepartmentController.addDepartment(name, pdid, description):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_DEPARTMENT_ADD, code=const.CODE_FAILURE_DEPARTMENT_ADD)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 恢复部门
@department.route("/recovery", methods=['POST'])
def recoveryDepartment():
    id = request.form[const.DPT_ID]
    if id:
        if DepartmentController.changeDepartmentStatus(id, const.STATUS_WORK):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_DEPARTMENT_RECOVERY, code=const.CODE_FAILURE_DEPARTMENT_RECOVERY)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 弃用部门
@department.route("/quit", methods=['POST'])
def quitDepartment():
    id = request.form[const.DPT_ID]
    if id:
        if DepartmentController.changeDepartmentStatus(id, const.STATUS_QUIT):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_DEPARTMENT_QUIT, code=const.CODE_FAILURE_DEPARTMENT_QUIT)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 部门异动
@department.route("/change", methods=['POST'])
def changeDepartment():
    id = request.form[const.DPT_ID]
    name = request.form[const.DPT_NAME]
    pdid = request.form[const.DPT_PDID]
    description = request.form[const.DESCRIPTION]

    if id and name and pdid:
        if DepartmentController.changeDepartment(id, name, pdid, description):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_DEPARTMENT_CHANGE, code=const.CODE_FAILURE_DEPARTMENT_CHANGE)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 获取单个部门
@department.route("/get", methods=['POST'])
def getDepartment():
    id = request.form[const.DPT_ID]
    if id:
        department = DepartmentController.getDepartment(id)
        if department:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=department, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_DPT_NOT_EXIST, code=const.CODE_FAILURE_DPT_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()
