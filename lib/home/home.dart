import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/http/request.dart';
import 'package:provider/provider.dart';
import 'package:new_project/provider/user_provider.dart';
import '../myButton.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../http/api.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  List _bannerList = [];
  List _categoryList = [];
  List _hotList = [];
  List<Widget> _partnerList = [];
  List _shopList = [];
  ScrollController _scrollController;
  String _bottomText = '加载中...';
  bool _loadDataing = false; //是否加载中
  bool _loadData = true; //是否继续加载
  int _pageNum = 1;
  int _pageSize = 2;
  @override
  void initState() {
    _getBannerList();
    _getCategoryList();
    _getHotGoodsList();
    _getPartnerList();
    _getShopList();
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      // 上垃加载
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;
      // 不是加载中执行
      if (!_loadDataing) {
        //并且允许继续加载
        if (maxScroll == pixel) {
          if (_loadData) {
            setState(() {
              _bottomText = '加载中...';
            });
            _getShopList();
          } else {
            setState(() {
              _bottomText = '已经到底了，看看其他吧~';
            });
          }
        }
      }
    });
  }

//  下拉刷新
  Future _pullToRefresh() async {
    setState(() {
      _pageNum = 1;
      _bottomText = '加载中...';
      _loadDataing = false; //是否加载中
      _loadData = true; //是否继续加载
      _categoryList = [];
      _bannerList = [];
      _shopList = [];
      _hotList = [];
      _getBannerList();
      _getCategoryList();
      _getHotGoodsList();
      _getShopList();
    });
    return null;
  }

  //  轮播图接口
  _getBannerList() {
    DioHttp.httpRequest(
      api.banner,
      method: DioHttp.GET,
      onSuccess: (data) {
        setState(() {
          _bannerList = data['data'];
        });
      },
      onError: (error) {},
    );
  }

  //  分类列表接口
  _getCategoryList() {
    DioHttp.httpRequest(
      api.categoryList,
      method: DioHttp.GET,
      onSuccess: (data) {
        var res = data['data'].where((e) => e['level'] == 1).toList();
        setState(() {
          _categoryList = res;
        });
      },
      onError: (error) {},
    );
  }

  //  热门商品列表接口
  _getHotGoodsList() {
    var params = {'page': 1, 'pageSize': 10, 'orderBy': 'ordersDown'};
    DioHttp.httpRequest(
      api.goodsList,
      method: DioHttp.GET,
      parameters: params,
      onSuccess: (data) {
        setState(() {
          _hotList = data['data'];
        });
      },
      onError: (error) {},
    );
  }

  //  优惠券
  _getPartnerList() {
    DioHttp.httpRequest(
      api.partnerList,
      method: DioHttp.POST,
      parameters: {},
      onSuccess: (data) {
        List<Widget> res = [];
        data['data'].forEach((val) => {
              res.add(Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Image.network(val['picUrl']),
                    onTap: () {},
                  )))
            });
        setState(() {
          _partnerList = res;
        });
      },
      onError: (error) {},
    );
  }

  //  商品列表
  _getShopList() async {
    setState(() {
      _loadDataing = true; //加载中
    });
    var params = {'page': _pageNum, 'pageSize': _pageSize};
    DioHttp.httpRequest(
      api.goodsList,
      method: DioHttp.GET,
      parameters: params,
      onSuccess: (data) {
        setState(() {
          _loadDataing = false; //加载完成
          if (data['code'] == 700) {
            _loadData = false;
            _bottomText = '已经到底了，看看其他吧~';
            return false;
          }
          if (data['data'].length < _pageSize) {
            _loadData = false; //不需要继续加载
            _bottomText = '已经到底了，看看其他吧~';
          } else {
            _pageNum++;
            _loadData = true;
          }
          _shopList.addAll(data['data']);
        });
      },
      onError: (error) {},
    );
  }

  _goLoginPage() {
    Navigator.pushNamed(context, '/login', arguments: {'id': '9898'});
  }

  _goScrollViewPage() {
    Navigator.pushNamed(context, '/scrollView', arguments: {'id': '9898'});
  }

  _goInherited() {
    Navigator.pushNamed(context, '/Inherited', arguments: {'id': '9898'});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: new AppBar(
//      centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: FileWidget(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: GestureDetector(
                  child: Text('搜索'),
                  onTap: () {},
                ),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        child: Container(
            child: ListView(
          controller: _scrollController,
          children: [
            // 轮播图
            Container(
              height: 160,
              child: new Swiper(
                key: UniqueKey(),
                itemBuilder: (BuildContext context, int index) {
                  //条目构建函数传入了index,根据index索引到特定图片
                  return Image.network(
                    _bannerList[index]['picUrl'],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: _bannerList.length,
                autoplay: true,
                pagination: new SwiperPagination(), //这些都是控件默认写好的,直接用
              ),
            ),

            // 导航分类
            Container(
              height: 210,
              color: Colors.white70,
              padding: EdgeInsets.all(10.0),
              child: new Swiper(
                key: UniqueKey(),
                itemBuilder: (BuildContext context, int index) {
                  //条目构建函数传入了index,根据index索引到特定图片
                  return GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / 1.6,
                        crossAxisCount: 5,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 0),
                    itemCount: _categoryList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              _categoryList[index]['icon'],
                              fit: BoxFit.cover,
                            ),
                            Text(_categoryList[index]['name'],
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  );
                },
                pagination: new SwiperPagination(margin: new EdgeInsets.all(0)),
                itemCount: 2,
                autoplay: false,
              ),
            ),

            // 热门商品
            Container(
              color: Colors.white70,
              margin: EdgeInsets.only(top: 4.0),
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              alignment: Alignment.centerLeft,
              height: 220,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            // 四个值 top right bottom left
                            bottom: BorderSide(
                                // 设置单侧边框的样式
                                color: Color(0xffEDEDED),
                                width: 1,
                                style: BorderStyle.solid))),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '热门商品',
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.grey,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _hotList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 96,
                          padding: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    _hotList[index]['pic'],
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: 10),
                                  Text(_hotList[index]['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 4),
                                  Text(
                                    _hotList[index]['minPrice'].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                  Text(
                                    _hotList[index]['originalPrice'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Positioned(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.deepOrange,
                                    splashColor: Colors.deepOrangeAccent,
                                    child: Icon(
                                      Icons.add,
                                      size: 14,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                                right: 1,
                                bottom: 6,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),

            // 优惠券
            Container(
              padding: EdgeInsets.all(6.0),
              color: Colors.white70,
              margin: EdgeInsets.only(top: 4.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _partnerList,
              ),
            ),

            // 商品列表
            Container(
              margin: EdgeInsets.only(top: 4.0),
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 1.5,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0),
                itemCount: _shopList.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(4.0),
                    child: Stack(
                      children: [
                        Column(
                          children: <Widget>[
                            Image.network(
                              _shopList[index]['pic'],
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 12),
                            Text(_shopList[index]['name'],
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 12),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    _shopList[index]['minPrice'].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.deepOrange),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    _shopList[index]['originalPrice']
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: FloatingActionButton(
                              backgroundColor: Colors.deepOrange,
                              splashColor: Colors.deepOrangeAccent,
                              child: Icon(
                                Icons.add,
                                size: 14,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          right: 8,
                          bottom: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              color: Colors.white70,
              child: Padding(
                child: new Center(
                  child: Text(_bottomText),
                ),
                padding: EdgeInsets.all(2),
              ),
            ),

            // Wrap(
            //   spacing: 10,
            //   children: [
            //     MyButton('login', fn: _goLoginPage),
            //     MyButton('scroll', fn: _goScrollViewPage),
            //     MyButton('Inherited', fn: _goInherited),
            //   ],
            // ),
          ],
        )),
        onRefresh: _pullToRefresh,
      ),
    );
  }
}

class FileWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FileWidgetState();
  }
}

class FileWidgetState extends State<FileWidget> {
  Widget buildTextField() {
    //theme设置局部主题
    return TextField(
      cursorColor: Colors.white, //设置光标
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(4, 8, 4, 8),
          border: InputBorder.none,
          icon: Icon(Icons.search),
          hintText: "请输入内容",
          hintStyle: new TextStyle(fontSize: 14, color: Colors.white)),
      style: new TextStyle(fontSize: 14, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //修饰黑色背景与圆角
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), //灰色的一层边框
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
      ),
      alignment: Alignment.center,
      height: 36,
      padding: EdgeInsets.all(8),
      child: buildTextField(),
    );
  }
}
