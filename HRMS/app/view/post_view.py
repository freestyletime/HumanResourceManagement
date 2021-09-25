# 职位管理模块
from app import db
from flask import Blueprint, request

from model import DPost, DPostLevel
from .bean import HResponse, PostBean, PostLevel, Post, PostLevelBean
from constants import const

from .employee_view import EmployeeController

# Blueprint初始化
post = Blueprint("post", __name__, url_prefix="/post")


# 控制器 用于搭建数据库和接口之前的桥梁
class PostController(object):
    @staticmethod
    def getPostBean(p):
        tmp_post = Post(p.pid, p.post_name, p.description, p.status)
        tmp_employees = EmployeeController.getEmployeesByPid(p.pid)
        return PostBean(tmp_post, tmp_employees)

    @staticmethod
    def getPostLevelBean(pl, status):
        tmp_post_level = PostLevel(pl.lid, pl.level, pl.nick_name, pl.description)
        ps = DPost.query.filter(DPost.lid == pl.lid, DPost.status == status).all()
        tmp_post_list = None
        if ps and ps.__len__() > 0:
            tmp_post_list = list()
            for p in ps:
                tmp_post = Post(p.pid, p.post_name, p.description, p.status)
                tmp_employees = EmployeeController.getEmployeesByPid(p.pid)
                tmp_post_list.append(PostBean(tmp_post, tmp_employees))
        else:
            return None

        return PostLevelBean(tmp_post_level, tmp_post_list)

    # 按职级给出职位数据
    @staticmethod
    def getPost(lid=None):
        data = list()

        if lid is None:
            posts_level = DPostLevel.query.all()
        else:
            posts_level = DPostLevel.query.get(lid)

        if isinstance(posts_level, list):
            for post_level in posts_level:
                bean = PostController.getPostLevelBean(post_level, const.STATUS_WORK)
                if bean:
                    data.append(bean)
        else:
            if posts_level:
                bean = PostController.getPostLevelBean(posts_level, const.STATUS_WORK)
                if bean:
                    data.append(bean)
            else:
                return None

        if data.__len__() > 0:
            return data
        else:
            return None

    # 给出所有无效职位数据
    @staticmethod
    def getQuitPost():
        data = list()
        posts_level = DPostLevel.query.all()
        if posts_level:
            for post_level in posts_level:
                bean = PostController.getPostLevelBean(post_level, const.STATUS_QUIT)
                if bean:
                    data.append(bean)
        else:
            return None

        if data.__len__() > 0:
            return data
        else:
            return None

    # 按职位ID给出职位数据
    @staticmethod
    def getPostByPid(pid=None):
        data = list()

        if pid is None:
            posts = DPost.query.filter(DPost.status == const.STATUS_WORK).all()
        else:
            posts = DPost.query.get(pid)

        if isinstance(posts, list):
            for post in posts:
                data.append(PostController.getPostBean(post))
        else:
            if posts:
                data.append(PostController.getPostBean(posts))
            else:
                return None
        return data

    # 按职级给出职位数据(新增用户模块选择职位时)
    @staticmethod
    def getSelectPost():
        data = list()
        # 过滤根结点
        posts_level = DPostLevel.query.filter(DPostLevel.level < 8).all()
        for pl in posts_level:
            tmp_post_level = PostLevel(pl.lid, pl.level, pl.nick_name, pl.description)
            ps = DPost.query.filter(DPost.lid == pl.lid, DPost.status == const.STATUS_WORK).all()
            tmp_post_list = None
            if ps and ps.__len__() > 0:
                tmp_post_list = list()
                for p in ps:
                    tmp_post = Post(p.pid, p.post_name, p.description, p.status)
                    tmp_employees = None
                    tmp_post_list.append(PostBean(tmp_post, tmp_employees))

            data.append(PostLevelBean(tmp_post_level, tmp_post_list))
        return data

    # 改变职位可见状态
    @staticmethod
    def changePostStatus(pid, status):
        post = DPost.query.get(pid)
        if post:
            post.status = status
            db.session.commit()
            return True
        else:
            return False

    # 改变职位可见状态
    @staticmethod
    def addPost(name, lid, description):
        try:
            post = DPost(post_name=name, lid=lid, description=description, status=const.STATUS_WORK)
            db.session.add(post)
            db.session.commit()
            return True
        except Exception as e:
            print(e)
            return False


# 获取职位信息
@post.route("/get", methods=['POST'])
def getPost():
    id = request.form[const.POST_ID]
    if id:
        post = PostController.getPostByPid(id)
        if post:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=post, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_POST_NOT_EXIST,
                code=const.CODE_FAILURE_POST_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 添加职位
@post.route("/add", methods=['POST'])
def addPost():
    name = request.form[const.POST_NAME]
    lid = request.form[const.POST_LID]
    description = request.form[const.DESCRIPTION]

    if name and lid:
        if PostController.addPost(name, lid, description):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_POST_ADD, code=const.CODE_FAILURE_POST_ADD)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 弃用职位
@post.route("/quit", methods=['POST'])
def quitPost():
    id = request.form[const.POST_ID]
    if id:
        if PostController.changePostStatus(id, const.STATUS_QUIT):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_POST_QUIT, code=const.CODE_FAILURE_POST_QUIT)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 恢复职位
@post.route("/recovery", methods=['POST'])
def recoveryPost():
    id = request.form[const.POST_ID]
    if id:
        if PostController.changePostStatus(id, const.STATUS_WORK):
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_POST_RECOVERY,
                code=const.CODE_FAILURE_POST_RECOVERY)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()


# 获取所有职位
@post.route("/get_all", methods=['POST'])
def getAllPost():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=PostController.getPostByPid(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取所有职位 (查看职位时)
@post.route("/post_level/get_all", methods=['POST'])
def getAllPostByLevel():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=PostController.getPost(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取所有无效职位
@post.route("/post_level/get_all_quit", methods=['POST'])
def getAllQuitPostByLevel():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=PostController.getQuitPost(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取所有职位 (选择职位时)
@post.route("/post_level/get_all_select", methods=['POST'])
def getAllSelectPostByLevel():
    res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=PostController.getSelectPost(),
        code=const.CODE_SUCCESS)
    return res.make_response()


# 获取单个职级及相关职位
@post.route("/post_level/get", methods=['POST'])
def getPostByLevel():
    id = request.form[const.POST_LID]
    if id:
        postLevel = PostController.getPost(id)
        if postLevel:
            res = HResponse(status=const.STATUS_SUCCESS, msg=const.SUCCESS, data=postLevel, code=const.CODE_SUCCESS)
            return res.make_response()
        else:
            res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_PL_NOT_EXIST,
                code=const.CODE_FAILURE_PL_NOT_EXIST)
            return res.make_response()
    else:
        res = HResponse(status=const.STATUS_FAILURE, msg=const.FAILURE_KEY_BLANK, code=const.CODE_KEY_BLANK)
        return res.make_response()
