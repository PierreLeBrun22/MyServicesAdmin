import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myservicesadmin/model/service.dart';
import 'package:myservicesadmin/services/fetch_data.dart' as dataFetch;
import 'package:myservicesadmin/Widgets/UsersPage/UsersPage.dart';
import 'package:myservicesadmin/Widgets/PackPage/PackPage.dart';
import 'package:myservicesadmin/Widgets/StatsPage/StatsPage.dart';
import 'package:myservicesadmin/Widgets/ServicesPage/ServicesPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Container _getAppBar() {
    return new Container(
      height: 60.0,
      color: Color(0xFF2196f3),
    );
  }

  Container _getAppbarWhite() {
    return new Container(
      margin: const EdgeInsets.only(top: 24.0, right: 12.0, left: 12.0),
      height: 55,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(4.0),
        color: Color(0xFFf7f7f7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            FontAwesomeIcons.handshake,
            color: Color(0xFF2196f3),
            size: 40.0,
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: Text('MyServices',
                style: TextStyle(
                    fontFamily: 'Satisfy',
                    fontSize: 30,
                    color: Color(0xFF4B4954))),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: new Icon(
              FontAwesomeIcons.handshake,
              color: Color(0xFF2196f3),
              size: 40.0,
            ),
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Stack(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(top: 60.0),
              child: new Column(children: <Widget>[
                new StatsPage(
                  auth: widget.auth,
                  onSignedOut: widget.onSignedOut,
                  userId: widget.userId,
                ),
              ]),
            ),
            _getAppBar(),
            _getAppbarWhite()
          ],
        );

      case 1:
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Stack(children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: new Column(children: <Widget>[
                      new Expanded(
                          child: new Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF302f33),
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      ))
                    ])),
                _getAppBar(),
                _getAppbarWhite()
              ]);

            return new Stack(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 60.0),
                  child: new Column(children: <Widget>[
                    new UsersPage(
                      auth: widget.auth,
                      onSignedOut: widget.onSignedOut,
                      userId: widget.userId,
                      users: snapshot.data.documents,
                    ),
                  ]),
                ),
                _getAppBar(),
                _getAppbarWhite()
              ],
            );
          },
        );

      case 2:
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('packs').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Stack(children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: new Column(children: <Widget>[
                      new Expanded(
                          child: new Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF302f33),
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      ))
                    ])),
                _getAppBar(),
                _getAppbarWhite()
              ]);

            return new Stack(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 60.0),
                  child: new Column(children: <Widget>[
                    new PackPage(
                      auth: widget.auth,
                      onSignedOut: widget.onSignedOut,
                      userId: widget.userId,
                      packs: snapshot.data.documents,
                    ),
                  ]),
                ),
                _getAppBar(),
                _getAppbarWhite(),
              ],
            );
          },
        );

      case 3:
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('services').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return new Stack(children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: new Column(children: <Widget>[
                      new Expanded(
                          child: new Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF302f33),
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      ))
                    ])),
                _getAppBar(),
                _getAppbarWhite()
              ]);

            return new Stack(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 60.0),
                  child: new Column(children: <Widget>[
                    new ServicesPage(
                      auth: widget.auth,
                      onSignedOut: widget.onSignedOut,
                      userId: widget.userId,
                      services: snapshot.data.documents,
                    ),
                  ]),
                ),
                _getAppBar(),
                _getAppbarWhite()
              ],
            );
          },
        );

      default:
        return new Center(
          child: new Text(
            'Error',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Satisfy',
                fontWeight: FontWeight.w600,
                fontSize: 36.0),
          ),
        );
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _getDrawerItemWidget(_currentIndex),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color(0xFF4B4954),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        ),
        child: new BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartLine, color: Color(0xFF2196f3)),
              title: Text(
                'Stats',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userAlt, color: Color(0xFF2196f3)),
              title: Text(
                'Users',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.suitcase, color: Color(0xFF2196f3)),
              title: Text(
                'Packs',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.clipboardList,
                  color: Color(0xFF2196f3)),
              title: Text(
                'Services',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
