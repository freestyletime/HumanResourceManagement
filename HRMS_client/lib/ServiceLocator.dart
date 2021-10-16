import 'package:flutter_hrms/Service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();
void initLocator() {
  locator.registerSingleton(Service());
}