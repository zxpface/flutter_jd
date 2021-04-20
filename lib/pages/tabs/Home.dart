import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/ScreenAdapter.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FocusItemModel> focusData = [];
  List<ProductItemModel> guessYouLikeData = []; // 0-1->2 so easy
  List<ProductItemModel> hotRecommendData = [];

  void initState() {
    //生命周期方法：组件创建的时候会回调initState方法
    //dio
    getFocusData();
    getGuessYouLikeData();
    getHotRecommendData();
  }

  //获取轮播图数据
  void getFocusData() async {
    //同步 异步
    var response = await Dio().get("http://jd.itying.com/api/focus");
    FocusModel focusModel = FocusModel.fromJson(response.data);
    setState(() {
      this.focusData = focusModel.result;
    });
    //print(this.focusData);
  }

  //获取猜你喜欢数据
  void getGuessYouLikeData() async {
    //同步 异步
    var response = await Dio().get("http://jd.itying.com/api/plist?is_hot=1");
    ProductModel productModel = ProductModel.fromJson(response.data); // MVC
    setState(() {
      this.guessYouLikeData = productModel.result;
    });
    print(this.guessYouLikeData);
  }

  //获取热门推荐数据
  void getHotRecommendData() async {
    var response = await Dio().get("http://jd.itying.com/api/plist?is_best=1");
    ProductModel productModel = ProductModel.fromJson(response.data);
    setState(() {
      this.hotRecommendData = productModel.result;
    });
    print(this.hotRecommendData);
  }

  Widget _swiperWidget() {
    if (this.focusData.length > 0) {
      //轮播图
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            autoplay: true,
            itemCount: this.focusData.length,
            itemBuilder: (BuildContext context, int index) {
              //http://jd.itying.com/public//upload//UObZahqPYzFvx_C9CQjU8KiX.png
              //http://jd.itying.com/public\upload\s5ujmYBQVRcLuvBHvWFMJHzS.jpg
              String picStr = this.focusData[index].pic;
              picStr = "http://jd.itying.com/" + picStr.replaceAll('\\', '/');
              print(picStr);
              return new Image.network(
                "${picStr}",
                fit: BoxFit.fill,
              );
            },
            pagination: new SwiperPagination(),
            control: new SwiperControl(),
          ),
        ),
      );
    } else {
      return Center(child: Text("数据加载中...",style: TextStyle(color: Colors.grey),),);
    }
  }

  Widget _titleWidget(value) {
    return Container(
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.only(left: ScreenAdapter.width(12)),
      height: ScreenAdapter.height(32),
      child: Text(
        "${value}",
        style: TextStyle(
          color: Colors.black54,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.red,
            width: ScreenAdapter.width(10),
          ),
        ),
      ),
    );
  }

  //猜你喜欢界面
  Widget _guessYouLike() {
    return Container(
      padding: EdgeInsets.only(left: ScreenAdapter.width(10)),
      height: ScreenAdapter.height(200),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: this.guessYouLikeData.length,
          itemBuilder: (BuildContext context, int index) {
            String picStr = this.guessYouLikeData[index].sPic;
            picStr = "http://jd.itying.com/" + picStr.replaceAll('\\', '/');
            print(picStr);
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: ScreenAdapter.width(10)),
                  width: ScreenAdapter.width(160),
                  height: ScreenAdapter.height(160),
                  child: Image.network(
                    "${picStr}",
                    fit: BoxFit.cover,
                  ),
                ),
                Text("第${index + 1}条"),
              ],
            );
          }),
    );
  }

//热门推荐的界面
  Widget _hotRecommend() {
    if (this.hotRecommendData.length > 0) {
      //Wrap中每一个Container的宽需要？
      double itemWidth = (ScreenAdapter.screenWidth() - 30) / 2;
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Wrap(
          // 流布局
          runSpacing: 10,
          spacing: 10,
          children: this.hotRecommendData.map((currentElement) {
            String pic = currentElement.pic;
            pic = "http://jd.itying.com/"+ pic.replaceAll('\\', '/');
            print(pic); //http://jd.itying.com/public/upload/KqOpb7U4Exk-K3OmNweMkTNS.png_200x200.png
            return Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(233, 233, 233, 0.9),
                  width: 1,
                ),
              ),
              width: itemWidth,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        "${pic}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "${currentElement.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "¥${currentElement.price}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("¥${currentElement.oldPrice}",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return Center(child: Text("数据加载中...",style: TextStyle(color: Colors.grey)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        //轮播图
        this._swiperWidget(),
        SizedBox(
          height: ScreenAdapter.height(10),
        ),
        //猜你喜欢
        this._titleWidget("猜你喜欢"),
        SizedBox(
          height: ScreenAdapter.height(10),
        ),
        //猜你喜欢 水平滚动列表
        this._guessYouLike(),

        this._titleWidget("热门推荐"),
        //热门推荐
        this._hotRecommend(),
      ],
    );
  }
}
