import 'package:flutter/material.dart';
import 'package:mtfifo/models/storageunit.dart';

class InfoView extends StatefulWidget {

  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StorageUnit args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.id),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.beenhere, size: 50),
                  title: Text(args.id),
                  subtitle: Text(args.ts)
                )
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Mover a Producción"),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {

                    },
                    child: Text("Bloquear"),
                  ),
                ]
              )
            ]
          )
        )
      );
  }
}