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

  @override
  void initState() {
    super.initState();
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
        Expanded(child: StorageBoxItemList(storageService.boxes)),
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
        selectedItemColor: Colors.yellow[900],
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
    return ListTile(
      title: Text(this.box.name),
      subtitle: Text(this.box.oc),
      trailing: Text(this.box.location),
      onTap: () {
        print("TileTap!");
      }
    );
  }
}
