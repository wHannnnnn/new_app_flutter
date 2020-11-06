import 'dart:async';
import 'package:flutter/material.dart';
import '../data.dart';
import '../http/api.dart';
import '../http/request.dart';
import '../component/loading.dart';

class ScrollViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollViewPageState();
  }
}

class ScrollViewPageState extends State<ScrollViewPage> {
  ScrollController _scrollController;
  bool _showToup = false;
  String _bottomText = '加载中';
  bool _loadDataing = false; //是否加载中
  bool _loadData = true; //是否继续加载
  int pageSize = 10; //每页数据

  void initState() {
    super.initState();
    // 返回顶部
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 600) {
        setState(() {
          _showToup = true;
        });
      } else {
        setState(() {
          _showToup = false;
        });
      }

      // 上垃加载
      var maxScroll = _scrollController.position.maxScrollExtent;
      var pixel = _scrollController.position.pixels;
      // 不是加载中执行
      if (!_loadDataing) {
        //并且允许继续加载
        if (maxScroll == pixel && _loadData) {
          setState(() {
            _bottomText = '加载中';
          });
          _loadMoredate();
        } else {
          setState(() {
            _bottomText = '暂无更多数据';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: Container(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              //AppBar，包含一个导航栏
              SliverAppBar(
                pinned: true,
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    children: [Text('scrollView')],
                  ),
                  background: Image.network(
                    resData[0]['pic'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: new SliverGrid(
                  //Grid
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //Grid按两列显示
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.7,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      //创建子widget
                      return new Container(
                        alignment: Alignment.center,
                        child: Container(
                          child: Column(
                            children: [
                              Image.network(
                                resData[index]['pic'],
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 14),
                              Text(resData[index]['name'],
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: resData.length,
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.all(8.0),
                sliver: new SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      //创建子widget
                      return new Container(
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Text(resData[index]['name'],
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          subtitle: Text(resData[index]['characteristic'],
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          leading: Image.network(resData[index]['pic']),
                        ),
                      );
                    },
                    childCount: resData.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  child: new Center(
                    child: Text(_bottomText),
                  ),
                  padding: EdgeInsets.all(2),
                ),
              )
            ],
          ),
        ),
        onRefresh: _pullToRefresh,
      ),
      floatingActionButton: !_showToup
          ? null
          : FloatingActionButton(
              mini: true,
              child: Icon(
                Icons.arrow_upward,
                size: 16,
              ),
              onPressed: () {
                Loading.show(context);
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
                DioHttp.httpRequest(
                  api.url1,
                  method: DioHttp.GET,
                  onSuccess: (data) {
                    Loading.hide(context);
                  },
                  onError: (error) {},
                );
              },
            ),
    );
  }

  _loadMoredate() async {
    setState(() {
      _loadDataing = true; //加载中
    });
    var time = Timer.periodic(Duration(milliseconds: 500), (t) {
      setState(() {
        resData.add({
          "name": 'asd',
          'characteristic': 'zxc',
          'pic':
              'https://dcdn.it120.cc/2020/03/11/9580ab58-56a6-4476-90dc-2ec3d0d98911.dpg'
        });
        _loadDataing = false; //加载完成
        if (resData.length >= 10) {
          _loadData = false; //不需要继续加载
        } else {
          _loadData = true;
        }
      });
      t.cancel();
    });
  }

  Future _pullToRefresh() async {
    return null;
  }
}
