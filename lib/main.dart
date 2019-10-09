import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

final List<String> entries = <String>['A'];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTFIFO',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'MTcontrol FIFO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  String _scannerCode = 'No CODE';

  static const platform = const MethodChannel('mtfifo/scannercode');

  Future<void> _getScannerCode() async {
    String scannerCode;
    try {
      final String result = await platform.invokeMethod('getScannerCode');
      scannerCode = 'CODE: $result % .';
    } on PlatformException catch (e) {
      scannerCode = "Failed to get code: '${e.message}'.";
    }

    setState(() {
      _scannerCode = scannerCode;
    }); 
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _buildPanel()
    );
  }

  Widget _buildPanel() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 3,
          margin: EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text(_scannerCode,
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  leading: Icon(
                    Icons.restaurant_menu,
                    color: Colors.blue[500],
                  ),
                  dense: false,
                  onTap: () {
                    _getScannerCode();
                    print(_scannerCode);
                  }
                ),
                ListTile(
                  title: Text('Producto 1'),
                  onTap: () {
                    print("Hello 1");
                  }
                ),
                ListTile(
                  title: Text('Producto 2'),
                  onTap: () {
                    print("Hello 2");
                  }
                ),
              ]
            ).toList()
          )
        ); 
      }
    );
  }
}
