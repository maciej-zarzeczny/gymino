import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import '../providers/trainers_provider.dart';
import '../widgets/no_data.dart';
import '../widgets/top_trainer.dart';
import '../widgets/popular_trainers.dart';
import '../widgets/trainer_pick.dart';
import '../widgets/more_loading_indicator.dart';
import '../widgets/custom_title.dart';

class TrainersScreen extends StatefulWidget {
  @override
  _TrainersScreenState createState() => _TrainersScreenState();
}

class _TrainersScreenState extends State<TrainersScreen> {
  var _isLoading = true;
  var _moreLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Future.microtask(() {
      var trainersProvider =
          Provider.of<TrainersProvider>(context, listen: false);
      if (trainersProvider.trainers.isEmpty) {
        trainersProvider.fetchTrainers().then((_) {
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

          if (!trainersProvider.allTrainersLoaded) {
            trainersProvider.fetchMoreTrainers().then((_) {
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
        ? Global().loadingIndicator(context)
        : trainers.isEmpty
            ? NoData('Brak dostępnych trenerów', trainersProvider.fetchTrainers)
            : Container(
                height: mediaQuery.size.height - mediaQuery.padding.top,
                margin: EdgeInsets.only(top: mediaQuery.padding.top),
                color: Global().canvasColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  controller: _scrollController,
                  itemCount: trainers.length + 2,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[                          
                          topTrainer == null
                              ? Container()
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomTitle('Najczęściej wybierany'),
                                  TopTrainer(topTrainer),
                                ],
                              ),
                          popularTrainers == null
                              ? Container()
                              : PopularTrainers(popularTrainers), 
                          CustomTitle('Wszyscy'),                         
                        ],
                      );
                    } else if (i == trainers.length + 1) {
                      return MoreLoadingIndicator(_moreLoading);
                    } else {
                      return TrainerPick(trainers[i - 1]);
                    }
                  },
                ),
              );
  }
}
