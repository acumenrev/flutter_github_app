import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserModel {
  final String avatarUrl;
  final String fullname;
  final String location;
  final String username;

  UserModel({this.username, this.fullname, this.avatarUrl, this.location});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['login'] as String,
    fullname: json['name'] as String,
    avatarUrl: json['avatar_url'] as String,
    location: json['location'] as String);
  }
}

Future<UserModel> fetchUserInfo(http.Client client, String username) async {
  final String url = "https://api.github.com/users/" + username;
  final response = await client.get(url);
  return compute(parseUserInfoFromResponse, response.body);
}

UserModel parseUserInfoFromResponse(String responseBody) {
  final parsed = json.decode(responseBody);
  print(parsed);
  return new UserModel.fromJson(parsed);
}


class UserDetail extends StatelessWidget {
  final String username;

  UserDetail({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text(username)),
      body: new FutureBuilder<UserModel>(future: fetchUserInfo(new http.Client(), username),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return UserDetailErrorView(error: snapshot.error,);
        } else {
          return snapshot.hasData ? new UserDetailView(userData: snapshot.data) : new Center(child: new CircularProgressIndicator(),);
        }
      },),
    );
  }
}

class UserDetailErrorView extends StatelessWidget {
  final Object error;
  final _textStyle = TextStyle(color: Colors.red, fontStyle: FontStyle.italic, fontSize: 18.0);
  UserDetailErrorView({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(children: <Widget>[new Text(error.toString(), style: _textStyle,)], mainAxisAlignment: MainAxisAlignment.center,);
  }
}

class UserDetailView extends StatelessWidget {
  final UserModel userData;
  final _infoUsernameStyle = const TextStyle(fontSize: 14.0, decorationColor: Colors.red, fontStyle: FontStyle.italic);
  final _infoOtherStyle = const TextStyle(fontSize: 12.0, decorationColor: Colors.black, fontStyle: FontStyle.normal);
  UserDetailView({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var rightColumn = new Container(padding: const EdgeInsets.all(10.0),
    child: new Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly ,children: [
      new Row(children: [new Text(userData.username, style: _infoUsernameStyle,)], mainAxisAlignment: MainAxisAlignment.center,),
      new Row(children: [new Text(userData.fullname, style: _infoOtherStyle,)], mainAxisAlignment:MainAxisAlignment.center),
      new Row(children: [new Text(userData.location, style: _infoOtherStyle,)], mainAxisAlignment:MainAxisAlignment.center),
    ],),);

    var leftImage = new Image.network(userData.avatarUrl, fit: BoxFit.cover, width: 100.0,);

    var rowInfo = new Row(children: <Widget>[
      new Container(padding: const EdgeInsets.all(0.0), width: MediaQuery.of(context).size.width - 40.0,child: rightColumn, decoration: new BoxDecoration(border: new Border.all(
        color: Colors.black,
        width: 1.0,
      )),)
    ],
    mainAxisAlignment: MainAxisAlignment.center,);

    var rowAvatar = new Row(children: <Widget>[
      new Container(child: leftImage,)
    ],
    mainAxisAlignment: MainAxisAlignment.center,);

    return new Column(
      children: <Widget>[
        new SizedBox.fromSize(size: new Size(0.0, 50.0),),
        rowAvatar,
        new SizedBox.fromSize(size: new Size(0.0, 20.0),),
        rowInfo
      ]
    );
  }
  
}