import 'package:feather/feather.dart';
import 'package:flockup/actions.dart';
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
    } else {
      fetchEvents();
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
  final List<Map> events = get(data, 'events', []);
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Flockup"),
    ),
    body: new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new EventListWidget(events),
          )
        ],
      ),
    ),
  );
}

class EventListWidget extends StatelessWidget {
  final List<Map> events;
  final ScrollController scrollController;

  EventListWidget(this.events) : scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: events.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int itemIndex) {
        if (itemIndex <= events.length) {
          return buildEventListItem(context, events[itemIndex]);
        }
      },
    );
  }
}

Widget buildImageOrPlaceholder(Map event) {
  final String photo = getIn(event, ['featured_photo', 'photo_link']);
  var image;
  if (photo != null) {
    image = new Image.network(
      photo,
      fit: BoxFit.cover,
    );
  } else {
    image = new Container(
      color: Colors.grey.withOpacity(0.3),
    );
  }

  return new AspectRatio(
    aspectRatio: 16.0 / 9.0,
    child: image,
  );
}

Widget buildEventListItem(BuildContext context, Map event) {
  final String name = get(event, 'name', '');
  final String group = getIn(event, ['group', 'name'], '');
  final String time = get(event, 'local_time', '').toString();

  var header = new Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      new Text(name),
      new Text(group),
    ],
  );

  var footer = new Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      new Row(
        children: <Widget>[
          new Icon(Icons.timer),
          new Text(time),
        ],
      )
    ],
  );

  return new Column(
    children: <Widget>[
      header,
      buildImageOrPlaceholder(event),
      footer,
    ],
  );
}
