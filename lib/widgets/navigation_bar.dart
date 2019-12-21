import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final Function onItemTapped;
  final int currentIndex;

  NavigationBar({
    this.onItemTapped,
    this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).primaryColor,
      ),
      child: new BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('Saved'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text('Profile'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: onItemTapped,
        currentIndex: currentIndex,
        // showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 27,
      ),
    );
  }
}
