import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'page_IntroPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print("${position.latitude}, ${position.longitude}");
  userLocation = [position.latitude, position.longitude];
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: IntroPage());
  }
}

List<double> userLocation;

List<String> categories = [
  "أجبان و ألبان",
  "سوبرماركت",
  "لحوم",
  "خضار و فاكهة"
];

// to be added later on
// showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             "ملاحظة",
//             style: TextStyle(color: Colors.red, fontSize: 25),
//             textAlign: TextAlign.center,
//           ),
//           elevation: 5,
//           backgroundColor: Colors.white,
//           content: Container(
//             width: MediaQuery.of(context).size.width / 2,
//             height: MediaQuery.of(context).size.height / 7,
//             child: Text("يحتاج التطبيق الى استعمال نظام تحديد الموقع للعمل"),
//           ),
//         );
//       },
//     );
