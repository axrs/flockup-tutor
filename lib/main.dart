import 'package:feather/feather.dart';
import 'package:flockup/config.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final AppDbStream stateStream = new AppDbStream(AppDb.onUpdate);

  @override
  Widget build(BuildContext context) {
    if (MEETUP_API_KEY == "") {
      debugPrint("=======================================================");
      debugPrint("MEETUP_API_KEY is missing. Please set it in config.dart");
      debugPrint("=======================================================");
    }
    return new MaterialApp(
        title: 'Flockup',
        theme: new ThemeData(
          primarySwatch: Colors.red,
        ),
        home: new StreamBuilder<Map>(
          stream: stateStream,
          initialData: AppDb.init({"loading": true}).store,
          builder: (context, snapshot) => buildHome(context, snapshot.data),
        ));
  }
}

Widget buildHome(BuildContext context, Map data) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Flockup"),
    ),
    body: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Text("Events will go here"),
          )
        ],
      ),
    ),
  );
}
