# 考勤管理模块
from app import db
from flask import Blueprint, request

# Blueprint初始化
from app.view.bean import HResponse, Employee, AttendanceEmployeeBean, AttendanceStatistic, Attendance, AttendanceBean
from constants import const
from model import DEmployee, DAttendance, DAttendanceStatistic

attendance = Blueprint("attendance", __name__, url_prefix="/attendance")


# 控制器 用于搭建数据库和接口之前的桥梁
class AttendanceController(object):
    @staticmethod
    def getAllAttendanceEmployee():
        data = list()
        employees = DEmployee.query.filter(DEmployee.status == const.STATUS_WORK).all()
        if employees:
            for e in employees:
                tmp_emp = Employee(e.eid, e.name, e.gender, str(e.birthday), e.hometown, e.phone, e.email, e.school,
                    e.education, str(e.entry_time), str(e.leave_time), e.salary, e.status, e.description)
                count = DAttendance.query.filter(DAttendance.eid == e.eid).count()
                data.append(AttendanceEmployeeBean(tmp_emp, count))
        else:
            return None

        return data

    @staticmethod
    def getAllAttendance(id):
        data = list()
        statistics = DAttendanceStatistic.query.filter(DAttendanceStatistic.eid == id).order_by(DAttendanceStatistic.date.desc()).all()

        if statistics:
            for s in statistics:
                data.append(AttendanceStatistic(s.eid, str(s.date), str(s.day_work), str(s.day_in), str(s.day_late), str(s.day_out)))

            return data
        return None

    @staticmethod
    def getAttendance(id, date):
        data = list()

        attendances = DAttendance.query.filter(DAttendance.eid == id, DAttendance.time_start.startswith(date), DAttendance.time_end.startswith(date)).order_by(DAttendance.time_start.desc()).all()

        e = DEmployee.query.get(id)
        if e:
            tmp_emp = Employee(e.eid, e.name, e.gender, str(e.birthday), e.hometown, e.phone, e.email, e.school,
                e.education, str(e.entry_time), str(e.leave_time), e.salary, e.status, e.description)
            tmp_attendances = None
            if attendances:
                tmp_attendances = list()
                for a in attendances:
                    tmp_attendances.append(Attendance(str(a.time_start)[0:10], str(a.time_start), str(a.time_end)))
            data.append(AttendanceBean(tmp_emp, tmp_attendances))
            return data
        return None


# 获取所有考勤人员
@attendance.route("/get_all_emp", methods=['POST'])
def getAllAttendanceEmployee():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=AttendanceController.getAllAttendanceEmployee(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取考勤列表
@attendance.route("/get_all", methods=['POST'])
def getAllAttendance():
    id = request.form[const.EMP_ID]

    if id:
        attendances = AttendanceController.getAllAttendance(id)
        if attendances:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=attendances, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_NOT_EXIST, code=const.CODE_FAILURE_EMP_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 获取考勤列表详细
@attendance.route("/get", methods=['POST'])
def getAttendance():
    id = request.form[const.EMP_ID]
    date = request.form[const.ATD_DATE]

    if id and date:
        attendances = AttendanceController.getAttendance(id, date)
        if attendances:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=attendances, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_EMP_NOT_EXIST, code=const.CODE_FAILURE_EMP_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()