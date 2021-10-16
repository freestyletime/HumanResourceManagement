import 'package:flutter_hrms/models/IBean.dart';

class SalaryLevel extends IBean{
  int bonus;
  int extraSubsidy;
  int levelSubsidy;
  int phoneSubsidy;
  int vehicleSubsidy;
  int lunchSubsidy;
  int houseSubsidy;

  SalaryLevel(
      {this.bonus,
      this.extraSubsidy,
      this.levelSubsidy,
      this.phoneSubsidy,
      this.vehicleSubsidy,
      this.lunchSubsidy,
      this.houseSubsidy});

  SalaryLevel.fromJson(Map<String, dynamic> json) {
    bonus = json['bonus'];
    extraSubsidy = json['extra_subsidy'];
    levelSubsidy = json['level_subsidy'];
    phoneSubsidy = json['phone_subsidy'];
    vehicleSubsidy = json['vehicle_subsidy'];
    lunchSubsidy = json['lunch_subsidy'];
    houseSubsidy = json['house_subsidy'];
  }

    @override
  fromJson(Map<String, dynamic> json) {
    return SalaryLevel.fromJson(json);
  }
}