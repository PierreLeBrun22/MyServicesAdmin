import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackPage extends StatefulWidget {
  PackPage({Key key, this.auth, this.onSignedOut, this.userId, this.packs})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final List<DocumentSnapshot> packs;


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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 40.0),
          itemCount: widget.packs.length,
          itemBuilder: (context, index) {
            final record = widget
                .packs[index].data;
            return Dismissible(
              key: Key(record['name']),
              onDismissed: (direction) {
                setState(() {
                  record.removeAt(index);
                });
              },
              background: Container(
                margin: EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.rectangle,
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 8.0),
                      ),
                    ],
                    borderRadius: new BorderRadius.circular(8.0)),
              ),
              child: _userListview(context, record),
            );
          },
        ),
      ),
    );
  }

  Widget _userListview(BuildContext context, dynamic record) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'NAME',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  record['name'],
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                )
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SERVICES',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  widget.packs.length.toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                )
              ],
            ),
            _buttonEmailVerified(),
          ],
        ),
      ),
      decoration: new BoxDecoration(
          color: Color(0xFFffffff),
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 8.0),
            ),
          ],
          borderRadius: new BorderRadius.circular(8.0)),
    );
  }

   Widget _buttonEmailVerified() {
    return new FloatingActionButton(
            backgroundColor: Color(0xFF2196f3),
            child: Icon(Icons.create, color: Colors.white),
            onPressed: () => {},
          );
  }
}
