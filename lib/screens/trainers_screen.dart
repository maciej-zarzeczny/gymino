import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trainers_provider.dart';
import '../widgets/no_data.dart';
import '../widgets/top_trainer.dart';
import '../widgets/popular_trainers.dart';
import '../widgets/trainer_pick.dart';

class TrainersScreen extends StatefulWidget {
  @override
  _TrainersScreenState createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  var _isLoading = true;

  @override
  void initState() {
    Future.microtask(() => {
      Provider.of<TrainersProvider>(context, listen: false).fetchTrainers().then((_) {
        setState(() {
          _isLoading = false;
        });
      })      
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trainersProvider = Provider.of<TrainersProvider>(context);
    final trainers = trainersProvider.trainers;
    final topTrainer = trainersProvider.topTrainer;
    final popularTrainers = trainersProvider.popularTrainers;
    trainers.remove(topTrainer);
    // trainers.shuffle();

    final mediaQuery = MediaQuery.of(context);

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: trainersProvider.fetchTrainers,
            child: trainers.isEmpty
                ? NoData(
                    'Brak dostępnych trenerów', trainersProvider.fetchTrainers)
                : Container(
                    height:
                        (mediaQuery.size.height - mediaQuery.padding.top) * 1,
                    margin: EdgeInsets.only(top: mediaQuery.padding.top),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: trainers.length + 1,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              topTrainer == null
                                  ? Container()
                                  : TopTrainer(topTrainer),
                              popularTrainers == null
                                  ? Container()
                                  : PopularTrainers(popularTrainers),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Wszyscy trenerzy',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return TrainerPick(trainers[i - 1]);
                        }
                      },
                    ),
                  ),
          );
  }
}
