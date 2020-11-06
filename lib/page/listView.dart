import 'package:flutter/material.dart';
import '../data.dart';
class ListViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  Widget _showData(context, index) {
    return ListTile(
        title: Text(resData[index]['name'],
            maxLines: 2, overflow: TextOverflow.ellipsis),
        leading: Image.network(resData[index]['pic']),
        subtitle: Text(resData[index]['characteristic'],
            maxLines: 1, overflow: TextOverflow.ellipsis),
        contentPadding: EdgeInsets.all(4.0));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('listView'),
      ),
      body: Container(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: resData.length,
            itemBuilder: this._showData,
            padding: EdgeInsets.fromLTRB(6, 0, 6, 10)),
      ),
    );
  }
}
