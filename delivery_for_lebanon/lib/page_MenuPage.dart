import 'package:flutter/material.dart';

import 'page_ListPage.dart';
import 'main.dart';


class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);
  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  String dropdownValue = "أجبان و ألبان";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("طلب غرض"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ":اختر ما تبحث عنه من القائمة",
              style: TextStyle(fontSize: 26),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 34,
                isExpanded: true,
                style: TextStyle(color: Colors.blue, fontSize: 20),
                onChanged: (String newValue) {
                  dropdownValue = newValue;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(newValue)));
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}