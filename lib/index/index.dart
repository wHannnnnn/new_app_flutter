import 'package:flutter/material.dart';
import '../mine/mine.dart';
import '../category/category.dart';
import '../home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<Index> {
  int _tabIndex;
  List<Widget> _tabArr;
  void initState() {
    super.initState();
    _tabIndex = 0;
    _tabArr = [HomePage(), CategoryPage(), MinePage()];
  }

  DateTime _lastPressedAt;
  Future<bool> _onWillPop() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      Fluttertoast.showToast(
          msg: "再次点击确认退出",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        body: IndexedStack(
          children: _tabArr,
          index: _tabIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          fixedColor: Colors.deepOrange,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_rounded), label: '首页'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_rounded), label: '分类'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_rounded), label: '我的'),
          ],
          onTap: (int index) {
            setState(() {
              _tabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
