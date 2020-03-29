import 'dart:ui';

import 'package:flutter/material.dart';

import '../globals.dart';
import '../widgets/button.dart';

class SubscriptionScreen extends StatefulWidget {
  static const String routeName = '/subscription';

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _choosedOption = 1;

  void _setOption(int option) {
    setState(() {
      _choosedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login_image.jpg'),
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _appBar,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20.0),
                            Text(
                              'Wykup subskrypcję',
                              style: Theme.of(context).textTheme.display1.copyWith(color: Global().canvasColor, fontSize: 30),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Subskrypcja daje dostęp do wszystkich treningów wybranego przez siebie trenera. Poniżej wybierz ilu trenerów chcesz subskrybować',
                              style: Theme.of(context).textTheme.body1.copyWith(color: Global().canvasColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _setOption(1),
                            child: subscriptionOption(context, '1 trener', 19.99, _choosedOption == 1),
                          ),
                          GestureDetector(
                            onTap: () => _setOption(2),
                            child: subscriptionOption(context, '2 trenerów', 39.99, _choosedOption == 2),
                          ),
                          GestureDetector(
                            onTap: () => _setOption(3),
                            child: subscriptionOption(context, '3 trenerów', 59.99, _choosedOption == 3),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                        child: Button(
                          text: 'Kupuję',
                          onTapFunction: () => print('buy subscription'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget subscriptionOption(BuildContext context, String title, double price, bool isChosen) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: isChosen ? 5.0 : 2.0,
          color: isChosen ? Theme.of(context).accentColor : Global().mediumGrey,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.display1.copyWith(
                  color: isChosen ? Global().canvasColor : Global().mediumGrey,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            price.toString() + ' zł',
            style: Theme.of(context).textTheme.display1.copyWith(
                  fontSize: 30,
                  color: isChosen ? Global().canvasColor : Global().mediumGrey,
                ),
          ),
          Text(
            'miesięcznie',
            style: Theme.of(context).textTheme.body2.copyWith(
                  color: isChosen ? Global().canvasColor : Global().mediumGrey,
                ),
          ),
        ],
      ),
    );
  }
}
