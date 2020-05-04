import 'package:flutter/material.dart';

class ColocarView extends StatefulWidget {
  ColocarView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ColocarViewState createState() => _ColocarViewState();
}

class _ColocarViewState extends State<ColocarView> {

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