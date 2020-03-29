import 'package:flutter/material.dart';

import 'class_Database.dart';
import 'widget_StoreList.dart';
import 'class_Store.dart';

class ListPage extends StatefulWidget {
  ListPage(this.category);
  final String category;
  @override
  ListPageState createState() => ListPageState(this.category);
}

class ListPageState extends State<ListPage> {
  List<Store> newlst = List();
  ScrollController controller;
  DB dbInstance = DB();
  String category;
  bool nothingFound = false;
  bool loading = true;

  ListPageState(this.category) {
    dbInstance.getStores(category).then((ret) {
      if (ret.length == 0)
        nothingFound = true;
      else {
        loading = false;
        newlst = ret;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "محلّات " + category,
            style: TextStyle(fontSize: 26),
          ),
          centerTitle: true),
      body: Center(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            StoreList(newlst),
            nothingFound
                ? Text(
                    "لم يتم ايجاد اي محل في المنطقة",
                    textAlign: TextAlign.center,
                  )
                : loading
                    ? Center(child: CircularProgressIndicator())
                    : Container(),
            Center(
              child: loading || nothingFound
                  ? Container()
                  : FlatButton(
                      child: Text(
                        "بحث عن المزيد",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        loading = true;
                        setState(() {});
                        newlst.addAll(await dbInstance.getStores(category));
                        loading = false;
                        if (newlst.length == 0) nothingFound = true;
                        setState(() {});
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
