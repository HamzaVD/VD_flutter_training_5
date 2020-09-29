import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  final String title;

  const Testing({Key key, this.title}) : super(key: key);
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing'),
      ),
    );
  }
}
