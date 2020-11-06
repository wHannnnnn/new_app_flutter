import 'package:flutter/material.dart';
import '../data.dart';

class GridViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridViewPageState();
  }
}

class GridViewPageState extends State<GridViewPage> {
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
        title: Text('grid'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        // GridView
        child: GridView.builder(
          primary: false,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / 1.4,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0),
          itemCount: resData.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Image.network(
                    resData[index]['pic'],
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 14),
                  Text(resData[index]['name'],
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
