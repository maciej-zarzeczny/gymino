import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final String answer;

  QuestionCard(
    this.question,
    this.answer,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        question,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          answer,
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.2,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,              
              child: Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  question,
                  style: TextStyle(
                    color: Color.fromRGBO(140, 140, 140, 1.0),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                answer,
                style: TextStyle(
                  color: Color.fromRGBO(180, 180, 180, 1.0),
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                maxLines: 2,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.help,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
