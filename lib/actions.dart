// ignore: deprecated_member_use
import 'dart:convert' show JSON;

import 'package:feather/feather.dart';
import 'package:flockup/config.dart';
import 'package:http/http.dart' as http;

String mapToQueryParam(Map params) {
  return "?" +
      params.entries
          .where((e) => e.value != null)
          .map((e) => '${e.key}=${e.value}')
          .join("&");
}

const String EVENTS_URL = "https://api.meetup.com/find/upcoming_events";

void fetchEvents() {
  final String url = EVENTS_URL +
      mapToQueryParam({
        "fields": "featured_photo,plain_text_description",
        "key": MEETUP_API_KEY,
        "lat": -19.26639,
        "lon": 146.80569,
        "radius": "smart",
        "sign": "true",
      });

  http.get(url).then((response) {
    var body = JSON.decode(response.body);
    var city = get(body, 'city');
    var events = get(body, 'events');
    events.sort((y, x) => get(y, 'time', 0).compareTo(get(x, 'time', 0)));
    AppDb.dispatch(
        (Map store) => merge(store, {"city": city, "events": events}));
  });
}
