import 'package:flutter/material.dart';

import '../globals.dart';

class Badge extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool withIcon;

  Badge({
    this.text,
    this.icon,
    this.withIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 26, 26, 0.7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          withIcon
              ? Icon(
                  icon,
                  color: Global().canvasColor,
                  size: 15,
                )
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
          withIcon
              ? SizedBox(width: 5.0)
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
          Text(
            text,
            style: Theme.of(context).textTheme.overline.copyWith(
                  color: Global().canvasColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
          )
        ],
      ),
    );
  }
}
