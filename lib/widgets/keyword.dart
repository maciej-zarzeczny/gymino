import 'package:flutter/material.dart';

class Keyword extends StatelessWidget {
  final String keyword;

  Keyword(this.keyword);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      margin: const EdgeInsets.only(left: 5.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1.0,
        ),
      ),
      constraints: BoxConstraints(minWidth: 80),
      child: Text(
        keyword,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
