import datetime


# 计算两个日期之间的工作日数,非天数.
class WorkDays(object):
    def __init__(self, start_date, end_date, days_off=None):
        """
        days_off:休息日,默认周六日, 以0(星期一)开始,到6(星期天)结束, 传入tupple
        没有包含法定节假日,
        """
        self.start_date = start_date
        self.end_date = end_date
        self.days_off = days_off
        if self.start_date > self.end_date:
            self.start_date, self.end_date = self.end_date, self.start_date
        if days_off is None:
            self.days_off = 5, 6
        # 每周工作日列表
        self.days_work = [x for x in range(7) if x not in self.days_off]

    def workDays(self):
        """
        实现工作日的 iter, 从start_date 到 end_date, 如果在工作日内, yield日期
        """
        # 还没排除法定节假日
        tag_date = self.start_date
        while True:
            if tag_date > self.end_date:
                break
            if tag_date.weekday() in self.days_work:
                yield tag_date
            tag_date += datetime.timedelta(days=1)

    def daysCount(self):
        """工作日统计,返回数字"""
        return len(list(self.workDays()))

    def weeksCount(self, day_start=0):
        """
        统计所有跨越的周数,返回数字
        默认周从星期一开始计算
        """
        day_nextweek = self.start_date
        while True:
            if day_nextweek.weekday() == day_start:
                break
            day_nextweek += datetime.timedelta(days=1)
        # 区间在一周内
        if day_nextweek > self.end_date:
            return 1
        weeks = ((self.end_date - day_nextweek).days + 1) / 7
        weeks = int(weeks)
        if ((self.end_date - day_nextweek).days + 1) % 7:
            weeks += 1
        if self.start_date < day_nextweek:
            weeks += 1
        return weeks


# 常量管理类
class Const(object):
    class ConsError(TypeError):
        pass

    class ConstCaseError(ConsError):
        pass

    def __setattr__(self, name, value):
        if name in self.__dict__:
            raise (self.ConsError, "Can't change const.%s" % name)
        if not name.isupper():
            raise (self.ConstCaseError, "const name '%s' is not all uppercase" % name)
        self.__dict__[name] = value


const = Const()
# 字段
# # 状态码
# 在职状态
const.STATUS_WORK = 1
# 离职状态
const.STATUS_QUIT = 2
# email后缀
const.EMAIL_SUFFIX = '@hhtech.com'
# # HTTP头字段
const.MIMETYPE = 'application/json; charset=utf-8'
# # 登陆相关字段
const.LOGIN_USERNAME = 'username'
const.LOGIN_PASSWORD = 'password'

const.EMP_ID = 'eid'
const.EMP_NAME = 'name'
const.EMP_GENDER = 'gender'
const.EMP_YEAR = 'year'
const.EMP_MONTH = 'month'
const.EMP_DAY = 'day'
const.EMP_HOMETOWN = 'hometown'
const.EMP_PHONE = 'phone'
const.EMP_SCHOOL = 'school'
const.EMP_EDUCATION = 'education'
const.EMP_SALARY= 'salary'
const.EMP_PEID = 'peid'

const.DPT_ID = 'did'
const.DPT_NAME = 'name'
const.DPT_PDID = 'pdid'

const.POST_ID = 'pid'
const.POST_NAME = 'name'
const.POST_LID = 'lid'

const.ATD_DATE = 'date'

const.DESCRIPTION = 'description'

# # 请求状态
const.STATUS_SUCCESS = 0
const.STATUS_FAILURE = 1

# # 业务错误CODE码
const.CODE_SUCCESS = "CE00000"
const.CODE_KEY_BLANK = "CE00001"
const.CODE_USER_NOT_EXIST = "CE00002"
const.CODE_PWD_WRONG = "CE00003"
const.CODE_FAILURE_EMP_NOT_EXIST = "CE00004"
const.CODE_FAILURE_DPT_NOT_EXIST = "CE00005"
const.CODE_FAILURE_PL_NOT_EXIST = "CE00006"
const.CODE_FAILURE_POST_NOT_EXIST = "CE00007"
const.CODE_FAILURE_EMP_ADD = "CE00008"
const.CODE_FAILURE_EMP_QUIT = "CE00009"
const.CODE_FAILURE_EMP_RECOVERY = "CE00010"
const.CODE_FAILURE_EMP_CHANGE = "CE00011"
const.CODE_FAILURE_POST_QUIT = "CE00012"
const.CODE_FAILURE_POST_RECOVERY = "CE00013"
const.CODE_FAILURE_POST_ADD = "CE00014"
const.CODE_FAILURE_DEPARTMENT_ADD = "CE00015"
const.CODE_FAILURE_DEPARTMENT_QUIT = "CE00016"
const.CODE_FAILURE_DEPARTMENT_RECOVERY = "CE00017"
const.CODE_FAILURE_DEPARTMENT_CHANGE = "CE00018"

const.CODE_FAILURE_AUTHORITY_PERMISSION = "CE00099"

# # 消息
const.SUCCESS = "请求成功"
const.FAILURE = "请求失败"
const.FAILURE_KEY_BLANK = "必要字段不能为空"
const.FAILURE_USER_NOT_EXIST = "请求失败, 该用户不存在"
const.FAILURE_PWD_WRONG = "请求失败, 密码错误"
const.FAILURE_EMP_NOT_EXIST = "该用户不存在"
const.FAILURE_DPT_NOT_EXIST = "该部门不存在"
const.FAILURE_PL_NOT_EXIST = "该职级不存在"
const.FAILURE_POST_NOT_EXIST = "该职位不存在"
const.FAILURE_EMP_ADD = "用户添加失败"
const.FAILURE_EMP_QUIT = "用户离职失败"
const.FAILURE_EMP_RECOVERY = "用户复职失败"
const.FAILURE_EMP_CHANGE = "用户异动失败"
const.FAILURE_POST_QUIT = "职位弃用失败"
const.FAILURE_POST_RECOVERY = "职位启用失败"
const.FAILURE_POST_ADD = "职位添加失败"
const.FAILURE_DEPARTMENT_ADD = "部门添加失败"
const.FAILURE_DEPARTMENT_QUIT = "部门弃用失败"
const.FAILURE_DEPARTMENT_RECOVERY = "部门启用失败"
const.FAILURE_DEPARTMENT_CHANGE = "部门异动失败"

const.FAILURE_AUTHORITY_PERMISSION = "当前操作人无权限进行该操作"
