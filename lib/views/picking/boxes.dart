import 'package:flutter/material.dart';
import 'package:mtfifo/models/storage_models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:mtfifo/services/storage_service.dart';

class PickingBoxesView extends StatefulWidget {
  PickingBoxesView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PickingBoxesViewState createState() => _PickingBoxesViewState();
}

class _PickingBoxesViewState extends State<PickingBoxesView> {
  static const channel = const MethodChannel('mtfifo/scannercode');
  int _selectedIndex = 0;
  String _orderFilter = 'pending';

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(channelHandler);
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    final storageService = Provider.of<StorageService>(context, listen: false);
    switch (methodCall.method) {
      case 'scannercode':
        print('boxes!: ${methodCall.arguments}');

        // first three letters for command, rest is payload
        String command = methodCall.arguments.substring(0, 3);
        String payload =
            methodCall.arguments.substring(3, methodCall.arguments.length);

        switch (command) {
          case 'BIN':
            print("BIN $payload");
            break;
          case 'BOX':
            print("BOX $payload");
            var box = payload;
            storageService.setBoxStatus(box, _selectedIndex);
            break;
          default:
          // XXX
        }
        return methodCall.arguments;

      default:
      // todo - throw not implemented
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _orderFilter = 'pending';
      } else {
        _orderFilter = 'picked';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);

    var filteredboxes =
        storageService.boxes.where((f) => f.status == _orderFilter).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(children: <Widget>[
        SizedBox(height: 10),
        Expanded(child: StorageBoxItemList(filteredboxes)),
      ])),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Pendientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Listos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[900],
        onTap: _onItemTapped,
      ),
    );
  }
}

class StorageBoxItemList extends StatelessWidget {
  final List<StorageBox> boxes;

  const StorageBoxItemList(this.boxes);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) =>
            Divider(color: Colors.grey[300], height: 2.0),
        itemCount: this.boxes.length,
        itemBuilder: (BuildContext context, int index) {
          return StorageBoxItemView(box: this.boxes[index], index: index);
        });
  }
}

class StorageBoxItemView extends StatelessWidget {
  final StorageBox box;
  final int index;

  const StorageBoxItemView({@required this.box, @required this.index});

  @override
  Widget build(BuildContext context) {
    var oc = this.box.oc;
    var location = this.box.location;
    var status = this.box.status;
    return ListTile(
        title: Text(this.box.name),
        subtitle: Text("$oc / $status"),
        trailing: Text("$location"),
        onTap: () {
          print("TileTap!");
        });
  }
}
