import 'package:flutter_hrms/models/IBean.dart';
// 树结构 采用深度遍历整理原始数据获得即可
class DataTree<T extends IBean> {
  final int index;
  final T parent;
  var children = List<DataTree<T>>();

  DataTree(this.index, this.parent);
}