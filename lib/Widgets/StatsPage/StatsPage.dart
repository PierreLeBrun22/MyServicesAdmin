import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String signOut = 'LOGOUT';

const List<String> choices = <String>[signOut];

class StatsPage extends StatefulWidget {
  StatsPage(
      {Key key,
      this.auth,
      this.onSignedOut,
      this.userId})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  
  @override
  State<StatefulWidget> createState() => new _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void choiceAction(String choice) {
    if (choice == signOut) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: new Container(
            color: Color(0xFF302f33),
            child: new ListView(children: <Widget>[
              _logout(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'handshake',
                    child: new Icon(
                      FontAwesomeIcons.handshake,
                      color: Color(0xFF2196f3),
                      size: 100.0,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  _userDetails(),
                ],
              )
            ])));
  }

  Widget _logout() {
    return new Container(
        margin: const EdgeInsets.only(right: 20.0, top: 20.0),
        alignment: Alignment.topRight,
        child: PopupMenuButton<String>(
          icon: new Icon(
            Icons.settings,
            color: Colors.white,
            size: 35.0,
          ),
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              );
            }).toList();
          },
        ));
  }

  Widget _userDetails() {
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('user').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'USERS',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                        )
                      ],
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      Firestore.instance.collection('userServices').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    final record = snapshot.data.documents
                        .where((data) => data.data.containsValue(true));
                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SERVICES USED',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          record.length.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                        )
                      ],
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('services').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'SERVICES',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                        )
                      ],
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('packs').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    return new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'PACKS',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                        )
                      ],
                    );
                  },
                ),
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
        ),
        Padding(
          padding:
              EdgeInsets.only(top: 50.0, bottom: 10.0, right: 10.0, left: 10.0),
          child: Text("More stats will come soon",
              style: TextStyle(
                  fontFamily: 'Satisfy', color: Colors.white, fontSize: 27)),
        )
      ],
    );
  }
}
