import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtfifo/models/storage_models.dart';

class StorageService with ChangeNotifier {
  List<StorageBox> boxes = [];
  List<PickingOrder> orders = [];
  String _selectedBin = '000000';
  String _selectedBox = '0_0000';
  PickingOrder _selectedPickingOrder = new PickingOrder();

  List<StorageBox> get getBoxes => this.boxes;
  List<PickingOrder> get getOrders => this.orders;

  StorageService() {
    // todo
  }

  get selectedBin => this._selectedBin;
  set selectedBin(String value) {
    print("selectedBin $value");
    this._selectedBin = value;
    this.getBoxesByBin(value);
  }

  get selectedPickingOrder => this._selectedPickingOrder;
  set selectedPickingOrder(PickingOrder value) {
    this._selectedPickingOrder = value;
    this.getBoxesByPickingOrder(value);
  }

  get selectedBox => this._selectedBox;
  set selectedBox(String value) {
    print('selectedBox: $value');
    this._selectedBox = value;
    this.setBoxLocation(value, this._selectedBin);
  }

  getBoxesByBin(String location) async {
    final url =
        'http://192.168.100.3:6543/wms/storagebins/$location/storageboxes';
    try {
      final resp = await http.get(url);
      final boxesResponse = storageunitFromJson(resp.body);
      this.boxes = [];
      this.boxes.addAll(boxesResponse.storageboxes);
      print('load ok');
      notifyListeners();
    } catch (_) {
      print('response error $_');
    }
  }

  fetchOrders() async {
    final url = 'http://192.168.100.3:6543/wms/pickingorders';
    try {
      final resp = await http.get(url);
      final ordersResponse = pickingorderlistFromJson(resp.body);
      this.orders = [];
      this.orders.addAll(ordersResponse.pickingorders);
      print('load ok');
      notifyListeners();
    } catch (_) {
      print('response error $_');
    }
  }

  getBoxesByPickingOrder(PickingOrder pickingorder) async {
    var pickingorderid = pickingorder.id;
    final url =
        'http://192.168.100.3:6543/wms/pickingorders/$pickingorderid/storageboxes';
    try {
      final resp = await http.get(url);
      final boxesResponse = pickingorderFromJson(resp.body);
      this.boxes = [];
      this.boxes.addAll(boxesResponse.storageboxes);
      print('load ok');
      notifyListeners();
    } catch (_) {
      print('response error $_');
    }
  }

  setBoxStatus(String box, int status) async {
    final url = 'http://192.168.100.3:6543/wms/storageboxes/$box';
    Map<String, String> headers = {"Content-type": "application/json"};
    String payload = '{"id": "$box", "status": "$status"}';
    print(payload);
    try {
      final resp = await http.put(url, headers: headers, body: payload);
      print('load ok $resp');
      notifyListeners();
      getBoxesByPickingOrder(_selectedPickingOrder);
    } catch (_) {
      print('response error $_');
    }
  }

  setBoxLocation(String box, String location) async {
    final url =
        'http://192.168.100.3:6543/wms/storagebins/$location/storageboxes/$box';

    try {
      final resp = await http.put(url);
      print('load ok $resp');
      this.getBoxesByBin(location);
      notifyListeners();
    } catch (_) {
      print('response error $_');
    }
  }
}
