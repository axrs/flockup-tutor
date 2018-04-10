import 'package:feather/feather.dart';
import 'package:flutter/material.dart';

// ignore: missing_return
Widget iconLabel(
    {IconData icon,
    String text,
    TextStyle style,
    MainAxisAlignment alignment: MainAxisAlignment.start}) {
  if (isNotNull(text)) {
    return new Row(
      mainAxisAlignment: alignment,
      children: nonNullWidgets([
        when(
          icon,
          (_) => Icon(
                icon,
                color: style?.color,
                size: style?.fontSize,
              ),
        ),
        when(
          icon,
          (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
              ),
        ),
        Text(
          text,
          style: style,
        ),
      ]),
    );
  }
}

Widget imageOrPlaceholder(Map event) {
  final String photo = getIn(event, ['featured_photo', 'photo_link']);
  return new AspectRatio(
    aspectRatio: 16.0 / 9.0,
    child: ifVal(
        photo,
        (_) => Image.network(
              photo,
              fit: BoxFit.cover,
            ),
        (_) => Container(
              color: Colors.grey.withOpacity(0.3),
              child: new Icon(
                Icons.image,
                size: 44.0,
              ),
            )),
  );
}

Widget expanded(child) {
  return when(child, (_) => new Expanded(child: child));
}
