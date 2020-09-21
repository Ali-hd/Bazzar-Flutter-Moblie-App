import 'package:bazzar/screens/sell.dart';
import 'package:flutter/material.dart';
import 'package:bazzar/screens/home.dart';
import 'package:bazzar/screens/profile.dart';
import 'package:bazzar/screens/post.dart';
import 'package:flutter/services.dart';

class BottomNavigationBarController extends StatefulWidget {
  BottomNavigationBarController({Key key}) : super(key: key);

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  List<int> _history = [0];
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  TabController _tabController;
  List<Widget> mainTabs;
  List<BuildContext> navStack = [null, null]; // one buildContext for each tab to store history  of navigation
  HeroController _heroController; //need to add the controller for heroanimation because custom controller doesnt have one.

  @override
  void initState() {
    super.initState();
    _heroController = HeroController(createRectTween: _createRectTween);
    _tabController = TabController(vsync: this, length: 2);
    mainTabs = <Widget>[
      Navigator(
          observers: [_heroController],
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) { // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[0] = context;
              return HomeScreen();
            });
          }),
      Navigator(
          // observers: [_heroController],
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {  // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[1] = context;
              return SellScreen();
            });
          }),
    ];
  }

  RectTween _createRectTween(Rect begin, Rect end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }

  final List<BottomNavigationBarRootItem> bottomNavigationBarRootItems = [
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.add),
        title: Text('Sell'),
      ),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: mainTabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationBarRootItems.map((e) => e.bottomNavigationBarItem).toList(),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.brown[400],
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () async{
        if (Navigator.of(navStack[_tabController.index]).canPop()) {
          Navigator.of(navStack[_tabController.index]).pop();
          setState((){ _selectedIndex = _tabController.index; });
          return false;
        }else{
          if(_tabController.index == 0){
            setState((){ _selectedIndex = _tabController.index; });
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // close the app
            return true;
          }else{
            _tabController.index = 0; // back to first tap if current tab history stack is empty
            setState((){ _selectedIndex = _tabController.index; });
            return false;
          }
        }
      },
    );
  }

  void _onItemTapped(int index) {
    _tabController.index = index;
    setState(() => _selectedIndex = index);
  }

}


class BottomNavigationBarRootItem {
  final String routeName;
  final NestedNavigator nestedNavigator;
  final BottomNavigationBarItem bottomNavigationBarItem;

  BottomNavigationBarRootItem({
    @required this.routeName,
    @required this.nestedNavigator,
    @required this.bottomNavigationBarItem,
  });
}

abstract class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  NestedNavigator({Key key, @required this.navigatorKey}) : super(key: key);
}

class HomeNavigator extends NestedNavigator {
  HomeNavigator({Key key, @required GlobalKey<NavigatorState> navigatorKey})
      : super(
    key: key,
    navigatorKey: navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => HomeScreen();
            break;
          case '/home/1':
            builder = (BuildContext context) => PostScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}





////
/* convert it to statfull so i can use AutomaticKeepAliveClientMixin to avoid disposing tap */

// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin{

//   @override
//   // implement wantKeepAlive
//   bool get wantKeepAlive => true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings Page'),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Center(
//               child: Text('Settings Page'),
//             ),
//             FlatButton(onPressed: (){
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostScreen()));
//           }, child: Text('go to sub home page'))
//           ],
//         ),
//       ),
//     );
//   }

// }