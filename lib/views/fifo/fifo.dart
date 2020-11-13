import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;



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
                trailing: Text("${product.name} KG"),
                title: Text("${product.id}"),
                subtitle: Text("Ingresado ${product.name}"),
                onTap: () {
                  print(product.name);
                }
              )).toList()           
            ).toList()
          )
        ); 
      }
    );
  }
}