import 'package:flutter/material.dart';

class MoreLoadingIndicator extends StatelessWidget {
  final bool moreLoading;

  MoreLoadingIndicator(this.moreLoading);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Opacity(
          opacity: moreLoading ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
      ),
      ),
    );
  }
}
