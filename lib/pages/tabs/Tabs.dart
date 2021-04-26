import 'package:flutter/material.dart';

import './Home.dart'; //首页
import './Category.dart'; //分类页面
import './User.dart'; //

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  List<Widget> _pagesList = [HomePage(), CategoryPage(), UserPage()]; 

  var _pageController;

  @override
  void initState() {
    
    this._pageController = new PageController(initialPage: this._currentIndex);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("仿京东商城xxx"),
        ),
        //body: this._pagesList[this._currentIndex], //页面切换
        body: IndexedStack( //tab切换保持页面状态
          children: this._pagesList,
          index: this._currentIndex,
        ),
        // body:PageView(
        //   controller: this._pageController,
        //   children:this._pagesList,
        //   onPageChanged: (index){
        //     print("----onPageChanged: index=${index}---");
        //   },
        // ),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.red,
          currentIndex: this._currentIndex,
          onTap: (index){
            print("----onTap: index=${index}---");
            setState(() {
              this._currentIndex = index;
              //this._pageController.jumpToPage(this._currentIndex);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("首页"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text("分类"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("设置"),
            ),
          ],

        ),
      );
  }
}