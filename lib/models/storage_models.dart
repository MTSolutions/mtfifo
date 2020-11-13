import 'package:flutter/material.dart';
import 'dart:convert';

Warehouse warehouseFromJson(String str) => Warehouse.fromJson(json.decode(str));

String warehouseToJson(Warehouse data) => json.encode(data.toJson());

class Warehouse {
  Warehouse({
    this.storagebins,
  });

  List<StorageBin> storagebins;

  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
    storagebins: List<StorageBin>.from(
        json["storagebins"].map((x) => StorageBin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "storagebins": List<dynamic>.from(storagebins.map((x) => x.toJson())),
  };
}

StorageBin storagebinFromJson(String str) =>
    StorageBin.fromJson(json.decode(str));
String storagebinToJson(StorageBin data) => json.encode(data.toJson());

class StorageBin {
  StorageBin({
    this.storageunits,
    this.id,
    this.location,
  });

  List<StorageUnit> storageunits;
  int id;
  String location;

  factory StorageBin.fromJson(Map<String, dynamic> json) => StorageBin(
    storageunits: List<StorageUnit>.from(
        json["storageunits"].map((x) => StorageUnit.fromJson(x))),
    id: json["id"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "storageunits": List<dynamic>.from(storageunits.map((x) => x.toJson())),
    "id": id,
    "location": location,
  };
}

StorageUnit storageunitFromJson(String str) =>
    StorageUnit.fromJson(json.decode(str));
String storageunitToJson(StorageUnit data) => json.encode(data.toJson());

class StorageUnit {
  StorageUnit({
    this.id,
    this.storageboxes,
  });

  int id;
  List<StorageBox> storageboxes;

  factory StorageUnit.fromJson(Map<String, dynamic> json) => StorageUnit(
    id: json["id"],
    storageboxes: List<StorageBox>.from(
      json["storageboxes"].map((x) => StorageBox.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "storageboxes": List<dynamic>.from(storageboxes.map((x) => x.toJson())),
  };
}

class StorageBox {
  StorageBox({this.oc, this.id, this.name, this.expiration});

  String oc;
  int id;
  String name;
  String expiration;

  factory StorageBox.fromJson(Map<String, dynamic> json) => StorageBox(
    oc: json["oc"],
    id: json["id"],
    name: json["name"],
    expiration: json["expiration"],
  );

  Map<String, dynamic> toJson() => {
    "oc": oc,
    "id": id,
    "name": name,
    "expiration": expiration,
  };
}