import 'package:event_bus/event_bus.dart';

// 全局的变量及常量标志
class Constants {
  //全局的event_bus
  static final EventBus eventBus = EventBus();
  // 后台返回状态 成功
  static final int STATUS_SUCCESS = 0;
  // 后台返回状态 失败
  static final int STATUS_FAILURE = 1;
  // 教育背景
  static final int EDUCATION_OTHER = 1;
  static final int EDUCATION_COLLEGE = 2;
  static final int EDUCATION_BACHELOR = 3;
  static final int EDUCATION_MASTER = 4;
  static final int EDUCATION_PHD = 5;
  // 女
  static final int GENDER_FEMALE = 0;
  // 男
  static final int GENDER_MALE = 1;
  // 在职
  static final int WORK_WORK = 1;
  // 离职
  static final int WORK_LEAVE = 2;
  // 职级
  static final String POST_LEVEL_P1 = 'p1';
  static final String POST_LEVEL_P2 = 'p2';
  static final String POST_LEVEL_P3 = 'p3';
  static final String POST_LEVEL_P4 = 'p4';
  static final String POST_LEVEL_P5 = 'p5';
  static final String POST_LEVEL_P6 = 'p6';
  static final String POST_LEVEL_P7 = 'p7';
}

// 全局的字符串常量
class Strings {
  static final String appTitle = '人事信息管理系统';
  static final String msg_key_empty = '关键信息不能为空';
  static final String msg_key_old = '关键信息未改动';
  static final String msg_key_format_error = '关键信息格式错误';
  static final String msg_select_empty = '更改失败，返回数据为空';
  static final String msg_select_same = '更改失败，无效的选择';
  static final String msg_not_connection = '网络异常';
  static final String msg_loading = '加载中...';
  static final String msg_prompt = '提示';
  static final String msg_confirm = '确定';
  static final String msg_cancel = '取消';
  static final String msg_data_empty = '暂无数据';

  static final String userName = '用户名';
  static final String hint_userName = '请输入用户名';
  static final String password = '密码';
  static final String hint_password = '请输入密码';
  static final String login = '登陆';
  // 员工模块
  static final String employee = '员工管理';
  static final String employee_quit_hint = '离职后，该员工所属下级员工的直属领导会变更为该员工的直属领导，确认离职？';
  static final String employee_recovery_hint = '该员工目前处于离职状态，确认复职？';
  static final String employee_search_hint = '请输入员工姓名或者部门名称';
  static final String employee_male = '男';
  static final String employee_female = '女';
  static final String employee_education_other = '高中及以下';
  static final String employee_college = '大专';
  static final String employee_bachelor = '本科';
  static final String employee_master = '硕士';
  static final String employee_phd = '博士';
  static final String employee_stay_work = '在职';
  static final String employee_leave_work = '离职';
  static final String employee_detail = '员工详细资料';
  static final String employee_call = '拨打电话';
  static final String employee_msg = '发送短信';
  static final String employee_email = '发送邮件';
  static final String employee_change = '员工异动';
  static final String employee_quit = '离职操作';
  static final String employee_recovery = '复职操作';

  static final String employee_menu_list = '员工列表';
  static final String employee_menu_table = '员工二维表';
  static final String employee_menu_tree = '员工树';
  static final String employee_menu_add = '新员工入职';
  static final String employee_menu_list_quit = '离职员工列表';
  static final String employee_add_success = '员工录入成功';
  static final String employee_change_success = '员工异动成功';
  static final String employee_quit_perimission_deny = '操作无效，当前操作员无权限';
  static final String employee_quit_failure = '操作无效，员工已经处于离职状态';
  static final String employee_quit_success = '操作成功，员工已处于离职状态';
  static final String employee_recovery_success = '操作成功，员工已处于在职状态';

  static final String employee_info_list = '员工信息列表';
  static final String employee_info_eid = '工号';
  static final String employee_info_name = '姓名';
  static final String employee_info_name_hint = '请输入员工姓名';
  static final String employee_info_gender = '性别';
  static final String employee_info_postName = '职位';
  static final String employee_info_postName_hint = '请选择职位';
  static final String employee_info_school = '毕业院校';
  static final String employee_info_school_hint = '请输入毕业院校';
  static final String employee_info_lid = '职级';
  static final String employee_info_pid = '职位编号';
  static final String employee_info_dept = '部门';
  static final String employee_info_dept_hint = '请选择部门';
  static final String employee_info_pdept = '上级部门';
  static final String employee_info_pdept_hint = '请选择上级部门';
  static final String employee_info_leader = '上级领导';
  static final String employee_info_leader_hint = '请选择级领导';
  static final String employee_info_birthday = '生日';
  static final String employee_info_birthday_year = '年';
  static final String employee_info_birthday_month = '月';
  static final String employee_info_birthday_day = '日';
  static final String employee_info_hometown = '籍贯';
  static final String employee_info_hometown_hint = '请输入籍贯';
  static final String employee_info_phone = '电话';
  static final String employee_info_phone_hint = '请输入电话';
  static final String employee_info_email = '邮箱';
  static final String employee_info_email_hint = '请输入邮箱';
  static final String employee_info_education = '学历';
  static final String employee_info_entryTime = '入职时间';
  static final String employee_info_salary = '工资';
  static final String employee_info_salary_hint = '请输入基本工资';
  static final String employee_info_status = '状态';
  static final String employee_info_description = '个人描述';
  static final String employee_info_description_hint = '请输入个人描述（可为空）';

  // 职位模块
  static final String post = '职位管理';
  static final String post_detail = '职位详细资料';
  static final String post_search_hint = '请输入职位名称';
  static final String post_member = '职位人数';
  static final String post_quit_hint = '该职位目前处于可用状态，确认弃用？';
  static final String post_recovery_hint = '该职位目前处于弃用状态，确认恢复？';

  static final String post_add_success = '职位添加成功';
  static final String post_menu_add = '新增职位';
  static final String post_menu_del_list = '弃用职位列表';
  static final String post_menu_recovery = '恢复职位';
  static final String post_menu_del = '弃用职位';
  static final String post_menu_del_hint = '操作失败，该职位员工数不为0';

  static final String post_quit_success = '操作成功，该职位已弃用';
  static final String post_recovery_success = '操作成功，该职位已处于启用状态';

  static final String post_info_name = '职位名称';
  static final String post_info_name_hint = '请输入职位名称';
  static final String post_info_level = '职级';
  static final String post_info_description = '职位描述';
  static final String post_info_description_hint = '请输入职位描述（可为空）';

  // 部门模块
  static final String department = '部门管理';
  static final String department_detail = '部门详细资料';
  static final String department_search_hint = '请输入部门名称';
  static final String department_member = '部门人数：';
  static final String department_quit_hint = '弃用后，该部门所属下级部门的上级会变更为该部门的上级部门，该部门下的人员会移动至该部门的上级部门，确认弃用？';
  static final String department_recovery_hint = '该部门目前处于弃用状态，确认恢复？';

  static final String department_info_did = '部门号';
  static final String department_info_name = '部门名称';
  static final String department_info_name_hint = '请输入部门名称';
  static final String department_info_pdept = '上级部门';
  static final String department_info_description = '部门描述';
  static final String department_info_description_hint = '请输入部门描述（可为空）';

  static final String department_menu_add = '新增部门';
  static final String department_menu_del_list = '弃用部门列表';
  static final String department_menu_list = '部门列表';
  static final String department_menu_tree = '部门树';

  static final String department_change = '部门异动';
  static final String department_del = '弃用部门';
  static final String department_recovery = '恢复部门';

  static final String department_add_success = '部门添加成功';
  static final String department_quit_success = '操作成功，该部门已弃用';
  static final String department_recovery_success = '操作成功，该部门已处于启用状态';


  // 考勤模块
  static final String attendance = '考勤管理';
  static final String attendance_menu_now = '当月考勤';
  static final String attendance_list = '考勤记录列表';
  static final String attendance_list_detail = '考勤详细';
  static final String attendance_day = '考勤打卡天数';
  static final String attendance_search_hint = '请输入考勤日期';
  static final String attendance_info_date = '考勤日期';
  static final String attendance_info_day_work = '应到天数';
  static final String attendance_info_day_in = '实到天数';
  static final String attendance_info_day_late = '迟到天数';
  static final String attendance_info_day_out = '旷工天数';
  static final String attendance_info_date_time = '考勤打卡日期';
  static final String attendance_info_time_start = '上班打卡时间';
  static final String attendance_info_time_end = '下班打卡时间';
  static final String attendance_info_month_total = '条考勤';

  // 工资模块
  static final String salary = '工资管理';
  static final String salary_list = '工资记录列表';
  static final String salary_search_hint = '请输入工资日期';
  static final String salary_count = '工资数据';
  static final String salary_info_tax = '个税补扣';
  static final String salary_info_date = '工资日期';
  static final String salary_info_base = '基本工资';
  static final String salary_info_real = '应得工资';
  static final String salary_info_subsidy = '补贴总计';
  static final String salary_info_insurance = '社保补扣';
  static final String salary_info_pre_tax_salary = '税前工资';
  static final String salary_info_post_tax_salary = '税后工资';
  static final String salary_info_divide = '本月罚款';
  static final String salary_info_month_total = '条工资记录';
}

//所有的请求id
class Ids {
  static final String ID_LOGIN = 'id_login';
  static final String ID_GET_STATISTIC = 'id_get_statistic';
  static final String ID_ADD_EMPLOYEE = 'id_add_employee';
  static final String ID_GET_EMPLOYEE = 'id_get_employee';
  static final String ID_QUIT_EMPLOYEE = 'id_quit_employee';
  static final String ID_RECOVERY_EMPLOYEE = 'id_recovery_employee';
  static final String ID_CHANGE_EMPLOYEE = 'id_change_employee';
  static final String ID_GET_ALL_EMPLOYEE = 'id_get_all_employee';
  static final String ID_GET_ALL_QUIT_EMPLOYEE = 'id_get_all_quit_employee';
  static final String ID_GET_ALL_DEPARTMENT = 'id_get_all_department';
  static final String ID_GET_ALL_QUIT_DEPARTMENT = 'id_get_all_quit_department';
  static final String ID_GET_DEPARTMENT = 'id_get_department';
  static final String ID_ADD_DEPARTMENT = 'id_add_department';
  static final String ID_QUIT_DEPARTMENT = 'id_quit_department';
  static final String ID_CHANGE_DEPARTMENT = 'id_change_department';
  static final String ID_RECOVERY_DEPARTMENT = 'id_recovery_department';
  static final String ID_GET_ALL_POST_BY_LEVEL = 'id_get_all_post_by_level';
  static final String ID_GET_ALL_QUIT_POST_BY_LEVEL = 'id_get_all_quit_post_by_level';
  static final String ID_GET_POST = 'id_get_post';
  static final String ID_ADD_POST = 'id_add_post';
  static final String ID_QUIT_POST = 'id_quit_post';
  static final String ID_RECOVERY_POST = 'id_recovery_post';

  static final String ID_GET_ALL_SALARY_EMP = 'id_get_all_salary_emp';
  static final String ID_GET_ALL_SALARY = 'id_get_all_salary';

  static final String ID_GET_ALL_ATTENDANCE_EMP = 'id_get_all_attendance_emp';
  static final String ID_GET_ALL_ATTENDANCE = 'id_get_all_attendance';
  static final String ID_GET_ATTENDANCE = 'id_get_attendance';
}

// 所有的Code
class Codes {
  static final String CODE_SUCCESS = "CE00000";
  static final String CODE_USER_NOT_EXIST = "CE00002";
  static final String CODE_PWD_WRONG = "CE00003";
  static final String CODE_FAILURE_EMP_NOT_EXIST = "CE00004";
  static final String CODE_FAILURE_DPT_NOT_EXIST = "CE00005";
}
