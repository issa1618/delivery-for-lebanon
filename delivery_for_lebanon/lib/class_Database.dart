import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
import 'main.dart';

import 'class_Store.dart';

class DB {
  static Future<String> addNewStore(Store s) async {
    List<DocumentSnapshot> docs = (await Firestore.instance
            .collection("Stores")
            .where("phone", isEqualTo: s.phone)
            .getDocuments())
        .documents;
    if (docs.length != 0) return "already exists";
    await Firestore.instance.collection("Stores").add(s.toFirebaseJSON());
    return "good";
  }

  List<DocumentSnapshot> values = List();
  int offset = 4; // start from 4: 10m, 3: 100m, 2: 1,000, 1: 10,000m, 0: 100,000m
  String sortBy = ["phone_asc", "phone_dec", "ownerName_asc", "ownerName_dec"][Random.secure().nextInt(4)];

  // method used is similar in concept to geohashing
  Future<List<Store>> getStores(String category, req) async {
    print(sortBy);
    print("offset: $offset val.len: ${values.length} req: $req");
    Query out;
    List<DocumentSnapshot> docs;
    if (req != "load more") {
      offset = 4;
      values.clear();
    }
    if (offset >= 1) {
      do {
        print("for offset: $offset (within ${pow(10, 5 - offset)} meters)");
        // "All where filters other than whereEqualTo() must be on the same field"
        out = Firestore.instance.collection("Stores")
          .where("category", isEqualTo: category)
          .where("lat$offset", isEqualTo: num.parse(userLocation[0].toStringAsFixed(offset)))
          .where("lon$offset", isEqualTo: num.parse(userLocation[1].toStringAsFixed(offset)))
          .orderBy(sortBy.split("_")[0], descending: sortBy.split("_")[1] == "dec"); // to use startAfter, might result in a bias
        if (values.length != 0)
          out = out.startAfter([values[values.length - 1]["phone"]]);
        docs = (await out.limit(10).getDocuments()).documents;
        print("found: ${docs.length == 10 ? "more than " : ""}${docs.length}.");
        if (docs.length == 0) offset -= 1;
      } while (docs.length == 0 && offset >= 1);
      List<Store> lst = docs.map((ds) => Store.fromSnapshot(ds)).toList();
      values = docs;
      for (Store s in lst)
        await Geolocator().placemarkFromCoordinates(s.location[0], s.location[1]).then((val) {
          Placemark p = val[0];
          s.address = "${p.administrativeArea}, ${p.locality}, ${p.name}";
        });
      return lst;
    } else
      return [].cast<Store>(); // no stores found within range of 100 km
  }
}
