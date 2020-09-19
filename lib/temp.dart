import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom NavBar Demo',
      home: BottomNavigationBarController(),
    );
  }
}





class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSubPage())),
          child: Text('Open Sub-Page'),
        ),
      ),
    );
  }
}

class HomeSubPage extends StatefulWidget {
  const HomeSubPage({Key key}) : super(key: key);

  @override
  _HomeSubPageState createState() => _HomeSubPageState();
}

class _HomeSubPageState extends State<HomeSubPage> with AutomaticKeepAliveClientMixin{
  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;


  String _text;

  @override
  void initState() {
    _text = 'Click me';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Sub Page'),
      ),
      body: Center(
        child: Column(
          children: [
            RaisedButton(
              onPressed: () => setState(() => _text = 'Clicked'),
              child: Text(_text),
            ),
           FlatButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => InnerPage()));
          }, child: Text('go to inner page'))
          ],
        ),
      ),
    );
  }

}

class InnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(child: Center(child: Text('inner page'),),),
          FlatButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSubPage()));
          }, child: Text('go to sub home page'))
        ],
      ),
    );
  }
}

/* convert it to statfull so i can use AutomaticKeepAliveClientMixin to avoid disposing tap */

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin{

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Text('Settings Page'),
            ),
            FlatButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSubPage()));
          }, child: Text('go to sub home page'))
          ],
        ),
      ),
    );
  }

}