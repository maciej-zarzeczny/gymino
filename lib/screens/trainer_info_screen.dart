import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../models/trainer.dart';
import '../widgets/keyword.dart';
import '../providers/trainers_provider.dart';
import '../size_config.dart';

class TrainerInfoScreen extends StatefulWidget {
  static const routeName = '/trainerInfo';

  @override
  _TrainerInfoScreenState createState() => _TrainerInfoScreenState();
}

class _TrainerInfoScreenState extends State<TrainerInfoScreen> {
  Trainer _trainer;
  List<dynamic> _supplements = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final trainersProvider =
        Provider.of<TrainersProvider>(context, listen: false);
    _trainer = ModalRoute.of(context).settings.arguments as Trainer;

    if (_trainer != null) {
      _supplements = trainersProvider.findById(_trainer.id).supplements;
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header(context, _trainer),
          Container(
            height: 10.0,
            color: Colors.white,
          ),
          infoPage(),
        ],
      ),
    );
  }

  Widget infoPage() {
    return Expanded(
      child: Container(
        color: Colors.white,
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
                padding: const EdgeInsets.all(10.0),
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
      ),
    );
  }

  Widget header(context, Trainer trainer) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.black45,
            offset: Offset(0.0, 5.0),
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
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(                
                onPressed: () => Navigator.of(context).pop(),
                icon: Global().backArrow(),             
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
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
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: SizeConfig.safeBlockHorizontal * 7.0),
            ),
            SizedBox(height: 5),
            Text(
              '$amount g - $portionsPerDay x dziennie',
              style: Theme.of(context).textTheme.display2.copyWith(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoGrid(titles, data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Text(
            'Informacje',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
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
                    fontSize: SizeConfig.safeBlockHorizontal * 7.0,
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
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
