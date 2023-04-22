import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_dustbin_admin/constants.dart';
import 'package:smart_dustbin_admin/model/navigate_page.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer();
  }

  timer() {
    Timer(Duration(seconds: 5),
            () => Navigator.pushReplacementNamed(context, NavigatePage.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height(context) * 0.5,
                      width: width(context) * 0.5,
                      child: Image.asset('assets/splash.png'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}