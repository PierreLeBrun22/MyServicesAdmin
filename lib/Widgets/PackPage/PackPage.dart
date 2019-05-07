import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myservicesadmin/Widgets/PackPage/AddPackPage.dart';
import 'package:myservicesadmin/Widgets/PackPage/DetailPackPage.dart';
import 'package:myservicesadmin/services/fetch_data.dart' as dataFetch;

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
        child: new Stack(children: <Widget>[
      new Container(
        decoration: BoxDecoration(
          color: Color(0xFF302f33),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 40.0, bottom: 70.0),
          itemCount: widget.packs.length,
          itemBuilder: (context, index) {
            final record = widget.packs[index].data;
            return Dismissible(
              key: Key(widget.packs[index].documentID),
              onDismissed: (direction) {
                dataFetch.deletePack(widget.packs[index].documentID);
                setState(() {
                  widget.packs.removeAt(index);
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
              child: _userListview(context, record, widget.packs[index].documentID),
            );
          },
        ),
      ),
      _getAddButton(context)
    ]));
  }

  Widget _userListview(BuildContext context, dynamic record, String serviceId) {
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
                  record['services'].length.toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                )
              ],
            ),
            _buttonEdit(context, record['name'], serviceId, record['services']),
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

  Widget _buttonEdit(BuildContext context, String name, String id, List<dynamic> services) {
    return new FloatingActionButton(
      heroTag: "buttonEdit" + name,
      backgroundColor: Color(0xFF2196f3),
      child: Icon(Icons.create, color: Colors.white),
      onPressed: () => {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FutureBuilder<List<String>>(
                            future: dataFetch.getAllServices(),
                            builder: (context, snapshotAllServices) {
                              if (snapshotAllServices.hasError) print(snapshotAllServices.error);
                              return snapshotAllServices.hasData
                                  ? 
                                  FutureBuilder<List<String>>(
                            future: dataFetch.getServicesPackName(services),
                            builder: (context, snapshotPackServices) {
                              if (snapshotPackServices.hasError) print(snapshotPackServices.error);
                              return snapshotPackServices.hasData
                                  ? DetailPackPage(packName: name, packId: id, allServices: snapshotAllServices.data, packServices: snapshotPackServices.data)
                                  : new Scaffold(
                                      body: new Container(
                                        constraints:
                                            new BoxConstraints.expand(),
                                        color: Color(0xFF302f33),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                                margin: new EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                        .padding
                                                        .top),
                                                child: new BackButton(
                                                    color: Colors.white)),
                                            Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          )
                                  : new Scaffold(
                                      body: new Container(
                                        constraints:
                                            new BoxConstraints.expand(),
                                        color: Color(0xFF302f33),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                                margin: new EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                        .padding
                                                        .top),
                                                child: new BackButton(
                                                    color: Colors.white)),
                                            Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          )))
      },
    );
  }

  Container _getAddButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: new FloatingActionButton(
        heroTag: "AddButton",
        child: Icon(Icons.add),
        onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FutureBuilder<List<String>>(
                            future: dataFetch.getAllServices(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              return snapshot.hasData
                                  ? AddPackPage(services: snapshot.data)
                                  : new Scaffold(
                                      body: new Container(
                                        constraints:
                                            new BoxConstraints.expand(),
                                        color: Color(0xFF302f33),
                                        child: new Stack(
                                          children: <Widget>[
                                            new Container(
                                                margin: new EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                        .padding
                                                        .top),
                                                child: new BackButton(
                                                    color: Colors.white)),
                                            Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          )))
            },
      ),
    );
  }
}
