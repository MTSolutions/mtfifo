import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mtfifo/services/storage_service.dart';
import 'package:mtfifo/views/bin/bin.dart';
import 'package:mtfifo/views/picking/orders.dart';
import 'package:mtfifo/views/picking/boxes.dart';

import 'package:flutter_svg/flutter_svg.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> new StorageService())
      ],
      child: MaterialApp(
        title: 'MTFIFO',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => MainView(title: 'MTwms'),
          '/orders': (BuildContext context) => OrdersView(title: 'Ordenes de Picking'),
          '/pickingboxes': (BuildContext context) => PickingBoxesView(title: 'Items'),
          '/bin': (BuildContext context) => BinView(title: 'Bin'),
        }
      ),
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
          DashboardButton(icon: "assets/colocar.svg", title: 'Stock por Bin', view: '/bin'),
          DashboardButton(icon: "assets/fifo.svg", title: 'Picking', view: '/orders')
        ],
      ),
    );
  }
}


class DashboardButton extends StatelessWidget {
  const DashboardButton({Key key, this.title, this.icon, this.view}) : super(key: key);
  final String title;
  final String icon;
  final String view;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.button;
    return GestureDetector(
      onTap: () {
        print(this.title);
        Navigator.pushNamed(context, this.view);
      },
      child: Card(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(this.icon, semanticsLabel: this.title),
              SizedBox(height: 15),
              Text(this.title, style: textStyle),
            ]
          ),
        )
      )
    );
  }
}