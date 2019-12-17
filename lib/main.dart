import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttertoast/fluttertoast.dart';


final List<String> entries = <String>['A'];


Future<Bins> fetchBins() async {
  var response = await http.get('http://mts1.mtsolutions.io:8000/bins');
  print('response: ${response.statusCode}');
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return Bins.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load bins');
  }
}

class Bins {
  List<Products> products;

  Bins({this.products});

  Bins.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String id;
  int weight;
  String ts;

  Products({this.id, this.weight, this.ts});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weight = json['weight'];
    ts = timeago.format(new DateTime.now().subtract(new Duration(seconds: json['ts'])), locale: 'es');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weight'] = this.weight;
    data['ts'] = this.ts;
    return data;
  }
}


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

  Future<Bins> bins;

  static const channel = const MethodChannel('mtfifo/scannercode');

  _MyHomePageState({this.bins}) : super();

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(channelHandler);
    bins = fetchBins();
  }

  Future<void> updateBins() async {
    setState(() {
      bins = fetchBins();
    });
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'scannercode':
        print(methodCall.arguments);
        print('channelHander fetchBins()');
        print('bins: ${this.bins}');
        final response = await http.get('http://mts1.mtsolutions.io:8000/markbin/${methodCall.arguments}');
        print('response: ${json.decode(response.body)}');
        var jsond = json.decode(response.body);
        print('response ${jsond["message"]}');
        setState(() {
          bins = fetchBins();
        });
        return methodCall.arguments;
      default:
        // todo - throw not implemented
    }
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
      body: new Container(
        child: new RefreshIndicator(
          child: FutureBuilder<Bins>(
            future: bins,
            builder: (context, snapshot) {
              print('builder!');
              if (snapshot.hasData) {
                print('Data: ${snapshot.data}');
                return _buildPanel(snapshot.data);
              }
              return _buildPanel(snapshot.data);
            }
          ),
          onRefresh: updateBins
        )
      )
    );
  }

  Widget _buildPanel(data) {
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
            primary: false,
            children: ListTile.divideTiles(
              context: context,
              tiles: data.products.map<Widget>((product) => ListTile(
                trailing: Text("${product.weight} KG"),
                title: Text("${product.id}"),
                subtitle: Text("Ingresado ${product.ts}"),
                onTap: () {
                  print(product.weight);
                }
              )).toList()           
            ).toList()
          )
        ); 
      }
    );
  }
}
