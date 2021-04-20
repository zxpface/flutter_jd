import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/CateModel.dart';
import '../../services/ScreenAdapter.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _currentIndex = 0;
  List _leftCateList=[];
  List _rightCateList=[];

  @override
  void initState() {
    super.initState();
    _getLeftCateData();

  }
  //左侧分类
  _getLeftCateData() async{
    var api = 'http://jd.itying.com/api/pcate';
    var result = await Dio().get(api);
    var leftCateList = new CateModel.fromJson(result.data);
    // print(leftCateList.result);
    setState(() {
      this._leftCateList = leftCateList.result;
      // print(_leftCateList);
    });
    _getRightCateData(leftCateList.result[0].sId);
  }
  //右侧分类
  _getRightCateData(pid) async{
    var api = 'http://jd.itying.com/api/pcate?pid=59f1e1ada1da8b15d42234e9';
    var result = await Dio().get(api);
    var rightCateList = new CateModel.fromJson(result.data);
    // print("--------" + "${rightCateList.result}");
    setState(() {
      this._rightCateList = rightCateList.result;
    });
  }
  //左边第一级
  Widget _leftCateWidget(leftWidth){

    if(this._leftCateList.length>0){

      return Container(
        width: leftWidth,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: this._leftCateList.length,
          itemBuilder: (context,index){
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    setState(() {
                      _currentIndex= index;
                      this._getRightCateData(this._leftCateList[index].sId);
                      // print(index);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdapter.height(84),
                    padding: EdgeInsets.only(top:ScreenAdapter.height(24)),
                    child: Text("${this._leftCateList[index].title}",textAlign: TextAlign.center),
                    color: _currentIndex==index? Color.fromRGBO(240, 246, 246, 0.9):Colors.white,
                  ),
                ),
                Divider(height: 1),
              ],
            );
          },

        ),
      );
    }else{
      return Container(
          width: leftWidth,
          height: double.infinity
      );
    }
  }
  //右边第二级
  Widget _rightCateWidget(rightItemWidth,rightItemHeight){

    if(this._rightCateList.length>0){
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(

              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:3,
                  childAspectRatio: rightItemWidth/rightItemHeight,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
              ),
              itemCount: this._rightCateList.length,
              itemBuilder: (context,index){

                //处理图片
                String pic=this._rightCateList[index].pic;
                pic="http://jd.itying.com/"+pic.replaceAll('\\', '/');

                return Container(
                  // padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[

                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network("${pic}",fit: BoxFit.cover),
                      ),
                      Container(
                        height: ScreenAdapter.height(28),
                        child: Text("${this._rightCateList[index].title}"),
                      )
                    ],
                  ),
                );
              },
            )
        ),
      );
    }else{
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("加载中..."),
          )
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    //int eachGraidWidth = (屏幕宽度-一级分类的宽度-2个边距-2个格子之间的间距)/3;
    double eachGridWidth = (ScreenAdapter.screenWidth() - 100 - 20 - 20) / 3;
    //double eachGrdiHeight = eachGridWidth+文字的高度
    double eachGridiHeight = eachGridWidth + 30;
    return Row(
      children: [
        _leftCateWidget(eachGridWidth),
        _rightCateWidget(eachGridWidth,eachGridiHeight)
      ],
    );
  }
}
