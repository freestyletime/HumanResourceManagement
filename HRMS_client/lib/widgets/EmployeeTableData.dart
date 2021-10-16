import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/EmployeeBean.dart';

class EmployeeTableData extends StatefulWidget {

  final List<EmployeeBean> data;

  EmployeeTableData(this.data);

  @override
  _EmployeeTableDataState createState() => _EmployeeTableDataState();
}

class _EmployeeTableDataState extends State<EmployeeTableData> {
  int _sortColumnIndex;
  bool _sortAscending = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;

  // 数据填充分页式datatable控件
  Widget _getDataTable(List<EmployeeBean> data) {
    var _ets = _EmployeeDS(data);
    var _tableItemsCount = _ets.rowCount;
    var _defaultRowsPerPage = 8;
    var _isRowCountLessDefaultRowsPerPage =
        _tableItemsCount < _defaultRowsPerPage;
    _rowsPerPage = _isRowCountLessDefaultRowsPerPage
        ? _tableItemsCount
        : _defaultRowsPerPage;
    void _sort<T>(Comparable<T> getField(EmployeeBean bean), int columnIndex,
        bool ascending) {
      _ets._sort<T>(getField, ascending);
      setState(() {
        _sortColumnIndex = columnIndex;
        _sortAscending = ascending;
      });
    }

    TextStyle _style = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
    List<DataColumn> _columns = [
      DataColumn(
          numeric: true,
          label: Text(Strings.employee_info_eid, style: _style),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
              (EmployeeBean bean) => bean.employee.eid,
              columnIndex,
              ascending)),
      DataColumn(label: Text(Strings.employee_info_name, style: _style)),
      DataColumn(
          numeric: true,
          label: Text(Strings.employee_info_gender, style: _style),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
              (EmployeeBean bean) => bean.employee.gender,
              columnIndex,
              ascending)),
      DataColumn(label: Text(Strings.employee_info_postName, style: _style)),
      DataColumn(
          numeric: true,
          label: Text(Strings.employee_info_lid, style: _style),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
              (EmployeeBean bean) => bean.postLevel.level,
              columnIndex,
              ascending)),
      DataColumn(label: Text(Strings.employee_info_dept, style: _style)),
      DataColumn(label: Text(Strings.employee_info_pdept, style: _style)),
      DataColumn(label: Text(Strings.employee_info_leader, style: _style)),
      DataColumn(label: Text(Strings.employee_info_birthday, style: _style)),
      DataColumn(label: Text(Strings.employee_info_hometown, style: _style)),
      DataColumn(label: Text(Strings.employee_info_phone, style: _style)),
      DataColumn(label: Text(Strings.employee_info_email, style: _style)),
      DataColumn(
          numeric: true,
          label: Text(Strings.employee_info_education, style: _style),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
              (EmployeeBean bean) => bean.employee.education,
              columnIndex,
              ascending)),
      DataColumn(label: Text(Strings.employee_info_entryTime, style: _style)),
      DataColumn(
          numeric: true,
          label: Text(Strings.employee_info_salary, style: _style),
          onSort: (int columnIndex, bool ascending) => _sort<num>(
              (EmployeeBean bean) => bean.employee.salary,
              columnIndex,
              ascending)),
      DataColumn(label: Text(Strings.employee_info_status, style: _style))
    ];

    return SingleChildScrollView(
        child: PaginatedDataTable(
            rowsPerPage: _isRowCountLessDefaultRowsPerPage
                ? _rowsPerPage
                : _rowsPerPage1,
            header: Center(
                child: Text(Strings.employee_info_list,
                    style: TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            onRowsPerPageChanged: _isRowCountLessDefaultRowsPerPage
                ? null
                : (rowCount) {
                    setState(() {
                      _rowsPerPage1 = rowCount;
                    });
                  },
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            initialFirstRowIndex: 0,
            availableRowsPerPage: [10, 20],
            source: _ets,
            columns: _columns));
  }

  @override
  Widget build(BuildContext context) {
    return _getDataTable(widget.data);
  }
}

class _EmployeeDS extends DataTableSource {
  final List<EmployeeBean> data;

  _EmployeeDS(this.data);

  void _sort<T>(Comparable<T> getField(EmployeeBean bean), bool ascending) {
    data.sort((EmployeeBean a, EmployeeBean b) {
      if (!ascending) {
        final EmployeeBean c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    if (index >= data.length) return null;
    final EmployeeBean bean = data[index];
    String education = Strings.employee_bachelor;
    String status = Strings.employee_stay_work;

    if (Constants.EDUCATION_OTHER == bean.employee.education)
      education = Strings.employee_education_other;
    else if (Constants.EDUCATION_COLLEGE == bean.employee.education)
      education = Strings.employee_college;
    else if (Constants.EDUCATION_BACHELOR == bean.employee.education)
      education = Strings.employee_bachelor;
    else if (Constants.EDUCATION_MASTER == bean.employee.education)
      education = Strings.employee_master;
    else if (Constants.EDUCATION_PHD == bean.employee.education)
      education = Strings.employee_phd;

    if (Constants.WORK_LEAVE == bean.employee.status)
      status = Strings.employee_leave_work;

    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${bean.employee.eid}')),
        DataCell(Text('${bean.employee.name}')),
        DataCell(Text(bean.employee.gender == Constants.GENDER_FEMALE
            ? '${Strings.employee_female}'
            : '${Strings.employee_male}')),
        DataCell(Text('${bean.post.postName}')),
        DataCell(Text('${bean.postLevel.lid}')),
        DataCell(Text('${bean.dept.departmentName}')),
        DataCell(
            Text(bean.pdept == null ? ' ' : '${bean.pdept.departmentName}')),
        DataCell(Text(bean.leader == null ? ' ' : '${bean.leader.name}')),
        DataCell(Text('${bean.employee.birthday}')),
        DataCell(Text('${bean.employee.hometown}')),
        DataCell(Text('${bean.employee.phone}')),
        DataCell(Text('${bean.employee.email}')),
        DataCell(Text('$education')),
        DataCell(Text('${bean.employee.entryTime}')),
        DataCell(Text('${bean.employee.salary}')),
        DataCell(Text('$status')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}