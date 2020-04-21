import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mtfifo/models/storageunit.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_svg/flutter_svg.dart';


final List<String> entries = <String>['A'];


Future<Bins> fetchBins() async {
  var response = await http.get('http://172.105.153.220:8080/warehouse/bins');
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
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => MainView(title: 'MTwms'),
        '/fifo': (BuildContext context) => FIFOView(title: 'MTwms FIFO'),
        '/info': (BuildContext context) => InfoView()
      }
    );
  }
}

class MainView extends StatefulWidget {
  MainView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: <Widget>[
          DashboardButton(icon: Icons.file_download, title: 'Colocar'),
          DashboardButton(icon: Icons.file_upload, title: 'Extraer'),
          DashboardButton(icon: Icons.playlist_add_check, title: 'FIFO'),
        ],
      ),
    );
  }
}

class FIFOView extends StatefulWidget {
  FIFOView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FIFOViewState createState() => _FIFOViewState();
}

class _FIFOViewState extends State<FIFOView> {

  Future<Bins> bins;

  static const channel = const MethodChannel('mtfifo/scannercode');

  _FIFOViewState({this.bins}) : super();

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(channelHandler);
    bins = fetchBins();
  }

  Future<void> updateBins() async {
    print('updateBins()');
    channel.setMethodCallHandler(channelHandler);
    setState(() {
      bins = fetchBins();
    });
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'scannercode':
        print('channelHandler');
        print(methodCall.arguments);
        print('channelHander fetchBins()');
        print('bins: ${this.bins}');

        if (methodCall.arguments == "exit") {
          Navigator.pushNamed(context, "/");
        }

        final response = await http.get('http://172.105.153.220:8080/markbin/${methodCall.arguments}');
        var jsond = json.decode(response.body);
        setState(() {
          bins = fetchBins();
        });
        print('message: ${jsond["message"]}');
        Navigator.pushNamed(context, '/info');
        return methodCall.arguments;
        
      default:
        // todo - throw not implemented
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  Navigator.pushNamed(context, '/info',
                    arguments: StorageUnit(
                      id: product.id, 
                      ts: product.ts, 
                      weight: product.weight)
                  );
                }
              )).toList()           
            ).toList()
          )
        ); 
      }
    );
  }
}

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

class DashboardButton extends StatelessWidget {
  const DashboardButton({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.button;
        return Card(
          color: Colors.white,
          child: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(this.icon, size: 40.0, color: textStyle.color),
                SizedBox(height: 15),
                Text(this.title, style: textStyle),
          ]
        ),
      )
    );
  }
}


