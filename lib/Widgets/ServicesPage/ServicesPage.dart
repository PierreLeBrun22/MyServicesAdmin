import 'package:flutter/material.dart';
import 'package:myservicesadmin/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myservicesadmin/Widgets/ServicesPage/AddServicePage.dart';
import 'package:myservicesadmin/Widgets/ServicesPage/DetailServicePage.dart';
import 'package:myservicesadmin/services/fetch_data.dart' as dataFetch;

class ServicesPage extends StatefulWidget {
  ServicesPage(
      {Key key, this.auth, this.onSignedOut, this.userId, this.services})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final List<DocumentSnapshot> services;

  @override
  State<StatefulWidget> createState() => new _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
          itemCount: widget.services.length,
          itemBuilder: (context, index) {
            final record = widget.services[index].data;
            return Dismissible(
              key: Key(widget.services[index].documentID),
              onDismissed: (direction) {
                dataFetch.deleteService(widget.services[index].documentID);
                setState(() {
                  widget.services.removeAt(index);
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
              child: _userListview(context, record, widget.services[index].documentID),
            );
          },
        ),
      ),
      _getAddButton(context)
    ]));
  }

  Widget _userListview(BuildContext context, dynamic record, String id) {
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
                  'PARTNERS',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  record['partners'].length.toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Color(0xFF2196f3)),
                )
              ],
            ),
            _buttonEdit(context, record['name'], record['image'], record['description'], record['location'], record['partners'], id),
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

  Widget _buttonEdit(BuildContext context, String name, String image, String description, String location, List<dynamic> partners, String id) {
    return new FloatingActionButton(
      heroTag: "buttonEdit" + name,
      backgroundColor: Color(0xFF2196f3),
      child: Icon(Icons.create, color: Colors.white),
      onPressed: () => {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailServicesPage(name: name, description: description, image: image, location: location, partners: partners, serviceId: id,)))
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddServicesPage()))
            },
      ),
    );
  }
}
