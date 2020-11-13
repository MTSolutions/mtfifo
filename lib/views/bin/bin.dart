import 'package:flutter/material.dart';
import 'package:mtfifo/models/storage_models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:mtfifo/services/storage_service.dart';

class BinView extends StatefulWidget {
  BinView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BinViewState createState() => _BinViewState();
}

class _BinViewState extends State<BinView> {
  static const channel = const MethodChannel('mtfifo/scannercode');

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(channelHandler);
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'scannercode':
        print('scannercode: ${methodCall.arguments}');
        final storageService = Provider.of<StorageService>(context, listen: false);

        // first three letters for command, rest is payload
        String command = methodCall.arguments.substring(0, 3);
        String payload = methodCall.arguments.substring(3, methodCall.arguments.length);
        
        switch (command) {
          case 'BIN':
            storageService.selectedBin = payload;
            break;
          case 'BOX':
            storageService.selectedBox = payload;
            break;
          default:
          // XXX
        }
        return methodCall.arguments;

      default:
      // todo - throw not implemented
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(children: <Widget>[
        SizedBox(height: 10),
        BinInfoPanel(bin: storageService.selectedBin),
        SizedBox(height: 10),
        Expanded(child: BoxItemList(storageService.getBoxes))
      ])));
  }
}

class BinInfoPanel extends StatelessWidget {
  final String bin;

  const BinInfoPanel({@required this.bin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              print('Hello');
            },
            title: Text('BIN: $bin'),
            subtitle: Text('Rack:'),
          ),
        ],
      ),
    );
  }
}

class BoxItemList extends StatelessWidget {
  final List<StorageBox> boxes;

  const BoxItemList(this.boxes);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.boxes.length,
      itemBuilder: (BuildContext context, int index) {
        return BoxItemView(box: this.boxes[index], index: index);
      });
  }
}

class BoxItemView extends StatelessWidget {
  final StorageBox box;
  final int index;

  const BoxItemView({@required this.box, @required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Text(this.box.expiration),
      title: Text(this.box.name),
      subtitle: Text(this.box.oc),
      onTap: () {
        print("TileTap!");
      });
  }
}
