import 'package:flutter/material.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/CategoryModel.dart';
import 'package:dio/dio.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _currentIndex = 0;
  List<CategoryItemModel> firstCategoryData = [];
  List<CategoryItemModel> secondCategoryData = [];

  @override
  void initState() {
    print(
        "-----------------_CategoryPageState =>initState--------------------");
    super.initState();
    //从服务器获取一级分类数据
    this.getFirstCategoryData();
  }

  //获取1级分类数据
  void getFirstCategoryData() async {
    var response = await Dio().get("http://jd.itying.com/api/pcate");
    CategoryModel firstCategoryModel = CategoryModel.fromJson(response.data);
    setState(() {
      this.firstCategoryData = firstCategoryModel.result;
    });
    //print(this.firstCategoryData);
    //从服务器获取二级分类数据，根据第一个一级分类的id获取对应的二级分类
    this.getSecondCategoryData(this.firstCategoryData[0].sId);
  }

  //获取2级分类数据
  void getSecondCategoryData(pid) async {
    var response = await Dio().get("http://jd.itying.com/api/pcate?pid=${pid}");
    CategoryModel secondCategoryModel = CategoryModel.fromJson(response.data);
    setState(() {
      this.secondCategoryData = secondCategoryModel.result;
    });
    //print(this.secondCategoryData);
  }

  //一级分类界面
  Widget getFirstCategoryWidget() {
    if (this.firstCategoryData.length > 0) {
      return Container(
        width: 100, //一级分类的宽度
        height: double.infinity,
        //color: Colors.red,
        child: ListView.builder(
          itemCount: this.firstCategoryData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    //点击一级分类按钮的做什么？应该获得这个一级分类对应的二级分类数据
                    this.getSecondCategoryData(
                        this.firstCategoryData[index].sId);
                    //print(
                    //    "inkwell clicked...${this.firstCategoryData[index].sId}");
                    setState(() {
                      this._currentIndex = index;
                    });
                  },
                  child: Container(
                    color: this._currentIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                    height: 50,
                    width: double.infinity,
                    //文字没有居中?能够精确定位组件位置的组件是哪个组件？Stack Align
                    //1、先做界面 2、在界面中渲染数据 3、业务逻辑
                    child: Stack(
                      // ?
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${this.firstCategoryData[index].title}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //分割线
                Divider(
                  height: 1,
                ),
              ],
            ); //整体是一个什么组件？
          },
        ),
      );
    } else {
      return Text("数据加载中...");
    }
  }

  //返回二级分类组件
  Widget getSecondCategoryWidget(eachGridWidth, eachGridiHeight) {
    if (this.secondCategoryData.length > 0) {
      return Expanded(
        flex: 1, //flex布局
        child: Container(
          padding: EdgeInsets.all(10), //上下左右间距是10
          color: Color.fromRGBO(240, 246, 246, 0.9),
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              //设置背景颜色
              //padding: EdgeInsets.all(5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10, // gridview中每个grid之间的间距
                crossAxisSpacing: 10,
                childAspectRatio: eachGridWidth / eachGridiHeight,
              ),
              itemCount: this.secondCategoryData.length,
              itemBuilder: (BuildContext context, int index) {
                String pic = this.secondCategoryData[index].pic;
                pic = "http://jd.itying.com/" + pic.replaceAll('\\', '/');

                return InkWell(
                  onTap: (){
                    print('-----------InkWell clicked...--------');
                    //页面跳转
                    Navigator.pushNamed(context, '/productList', arguments: {
                      "cid": "${this.secondCategoryData[index].sId}",
                    });//命名路由跳转
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Image.network(
                              "${pic}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          //color: Colors.red,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "${this.secondCategoryData[index].title}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    } else {
      return Text("数据加载中...");
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
        this.getFirstCategoryWidget(),
        this.getSecondCategoryWidget(eachGridWidth, eachGridiHeight),
      ],
    );
  }
}
