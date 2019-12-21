import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String badgeText;
  final bool withIcon;

  Badge(this.badgeText, this.withIcon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7.0),
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      constraints: withIcon ? BoxConstraints(maxWidth: 80) : BoxConstraints(minWidth: 100),
      child: withIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Text(
              badgeText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }
}
