import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trainer.dart';
import '../widgets/keyword.dart';
import '../models/question.dart';
import '../providers/trainers_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/more_loading_indicator.dart';
import '../widgets/custom_text_input.dart';

class TrainerInfoScreen extends StatefulWidget {
  static const routeName = '/trainerInfo';

  @override
  _TrainerInfoScreenState createState() => _TrainerInfoScreenState();
}

class _TrainerInfoScreenState extends State<TrainerInfoScreen> {
  bool _infoChoosen = true;
  bool _isLoading = true;
  bool _moreLoading = false;
  Trainer _trainer;
  List<Question> _questions;
  List<dynamic> _supplements = [];
  ScrollController _scrollController = ScrollController();
  final TextEditingController _askQuestionController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      _trainer = ModalRoute.of(context).settings.arguments as Trainer;
      var trainersProvider =
          Provider.of<TrainersProvider>(context, listen: false);
      if (trainersProvider.questions.isEmpty ||
          _trainer.id != trainersProvider.currentTrainerId) {
        trainersProvider.fetchQuestions(_trainer.id).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _moreLoading = true;
          });

          if (!trainersProvider.allQuestionsLoaded) {
            trainersProvider.fetchMoreQuestions().then((_) {
              setState(() {
                _moreLoading = false;
              });
            });
          } else {
            double edge = 50.0;
            double offsetFromBottom =
                _scrollController.position.maxScrollExtent -
                    _scrollController.position.pixels;
            if (offsetFromBottom < edge) {
              _scrollController
                  .animateTo(
                      _scrollController.offset - (edge - offsetFromBottom),
                      duration: new Duration(milliseconds: 500),
                      curve: Curves.easeOut)
                  .then((_) {
                setState(() {
                  _moreLoading = false;
                });
              });
            }
          }
        }
      });
    });
    super.initState();
  }

  void infoChoosed() {
    setState(() {
      _infoChoosen = true;
    });
  }

  void faqChoosed() {
    setState(() {
      _infoChoosen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final trainersProvider =
        Provider.of<TrainersProvider>(context, listen: false);
    _questions = trainersProvider.questions;

    if (_trainer != null) {
      _supplements = trainersProvider.findById(_trainer.id).supplements;
    }

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  children: <Widget>[
                    header(context, _trainer),
                    picker(context),
                    _infoChoosen ? infoPage() : questionsPage(),
                    _infoChoosen ? Container() : askQuestion(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget infoPage() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(0.0),
        itemCount: _supplements.length == 0
            ? _supplements.length + 1
            : _supplements.length + 2,
        itemBuilder: (context, index) {
          bool last = _supplements.length == index - 1;
          if (index == 0) {
            return infoGrid([
              _trainer.age.toString(),
              '${_trainer.height} cm',
              '${_trainer.weight} kg',
              '${_trainer.trainingTime} lat',
            ], [
              'Wiek',
              'Wzrost',
              'Waga',
              'Staż treningowy'
            ]);
          } else if (index == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Text(
                'Suplementacja',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          } else {
            return supplementItem(
              _supplements[index - 2]['name'],
              _supplements[index - 2]['amount'],
              _supplements[index - 2]['portionsPerDay'],
              _supplements[index - 2]['comment'],
              _supplements[index - 2]['imageUrl'],
              last,
            );
          }
        },
      ),
    );
  }

  Widget questionsPage() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(0.0),
        itemCount: _questions.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Text(
                'Ostatnio dodane',
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          } else if (index == _questions.length + 1) {
            return MoreLoadingIndicator(_moreLoading);
          } else {
            return QuestionCard(
              _questions[index - 1].question,
              _questions[index - 1].answer,
            );
          }
        },
      ),
    );
  }

  Widget header(context, Trainer trainer) {
    return Container(
      width: double.infinity,
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top) *
          0.3,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0.0, 5.0),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            width: double.infinity,
            imageUrl: trainer.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorWidget: (context, url, error) => Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.black12,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              iconSize: 30,
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        trainer.numberOfFollowers,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 23),
                      ),
                    ),
                  ],
                ),
                Text(trainer.name, style: Theme.of(context).textTheme.title),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: trainer.keywords.map((keyword) {
                      return Keyword(keyword, false);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget askQuestion(context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.15,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        top: 10.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            'Zadaj pytanie',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              CustomTextInput(
                hintText: 'Treść pytania...',
                controller: _askQuestionController,
                isPassword: false,
                withIcon: false,
                color: Theme.of(context).primaryColor,
              ),
              Icon(
                Icons.send,
                color: Theme.of(context).accentColor,
                size: 35,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget supplementItem(String name, int amount, int portionsPerDay,
      String comment, String imageUrl, bool isLast) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      margin: isLast
          ? EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 5.0,
              bottom: MediaQuery.of(context).padding.bottom + 5.0,
            )
          : const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage('assets/images/supplements/$imageUrl'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black26,
            BlendMode.darken,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              name,
              style: Theme.of(context).textTheme.title.copyWith(fontSize: 30),
            ),
            SizedBox(height: 5),
            Text(
              '$amount g - $portionsPerDay x dziennie',
              style: Theme.of(context)
                  .textTheme
                  .display2
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoGrid(titles, data) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            infoGridTile(context, titles[0], data[0]),
            infoGridTile(context, titles[1], data[1]),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            infoGridTile(context, titles[2], data[2]),
            infoGridTile(context, titles[3], data[3]),
          ],
        ),
      ],
    );
  }

  Widget infoGridTile(BuildContext context, String title, String subtitle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 240, 240, 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.title.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                  ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(190, 190, 190, 1.0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget picker(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: infoChoosed,
            child: Container(
              child: Text(
                'Informacje',
                style: TextStyle(
                  color: _infoChoosen
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              margin: const EdgeInsets.only(right: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                  color: _infoChoosen
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15.0)),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
          GestureDetector(
            onTap: faqChoosed,
            child: Container(
              child: Text(
                'Pytania',
                style: TextStyle(
                  color: !_infoChoosen
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              margin: const EdgeInsets.only(left: 5.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                  color: !_infoChoosen
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
