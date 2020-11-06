import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  void initState(){
    super.initState();
    _tabController = new TabController(length: 5, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(96.0),
        child: AppBar(
          title: Text(
              '个人中心',
              style: TextStyle(
                  fontSize: 18
              ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: null)
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: '全部'),
              Tab(text: '已完成'),
              Tab(text: '待发货'),
              Tab(text: '待评价'),
              Tab(text: '已取消'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Text('aa'),
          Text('bb'),
          Text('cc'),
          Text('dd'),
          Text('ee'),
        ],
      )
    );
  }
}
