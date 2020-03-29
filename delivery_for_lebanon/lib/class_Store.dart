
class Store {
  String name, ownerName, category, phone, address;
  List<double> location;

  Store(this.name, this.ownerName, this.phone, this.category, this.location, [this.address]);

  // used by database auto populator only
  Store.fromList(List<String> lst) {
    name = lst[0];
    ownerName = lst[1];
    phone = lst[2];
    category = lst[3];
    location = [
      double.parse(lst[4].split(",")[0]),
      double.parse(lst[4].split(",")[1])
    ];
  }

  // create a Store object from a firebase's document snapshot
  Store.fromSnapshot(map) {
    name = map["name"];
    ownerName = map["ownerName"];
    phone = map["phone"];
    category = map["category"];
    location = [map["lat4"], map["lon4"]];  // lat4 and lon4 are latitude and longitude rounded to 4 decimals
  }

  toFirebaseJSON() {
    return {
      "name": name,
      "ownerName": ownerName,
      "phone": phone,
      "category": category,
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
