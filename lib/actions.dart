// ignore: deprecated_member_use
import 'dart:convert' show JSON;

import 'package:feather/feather.dart';
import 'package:flockup_tutor/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String mapToQueryParam(Map params) {
  return "?" +
      params.entries
          .where(isNotNull)
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
    var events = formatEvents(get(body, 'events'));
    AppDb.dispatch(
        (Map store) => merge(store, {"city": city, "events": events}));
  });
}

var format = new DateFormat('yyyy-MM-dd HH:mm');

String epochToLocalTime(int epoch) {
  DateTime t = DateTime
      .fromMillisecondsSinceEpoch(
        epoch,
        isUtc: true,
      )
      .toLocal();
  return format.format(t);
}

List<Map> formatEvents(List events) {
  return events
      .map((e) => merge(e, {
            "local_time": epochToLocalTime(get(e, 'time', 0)),
            "hasDetails": isNotNull(get(e, 'plain_text_description')),
          }))
      .toList()
        ..sort((y, x) => get(y, 'time', 0).compareTo(get(x, 'time', 0)));
}

navTo(context, view) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => view,
      ));
}
