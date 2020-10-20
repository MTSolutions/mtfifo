import 'package:flutter/material.dart';

class ExtraerView extends StatefulWidget {
  ExtraerView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ExtraerViewState createState() => _ExtraerViewState();
}

class _ExtraerViewState extends State<ExtraerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Seleccione Ubicación",
                  prefixIcon: Icon(Icons.settings_remote)
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}