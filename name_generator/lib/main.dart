import 'package:flutter/material.dart';
import 'package:name_generator/shared_preferences.dart';
import 'package:name_generator/sqlite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Persistant Storage Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SQLiteExample(title: 'Startup Name Generator'));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text('SQLite Example'),
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    SQLiteExample(title: 'Startup Name Generator'))),
          ),
          RaisedButton(
            child: Text('SharedPreference Example'),
            onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) =>
                    SharedPreferencesExample(title: 'Startup Name Generator'))),
          ),
        ],
      ),
    ));
  }
}
