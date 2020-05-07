import 'package:flutter/material.dart';
import 'package:garagedooropener/app.dart';

import 'package:provider/provider.dart';
import './classes/classes.dart';

import 'classes/settings.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppBarBottomSampleState createState() => _AppBarBottomSampleState();
}

class _AppBarBottomSampleState extends State<App>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool cani;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() => {print(this.cani)});
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlutterBlueDevices()),
        ChangeNotifierProvider(create: (_) => UtilsData()),
        ChangeNotifierProvider(create: (_) => Settings()),
      ],
      child: MaterialApp(
        home: DefaultTabController(
            length: 2, child: MainScreen(tabController: _tabController)),
      ),
    );
  }
}

//  home: ControlScreen(),
//           routes: {
//             ControlScreen.id: (context) => ControlScreen(),
//             DevicesScreen.id: (context) => DevicesScreen(),
//           },
//           theme: ThemeData(
//             primaryColor: Colors.grey[800],
//             accentColor: Colors.cyan[600],
//             fontFamily: 'arial',
//             textTheme: TextTheme(
//               headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//               title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//               body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//             ),
//           ),
