import 'package:flutter/material.dart';
import 'package:mtfifo/models/storage_models.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:mtfifo/services/storage_service.dart';

class OrdersView extends StatefulWidget {
  OrdersView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  static const channel = const MethodChannel('mtfifo/scannercode');

  @override
  void initState() {
    super.initState();
    channel.setMethodCallHandler(channelHandler);

    final storageService = Provider.of<StorageService>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => storageService.fetchOrders());
  }

  Future<dynamic> channelHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'scannercode':
        print('scannercode: ${methodCall.arguments}');

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
          Expanded(child: OrderItemList(storageService.getOrders)),
        ]),
      ),
       
    );
  }
}

class OrderItemList extends StatelessWidget {
  final List<PickingOrder> orders;

  const OrderItemList(this.orders);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey[300], height: 2.0),
      itemCount: this.orders.length,
      itemBuilder: (BuildContext context, int index) {
        return OrderItemView(order: this.orders[index], index: index);
      });
  }
}

class OrderItemView extends StatelessWidget {
  final PickingOrder order;
  final int index;

  const OrderItemView({@required this.order, @required this.index});

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);
    var orderlength = this.order.storageboxes.length;
    return ListTile(
      title: Text(this.order.code),
      onTap: () {
        print("TileTap!");
        storageService.boxes = [];
        storageService.selectedPickingOrder = this.order;
        Navigator.pushNamed(context, '/pickingboxes');
      },
      subtitle: Text("Items: $orderlength"),
    );
  }
}
