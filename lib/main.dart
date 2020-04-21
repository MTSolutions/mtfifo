import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtfifo/views/info.dart';
import 'package:mtfifo/views/fifo.dart';

import 'package:flutter_svg/flutter_svg.dart';



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
          DashboardButton(icon: "assets/colocar.svg", title: 'Colocar'),
          DashboardButton(icon: "assets/extraer.svg", title: 'Extraer'),
          DashboardButton(icon: "assets/fifo.svg", title: 'Ordenes'),
        ],
      ),
    );
  }
}


class DashboardButton extends StatelessWidget {
  const DashboardButton({Key key, this.title, this.icon}) : super(key: key);
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.button;
        return Card(
          color: Colors.white,
          child: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(this.icon, semanticsLabel: this.title),
                SizedBox(height: 15),
                Text(this.title, style: textStyle),
          ]
        ),
      )
    );
  }
}


