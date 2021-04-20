import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdapter {
  static double width(double value) { //静态方法
    return ScreenUtil().setWidth(value);
  }

  static double height(double value) {
    return ScreenUtil().setHeight(value);
  }

  static double screenWidth(){
    return ScreenUtil().screenWidth;
  }
}
