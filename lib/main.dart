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

Widget buildIconLabel(
    {IconData icon,
    String text,
    TextStyle style,
    MainAxisAlignment alignment: MainAxisAlignment.start}) {
  if (text != null) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: removeNulls(<Widget>[
        (icon == null)
            ? null
            : new Icon(
                icon,
                color: style?.color,
                size: style?.fontSize,
              ),
        (icon == null)
            ? null
            : new Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
              ),
        new Text(
          text,
          style: style,
        ),
      ]),
    );
  }
}

Widget buildEventListItem(BuildContext context, Map event) {
  final String name = get(event, 'name', '');
  final String group = getIn(event, ['group', 'name'], '');
  final String time = get(event, 'local_time', null);
  final bool isPublic = get(event, 'visibility') == 'public';
  final IconData visibilityIcon = isPublic ? Icons.lock_open : Icons.lock;

  TextTheme headerTextStyle = Theme.of(context).accentTextTheme;

  var header = new Container(
    decoration: new BoxDecoration(
      color: Theme.of(context).primaryColor,
    ),
    child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            name,
            style: headerTextStyle.body2,
            overflow: TextOverflow.ellipsis,
          ),
          new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
            ),
          ),
          new Text(
            group,
            style: headerTextStyle.body1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );

  var footer = new Container(
    decoration: new BoxDecoration(
      color: Colors.black.withOpacity(0.6),
    ),
    child: new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildIconLabel(
            icon: visibilityIcon,
            text: get(event, 'visibility'),
            style: headerTextStyle.body2,
          ),
          new Expanded(
            child: buildIconLabel(
              text: time,
              icon: Icons.timer,
              alignment: MainAxisAlignment.end,
              style: headerTextStyle.body2,
            ),
          )
        ],
      ),
    ),
  );

  return new Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: new Column(
      children: <Widget>[
        header,
        new Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            buildImageOrPlaceholder(event),
            footer,
          ],
        ),
      ],
    ),
  );
}
