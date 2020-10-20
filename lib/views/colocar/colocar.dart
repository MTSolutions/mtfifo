import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            child: Column(children: <Widget>[
          SizedBox(height: 10),
          Card(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Seleccione Ubicación",
                prefixIcon: Icon(Icons.settings_remote),
              ),
            ),
          ),
          SizedBox(height: 10),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: SvgPicture.asset("assets/colocar.svg",
                      semanticsLabel: "Bin"),
                  title: Text('BIN:'),
                  subtitle: Text('Rack:'),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            primary: false,
            children: <Widget>[
              ListTile(
                  trailing: Text("Trailing"),
                  title: Text("Title"),
                  subtitle: Text("Subtitle"),
                  onTap: () {
                    print("TileTap!");
                  }
                ),
                ListTile(
                  trailing: Text("Trailing"),
                  title: Text("Title"),
                  subtitle: Text("Subtitle"),
                  onTap: () {
                    print("TileTap!");
                  })
            ]),
        ])));
  }
}
