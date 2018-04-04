import 'package:feather/feather.dart';
import 'package:flutter/material.dart';

// ignore: missing_return
Widget iconLabel(
    {IconData icon,
    String text,
    TextStyle style,
    MainAxisAlignment alignment: MainAxisAlignment.start}) {
  if (text != null) {
    return new Row(
      mainAxisAlignment: alignment,
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

Widget imageOrPlaceholder(Map event) {
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
      child: new Icon(
        Icons.image,
        size: 44.0,
      ),
    );
  }

  return new AspectRatio(
    aspectRatio: 16.0 / 9.0,
    child: image,
  );
}

Widget expanded(child) {
  return new Expanded(child: child);
}
