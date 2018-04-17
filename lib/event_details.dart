import 'package:feather/feather.dart';
import 'package:flockup_tutor/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildImage(Map event) {
  final String photo = getIn(event, ['featured_photo', 'photo_link']);
  return new AspectRatio(
    aspectRatio: 16.0 / 9.0,
    child: ifVal(
        photo,
        (_) => Image.network(
              photo,
              fit: BoxFit.cover,
            ),
        (_) => new Container(
              color: Colors.grey.withOpacity(0.3),
            )),
  );
}

venueSection(context, event) {
  var venue = get(event, 'venue');
  var theme = Theme.of(context).textTheme;
  if (isNotNull(venue)) {
    var address = ['address_1', 'city']
        .map((f) => get(venue, f))
        .where(isNotNull)
        .join(", ");
    var spacer = new Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
    );
    return [
      new Text(
        'VENUE',
        style: theme.body2,
      ),
      spacer,
      new Text(get(venue, 'name')),
      new Text(address),
      spacer,
    ];
  }
}

overviewSection(context, event) {
  var details = get(event, 'plain_text_description');
  var theme = Theme.of(context).textTheme;
  if (isNotNull(details)) {
    return [
      new Text(
        'OVERVIEW',
        style: theme.body2,
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
      ),
      new Text(details),
    ];
  }
}

class EventDetails extends StatelessWidget {
  final Map event;

  EventDetails(this.event);

  @override
  Widget build(BuildContext context) {
    var headerTextStyle = Theme.of(context).accentTextTheme;

    var details = new Container(
      decoration: new BoxDecoration(
        color: Colors.black.withOpacity(0.6),
      ),
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                iconLabel(
                  text:
                      '${get(event, 'yes_rsvp_count', 'unknown')} ${getIn(event, [
                    'group',
                    'who',
                  ], 'members')} going',
                  icon: Icons.people,
                  style: headerTextStyle.body2,
                ),
                expanded(
                  iconLabel(
                    text: get(event, 'local_time'),
                    icon: Icons.timer,
                    alignment: MainAxisAlignment.end,
                    style: headerTextStyle.body2,
                  ),
                ),
              ],
            ),
            new Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
            iconLabel(
              text: getIn(event, ['fee', 'amount'], 'free').toString(),
              icon: Icons.attach_money,
              alignment: MainAxisAlignment.end,
              style: headerTextStyle.body2,
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(get(event, 'name')),
      ),
      body: new Column(
        children: [
          buildImage(event),
          details,
          expanded(
            new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new ListView(
                children: nonNullWidgets([]
                  ..addAll(venueSection(context, event))
                  ..addAll(overviewSection(context, event))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
