import 'package:flutter/material.dart';


class WaitPage extends StatefulWidget {
  final String msg;
  WaitPage(this.msg);
  @override
  WaitPageState createState() => WaitPageState(this.msg);
}

class WaitPageState extends State<WaitPage> {
  String msg;
  WaitPageState(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text(
              msg,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
