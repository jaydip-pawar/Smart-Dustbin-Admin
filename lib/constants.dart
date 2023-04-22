import 'package:flutter/material.dart';
import 'package:smart_dustbin_admin/screens/bin_list/bin_list.dart';
import 'package:smart_dustbin_admin/screens/bin_list/bin_screen.dart';
import 'package:smart_dustbin_admin/screens/complaints/complaint_details.dart';
import 'package:smart_dustbin_admin/screens/complaints/complaint_list.dart';
import 'package:smart_dustbin_admin/screens/login/login_screen.dart';
import 'package:smart_dustbin_admin/screens/main.dart';
import 'package:smart_dustbin_admin/screens/splash_screen.dart';

import 'model/navigate_page.dart';

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Map<String, Widget Function(BuildContext)> routes = {
  BinList.id : (context) => const BinList(),
  BinScreen.id : (context) => const BinScreen(),
  ComplaintDetails.id : (context) => const ComplaintDetails(),
  ComplaintList.id : (context) => const ComplaintList(),
  LoginScreen.id : (context) => const LoginScreen(),
  MainScreen.id : (context) => const MainScreen(),
  NavigatePage.id : (context) => const NavigatePage(),
  SplashScreen.id : (context) => SplashScreen(),
};