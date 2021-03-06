import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesExample extends StatefulWidget {
  final String title;

  const SharedPreferencesExample({Key key, this.title}) : super(key: key);
  @override
  _SharedPreferencesExampleState createState() =>
      _SharedPreferencesExampleState();
}

class _SharedPreferencesExampleState extends State<SharedPreferencesExample> {
  final _suggestions = <WordPair>[];
  List<String> _saved = List<String>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    fetchDataFromSharedPreference();
  }

  fetchDataFromSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('favs')) {
      _saved = prefs.getStringList('favs');
    }
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (String word) {
              return ListTile(
                title: Text(
                  word,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
          // IconButton(
          //     tooltip: "Check Shared Preference Data",
          //     icon: Icon(Icons.print),
          //     onPressed: () async {
          //       SharedPreferences prefs = await SharedPreferences.getInstance();
          //       print(prefs.getStringList('favs'));
          //     })
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair.asPascalCase);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (alreadySaved) {
            _saved.remove(pair.asPascalCase);
            prefs.setStringList('favs', _saved);
          } else {
            _saved.add(pair.asPascalCase);
            prefs.setStringList('favs', _saved);
          }
          print(prefs.getStringList('favs'));
          setState(() {});
        },
      ),
    );
  }
}
