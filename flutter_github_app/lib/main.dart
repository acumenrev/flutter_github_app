import 'package:flutter/material.dart';
import 'UserDetail.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new UsersList(),
    );
  }
}


class UsersList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new UsersListState();
  }
}

class UsersListState extends State<UsersList> {
  final List<String> _usernames = ["GrahamCampbell", "fabpot","weierophinney", "rkh", "josh"];
  final String title = 'Github';
  final _tileStyle = const TextStyle(color: Colors.blue, fontSize: 18.0, fontStyle: FontStyle.normal, decorationColor: Colors.blue);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(
      appBar: new AppBar(title: new Text(title),),
      body: _buildUsersList()
    );
  }

  Widget _buildUsersList() {
    return new ListView.builder(itemBuilder: (context, index) {
      return _buildItemRow(_usernames[index]);
    }, itemCount: _usernames.length, scrollDirection: Axis.vertical,);
  }

  Widget _buildItemRow(String item) {
    return new ListTile(onTap: () {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new UserDetail(username: item,)));
    }, title: new Text(item),);
  }
}
