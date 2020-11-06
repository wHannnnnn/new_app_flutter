import 'package:flutter/material.dart';
import 'package:new_project/provider/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController _userName = TextEditingController();
  TextEditingController _password = TextEditingController();
  void initState() {
    super.initState();
    _userName.text = 'heihei';
    _password.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login'),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                controller: _userName,
                decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名或邮箱",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 0.8, color: Colors.blue)),
                    prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "您的登录密码",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 0.8, color: Colors.blue)),
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      child: Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Provider.of<UserInfo>(context, listen: false).update(UserInfo(name: _password.text, phone: _userName.text));
                      }),
                  SizedBox(width: 20),
                  RaisedButton(
                      child: Text('取消'),
                      onPressed: () {
                      }),
                ],
              )
            ],
          )),
    );
  }
}
