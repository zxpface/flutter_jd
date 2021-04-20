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
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
            backgroundColor:Colors.redAccent,
          title: Center(child: Text("仿京东商城",style: TextStyle(fontSize: 20),),),
        ),
        body: this._pagesList[this._currentIndex], //页面切换
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Colors.red,
          currentIndex: this._currentIndex,
          onTap: (index){
            print(index);
            setState(() {
              this._currentIndex = index;
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