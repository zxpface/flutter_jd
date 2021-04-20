import 'package:flutter/material.dart';

import './routers/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // _私有的
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner:false,
        //home: Tabs(),
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
