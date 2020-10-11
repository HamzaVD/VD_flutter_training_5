import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteExample extends StatefulWidget {
  SQLiteExample({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SQLiteExampleState createState() => _SQLiteExampleState();
}

class _SQLiteExampleState extends State<SQLiteExample> {
  final ageController = TextEditingController();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Database _database;
  List<Dog> _dogs = List<Dog>();

  @override
  void initState() {
    super.initState();
    _createDB();
  }

  _createDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database =
        await openDatabase(join(await getDatabasesPath(), 'doggie_database.db'),
            onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    }, version: 1);
    dogs();
  }

  dogs() async {
    List<Map<String, dynamic>> maps = await _database.query('dogs');
    _dogs = List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
    setState(() {});
  }

  Future<void> insertDog(Dog dog, BuildContext context) async {
    await _database.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await dogs();
  }

  Future<void> updateDog(Dog dog) async {
    await _database.update(
      'dogs',
      dog.toMap(),
      where: "id = ?",
      whereArgs: [dog.id],
    );
    dogs();
  }

  Future<void> deleteDog(int id) async {
    await _database.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
    dogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          ListTile(
            title: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: idController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'New Dog ID'),
                    validator: (value) =>
                        value.isEmpty ? 'Requires an id' : null,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(hintText: 'New Dog Name'),
                    validator: (value) =>
                        value.isEmpty ? 'Requires a name' : null,
                  ),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'New Dog Age'),
                    validator: (value) =>
                        value.isEmpty ? 'Requires an age' : null,
                  ),
                ],
              ),
            ),
            subtitle: RaisedButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) return;
                final newDog = Dog(
                    id: int.parse(idController.text),
                    name: nameController.text,
                    age: int.parse(ageController.text));
                await insertDog(newDog, context);
              },
              child: Text('Insert New Dog Data'),
            ),
          ),
          _dogs.length == 0
              ? Center(child: Container(child: Text("No data found")))
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _dogs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${_dogs[index].name}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Age: ${_dogs[index].age}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () async =>
                                  await deleteDog(_dogs[index].id),
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }
}

class Dog {
  Dog({this.id, this.name, this.age});

  final int age;
  final int id;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
