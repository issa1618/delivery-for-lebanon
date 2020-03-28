import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class Store {
  String name, ownerName, category, phone, address;
  List<double> location;

  Store(this.name, this.ownerName, this.phone, this.category, this.location, this.address);

  // used by database auto populator only
  Store.fromList(List<String> lst) {
    name = lst[0];
    phone = lst[1];
    location = [
      double.parse(lst[2].split(",")[0]),
      double.parse(lst[2].split(",")[1])
    ];
  }

  Store.fromSnapshot(map) {
    name = map["name"];
    phone = map["phone"];
    try {
      location = [map["lat4"], map["lon4"]];
    } catch (e) {
      location = map["location"];
    }
    // lat4 and lon4 are latitude and longitude rounded to 4 decimals
    Geolocator().placemarkFromCoordinates(map["lat4"], map["lon4"]).then((val) {
      Placemark p = val[0];
      address = "${p.administrativeArea}, ${p.locality}, ${p.name}";
    });
  }

  toJson() {
    return {
      "name": name,
      "phone": phone,
      "location": location,
    };
  }

  toFbJson() {
    return {
      "name": name,
      "phone": phone,
      "lat0": num.parse(location[0].toStringAsFixed(0)),
      "lat1": num.parse(location[0].toStringAsFixed(1)),
      "lat2": num.parse(location[0].toStringAsFixed(2)),
      "lat3": num.parse(location[0].toStringAsFixed(3)),
      "lat4": num.parse(location[0].toStringAsFixed(4)),
      "lon0": num.parse(location[1].toStringAsFixed(0)),
      "lon1": num.parse(location[1].toStringAsFixed(1)),
      "lon2": num.parse(location[1].toStringAsFixed(2)),
      "lon3": num.parse(location[1].toStringAsFixed(3)),
      "lon4": num.parse(location[1].toStringAsFixed(4)),
    };
  }
}
