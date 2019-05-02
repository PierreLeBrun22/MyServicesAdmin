import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';

class PackPage extends StatefulWidget {
  PackPage({Key key, this.auth, this.onSignedOut, this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;


  @override
  State<StatefulWidget> createState() => new _PackPageState();
}

class _PackPageState extends State<PackPage> {

  @override
  Widget build(BuildContext context) {
   return new Expanded(
      child: new Container(
        decoration: BoxDecoration(
          color: Color(0xFF302f33),
        ),
       
      ),
    );
  }
}
