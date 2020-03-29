import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'class_Store.dart';

class StoreList extends StatelessWidget {
  List<Store> lst;
  StoreList(this.lst);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this
          .lst
          .map(
            (element) => GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        element.name + "\n" + element.ownerName,
                        style: TextStyle(color: Colors.blue, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      content: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 7,
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Card(
                              elevation: 3,
                              child: Text("واتسأب",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20)),
                            ),
                            Card(
                                elevation: 3,
                                child: Text("اتصل",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20)))
                          ]
                              .map(
                                (choice) => GestureDetector(
                                  child: choice,
                                  onTap: () async {
                                    String url;
                                    if (((choice as Card).child as Text).data ==
                                        "واتسأب")
                                      url = "https://wa.me/${element.phone}";
                                    else if (((choice as Card).child as Text)
                                            .data ==
                                        "اتصل")
                                      url = "tel:${element.phone}";
                                    else
                                      Navigator.of(context).pop(true);
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      throw "Could not launch $url";
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                child: Card(
                  margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(element.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(element.ownerName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.right),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Text(
                              element.address,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
