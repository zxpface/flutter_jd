import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import 'package:dio/dio.dart';
import '../model/ProductModel.dart';
import '../widget/LoadingWidget.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _subHeaderIndex = 0; // 0表示综合这个按钮是选上的，1=》销量 2=》价格

  List _subHeaderList = [
    {
      "id": 0,
      "title": "综合",
      "field": "all",
      "sort": -1,
    },
    {
      "id": 1,
      "title": "销量",
      "field": "salecount",
      "sort": -1,
    },
    {
      "id": 2,
      "title": "价格",
      "field": "price",
      "sort": -1,
    },
  ];

  List<ProductItemModel> _productListData = [];
  //用于上拉分页控制器，监听ListView的滚动事件
  ScrollController _scrollController = new ScrollController();
  int _page = 1; //页码
  int _pageSize = 8; //每页商品条数
  bool _hasMore = true; //flag 还有数据要加载吗 true=>有 false=>没有
  bool _hasRequst =
      false; // _hasRequest当前有发往服务器的请求吗？true=》有请求 false=》当前还向服务器请求数据

  String _sort = "all_1"; //1代表升序 -1代表降序 all_1代表按照综合参数对商品列表进行升序排序 all_-1降序

  @override
  void initState() {
    super.initState();
    this.getProductListData(widget.arguments["cid"]);
    this._scrollController.addListener(() {
      double position = this._scrollController.position.pixels;
      double maxScrollExtent =
          this._scrollController.position.maxScrollExtent; //返回listview当前滚动位置
      if (position >= maxScrollExtent - 20) {
        print("当前到了listview页面的最后了...");
        if (this._hasRequst == false && this._hasMore == true) {
          //请求服务器数据，请求哪些的数据？
          print("还有数据，正在请求服务器获取数据...");
          this._page++;
          print("-----${this._page}------");
          this.getProductListData(widget.arguments["cid"]);
          // 连续请求=>某一个时刻是有一个请求，调用一次这个方法就请求一次
        } else {
          //print("没有数据了，不要拉了");
        }
      }
      //print("${position}------${maxScrollExtent}");
    });
  }

  //获取商品列表数据
  void getProductListData(cid) async {
    this._hasRequst = true; //立马把门锁上
    //异步请求 线程阻塞 操作系统中 程序=》进程=》多个线程
    String url = "http://jd.itying.com/api/plist?cid=${cid}&page=${_page}&pageSize=${_pageSize}&sort=${_sort}";
    print(url);
    var response = await Dio().get(
        url);
    
    
    
    ProductModel productModel = ProductModel.fromJson(response.data);
    setState(() {
      //this._productListData = productModel.result;
      //将当前页数据productModel.result追加到数组this._productListData
      this._productListData.addAll(productModel.result);
      if (productModel.result.length < this._pageSize) {
        this._hasMore = false; //表示之后没有数据了
      }
    });
    this._hasRequst = false; //完事之后，把门打开
    //print(this._productListData);
  }

  // 返回Loading加载数据组件
  Widget getLoadingWidget(index) {
    // ((index == this._productListData.length - 1) && (this._hasMore == true))
    //                   ? LoadingWidget()
    //                   : Text("")
    if (index == this._productListData.length - 1) {
      //是最后一行
      if (this._hasMore == true) {
        //还有数据
        return LoadingWidget();
      } else {
        //没有数据了
        return Text("----我是有底线的呦----");
      }
    } else {
      //不是最后一行
      return Text("");
    }
  }

  //返回商品列表组件
  Widget _productListWidget() {
    if (this._productListData.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
        width: double.infinity,
        height: double.infinity,
        //color: Colors.brown,
        child: ListView.builder(
          controller: this._scrollController,
          itemCount: this._productListData.length,
          itemBuilder: (context, index) {
            String pic = this._productListData[index].pic;
            pic = "http://jd.itying.com/" + pic.replaceAll('\\', '/');
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(10),
                  ScreenAdapter.width(10),
                  ScreenAdapter.width(10),
                  ScreenAdapter.width(10)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ScreenAdapter.width(10)),
                        width: ScreenAdapter.width(180),
                        height: ScreenAdapter.height(180),
                        child: Image.network("${pic}"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(ScreenAdapter.width(10)),
                          height: ScreenAdapter.height(180),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${this._productListData[index].title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: ScreenAdapter.height(36),
                                    width: ScreenAdapter.width(60),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("4g"),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenAdapter.width(20),
                                  ),
                                  Container(
                                    height: ScreenAdapter.height(36),
                                    width: ScreenAdapter.width(60),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text("126"),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(230, 230, 230, 0.9),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "¥${this._productListData[index].price}",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                  ),
                  //listview的最后一行？
                  getLoadingWidget(index),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: ScreenAdapter.height(80)),
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
  //导航
  Widget _topbanner(){
    return   Positioned(
      width: ScreenAdapter.width(750), // double.infinity
      height: ScreenAdapter.height(80),
      top: 0,
      child: Container(
        width: ScreenAdapter.width(750), // double.infinity
        height: ScreenAdapter.height(80),
        child: Row(
          children: this._subHeaderList.map((value) {
            //dart语法
            return Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    print("${value["title"]}");
                    //按钮单击事件
                    this._subHeaderIndex = value["id"];
                    print(
                        this._subHeaderIndex); //程序调试=》print打印程序执行过程,debug
                    //重新获取数据
                    this._sort =  "${value["field"]}_${value["sort"]}";//拼接代码
                    this._productListData = []; //将商品列表数组清空，重新请求数据
                    this._hasMore = true; //将_hasMore重置
                    this._page = 1; //将页码_page重置
                    this.getProductListData(widget.arguments["cid"]);
                    //改变排序，升序=》降序，降序=》升序
                    value["sort"] *= -1; // 1=>-1 -1=>1 将排序在升序和降序之间改变
                  });
                },
                child: Container(
                  height: ScreenAdapter.height(80),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${value["title"]}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                          color: (this._subHeaderIndex == value["id"])
                              ? Colors.red
                              : Colors.grey,
                          width: 1,
                        )),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品列表"),
      ),
      //body: Text("商品列表页面...${widget.arguments["cid"]}"),
      body: Stack(
        children: [
          _productListWidget(),

          //导航
          _topbanner()
        ],
      ),
    );
  }
}
