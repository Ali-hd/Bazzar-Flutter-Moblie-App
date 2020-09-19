import 'package:flutter/material.dart';
import 'package:bazzar/screens/home.dart';
import 'package:bazzar/screens/profile.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int _currentTab = 0;


  void _onItemTapped(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    ); 
  }

  Widget _buildBody(){
    return Container(
    color: TabHelper.color(TabItem.red),
    alignment: Alignment.center,
    child: FlatButton(
      child: Text(
        'PUSH',
        style: TextStyle(fontSize: 32.0, color: Colors.white),
      ),
      onPressed: _push,
    )
  );
  }

  void _push() {
  Navigator.of(context).push(MaterialPageRoute(
    // we'll look at ColorDetailPage later
    builder: (context) => ColorDetailPage(
      color: Colors.green,
      title: 'heelo ',
    ),
  ));

}