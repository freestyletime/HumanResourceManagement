import 'package:flutter/material.dart';
import 'package:flutter_hrms/Constants.dart';
import 'package:flutter_hrms/models/Salary.dart';
import 'package:flutter_hrms/models/SalaryLevel.dart';

class SalaryListView extends StatelessWidget {
  final List<Salary> data;
  final SalaryLevel level;

  final Function callback;
  final bool isListView;

  const SalaryListView(this.level, this.data,
      {this.callback, this.isListView = true});

  void _onItemClick(Salary data) {
    if (callback != null) {
      callback(data);
    }
  }

  Widget _renderRow(int position, List<Salary> datas, int subsidy) {
    if (position.isOdd) return Divider();

    final index = position ~/ 2;
    Salary data = datas[index];
    Widget getText(String str) {
      return Text(str, style: TextStyle(fontSize: 15));
    }

    Widget getRow(Widget left, Widget right) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: left,
            flex: 1,
          ),
          Expanded(
            child: right,
            flex: 1,
          )
        ],
      );
    }

    return Card(
      elevation: 5.0,
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getRow(
                    getText('${Strings.salary_info_date}：${data.date.substring(0, 7)}'),
                    getText('${Strings.salary_info_base}：${data.salary}')),
                Divider(),
                getRow(
                    getText('${Strings.salary_info_real}：${data.realSalary}'),
                    getText('${Strings.salary_info_subsidy}：$subsidy')),
                Divider(),
                getRow(
                    getText('${Strings.salary_info_insurance}：${data.insurance}'),
                    getText('${Strings.salary_info_tax}：${data.tax}')),
                Divider(),
                getRow(
                    getText('${Strings.salary_info_pre_tax_salary}：${data.preTaxSalary}'),
                    getText('${Strings.salary_info_post_tax_salary}：${data.postTaxSalary}')),
                Divider(),    
                getText('${Strings.salary_info_divide}：${data.divide}')
              ],
            )),
        onTap: () {
          _onItemClick(data);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int subsidy = level.bonus +
        level.extraSubsidy +
        level.houseSubsidy +
        level.levelSubsidy +
        level.lunchSubsidy +
        level.phoneSubsidy +
        level.vehicleSubsidy;

    if (isListView)
      return ListView.builder(
          itemCount: data.length * 2,
          itemBuilder: (context, index) => _renderRow(index, data, subsidy));
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return _renderRow(index, data, subsidy);
    }, childCount: data.length * 2));
  }
}
