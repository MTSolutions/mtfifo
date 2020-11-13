import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtfifo/models/storage_models.dart';

class StorageService with ChangeNotifier {
  List<StorageBox> boxes = [];
  String _selectedBin = '000000';
  String _selectedBox = '0_0000';

  List<StorageBox> get getBoxes => this.boxes;

  StorageService() {
    // todo
  }

  get selectedBin => this._selectedBin;
  set selectedBin(String value) {
    print("selectedBin $value");
    this._selectedBin = value;
    this.getBoxesByBin(value);
  }

  get selectedBox => this._selectedBox;
  set selectedBox(String value) {
    print('selectedBox: $value');
    this._selectedBox = value;
    this.setBoxLocation(value, this._selectedBin);
  }

  getBoxesByBin(String location) async {
    final url =
        'http://bimbo.mtsolutions.io:6543/wms/storagebins/$location/storageboxes';
    try {
      final resp = await http.get(url);
      final boxesResponse = storageunitFromJson(resp.body);
      this.boxes = [];
      this.boxes.addAll(boxesResponse.storageboxes);
      print('load ok');
      notifyListeners();
    } catch (_) {
      print('response error');
    }
  }

  setBoxLocation(String box, String location) async {
    final url =
        'http://bimbo.mtsolutions.io:6543/wms/storagebins/$location/storageboxes/$box';

    try {
      final resp = await http.put(url);
      print('load ok $resp');
      this.getBoxesByBin(location);
      notifyListeners();
    } catch (_) {
      print('response error');
    }
  }
}
