import 'package:flutter/material.dart';
import '../data.dart';

class InheritedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InheritedPageState();
  }
}

class InheritedPageState extends State<InheritedPage> {
  int num = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: firstWidget(
          num: num,
          child: Column(
            children: [
              secondWidget(),
              RaisedButton(
                child: Text('+1'),
                onPressed: () {
                  setState(() {
                    ++num;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class firstWidget extends InheritedWidget {
  const firstWidget({
    Key key,
    @required this.num,
    @required Widget child,
  })  : assert(num != null),
        assert(child != null),
        super(key: key, child: child);

  final int num;

  static firstWidget of(BuildContext context) {
    // return context.dependOnInheritedWidgetOfExactType();
    return context.getElementForInheritedWidgetOfExactType<firstWidget>().widget;
  }

  @override
  bool updateShouldNotify(firstWidget old) => num != old.num;
}

class secondWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return secondWidgetState();
  }
}

class secondWidgetState extends State<secondWidget> {
  @override
  void didChangeDependencies() {
    print("Dependencies change");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${firstWidget.of(context).num}');
  }
}
