import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'class_Database.dart';
import 'class_Store.dart';
import 'page_WaitPage.dart';
import 'main.dart';

class FormPage extends StatefulWidget {
  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  String category = "";
  Position position;
  final nameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController1 = TextEditingController();
  final addressController2 = TextEditingController();
  List<double> loc = new List();

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  getCoordinates(String address) async {
    return (await Geolocator().placemarkFromAddress(address))[0].position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("اضـافة محل"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 16,
            child: TextFormField(
              autocorrect: false,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              controller: nameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: '..اسم المحل',
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 16,
            child: TextFormField(
              autocorrect: false,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              controller: ownerNameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: '..اسم المالك',
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 16,
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
              controller: phoneController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: '..رقم الهاتف',
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.1,
                  height: MediaQuery.of(context).size.height / 16,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    controller: addressController1,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '..المنطقة',
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // ),
                // Expanded(
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3.2,
                  height: MediaQuery.of(context).size.height / 16,
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    controller: addressController2,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '..المدينة',
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // ),
              ],
            ),
          ),
          Container(height: 5),
          FlatButton(
            child: Text(
              category == "" ? "نوع المحل" : category,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            color: Color(0xFFE0E0E0),
            onPressed: () {
              category = "";
              popUp(context, categories);
              setState(() {});
            },
          ),
          FlatButton(
            child: Text(
              "تم",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            color: Colors.blue,
            onPressed: () async {
              String address = addressController1.text + " " + addressController2.text;
              try {
                Position p = await getCoordinates(address);
                if (nameController.text.isEmpty)
                  snackBar("الرجاء كتابة اسم المحل");
                else if (ownerNameController.text.isEmpty || ownerNameController.text.split(" ").length==1)
                  snackBar("الرجاء كتابة اسم المالك الكامل");
                else if (!phoneIsGood()) {
                  snackBar("الرجاء التأكد من رقم الهاتف");
                  snackBar("ان يكون 8 ارقام بلا فراغات");
                } else if(category.isEmpty) {
                  snackBar("(الرجاء اختيار نوع المحل (ماذا يبيع");
                } else {
                  Store st = Store(
                    nameController.text,
                    ownerNameController.text,
                    phoneController.text,
                    category,
                    [p.latitude, p.longitude],
                    "${addressController1.text} ${addressController2.text}",
                  );
                  String ret;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WaitPage("تتم اضافة المحل, الرجاء الانتظار")));
                  await DB.addNewStore(st).whenComplete(() => Navigator.pop(context)).then((val) => ret = val);
                  if (ret == "already exists")
                    snackBar("عذراً يبدو ان المحل مسجّل من قبل");
                  else {
                    nameController.clear();
                    ownerNameController.clear();
                    phoneController.clear();
                    addressController1.clear();
                    addressController2.clear();
                    category = "";
                    snackBar("تمت اضافة المحل");
                  }
                }
              } catch (e) {
                print(e);
                snackBar("الرجاء التأكد من العنوان");
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> popUp(context, List<String> lst) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("ماذا يبيع المحل؟", textAlign: TextAlign.center),
          content: Container(
            height: 300,
            width: 300,
            child: ListView(
              shrinkWrap: true,
              children: lst
                  .map(
                    (data) => GestureDetector(
                      child: Card(
                        elevation: 3,
                        child: Text(
                          data,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          category = data;
                          Navigator.of(context).pop(true);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  snackBar(String text) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  bool isNumeric(String s) {
    return int.tryParse(s) != null;
  }

  bool phoneIsGood() {
    String phone = phoneController.text;
    if (phone.isEmpty || phone.length != 8 || !isNumeric(phone)) return false;
    return true;
  }
}
