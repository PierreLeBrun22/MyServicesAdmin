import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myservicesadmin/services/fetch_data.dart' as dataFetch;
import 'package:myservicesadmin/Widgets/MultiChoicesWidget/ChipsWidget.dart';

class AddServicesPage extends StatefulWidget {
  State<StatefulWidget> createState() => new _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage>
    with TickerProviderStateMixin {
  String _serviceName;
  String _serviceDescription;
  String _serviceImage;
  String _serviceLocation;
  List<String> _servicePartners = [];

  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  final _formKey = new GlobalKey<FormState>();
  final _formKeyPartner = new GlobalKey<FormState>();
  double _width = double.maxFinite;
  List<String> selectedReportList = List();
  String _newServicePartner;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool _validateAndSavePartner() {
    final form = _formKeyPartner.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _addPartners() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add a partner",
              style: TextStyle(
                  fontFamily: 'Satisfy',
                  color: Color(0xFF2196f3),
                  fontSize: 25)),
          content: Container(
              height: 100.0, // Change as per your requirement
              width: 350.0, // Change as per your requirement
              child: Form(
                key: _formKeyPartner,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: new Text(
                              "NAME",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2196f3),
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: Color(0xFF2196f3),
                              width: 0.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              autofocus: false,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Partner Name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  icon: new Icon(
                                    FontAwesomeIcons.clipboardList,
                                    color: Colors.grey,
                                  )),
                              validator: (value) =>
                                  value.isEmpty ? 'Name can\'t be empty' : null,
                              onSaved: (value) => _newServicePartner = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss",
                  style: TextStyle(
                      fontFamily: 'Poppins', color: Colors.grey, fontSize: 15)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Add",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF2196f3),
                      fontSize: 15)),
              onPressed: () {
                if (_validateAndSavePartner()) {
                  _servicePartners.add(_newServicePartner);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Color(0xFF302f33),
        child: new Stack(
          children: <Widget>[
            _getContent(),
            _getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getContent() {
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
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
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "NAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196f3),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color(0xFF2196f3),
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Service Name',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: new Icon(
                                FontAwesomeIcons.clipboardList,
                                color: Colors.grey,
                              )),
                          validator: (value) =>
                              value.isEmpty ? 'Name can\'t be empty' : null,
                          onSaved: (value) => _serviceName = value,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "MAIN LOCATION",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196f3),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color(0xFF2196f3),
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Service Main Location',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: new Icon(
                                FontAwesomeIcons.locationArrow,
                                color: Colors.grey,
                              )),
                          validator: (value) =>
                              value.isEmpty ? 'Location can\'t be empty' : null,
                          onSaved: (value) => _serviceLocation = value,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "IMAGE (URL)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196f3),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color(0xFF2196f3),
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          keyboardType: TextInputType.url,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Service Image (URL)',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: new Icon(
                                FontAwesomeIcons.image,
                                color: Colors.grey,
                              )),
                          validator: (value) => value.isEmpty
                              ? 'Image its not a URL or can\'t be empty'
                              : null,
                          onSaved: (value) => _serviceImage = value,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "DESCRIPTION",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196f3),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Color(0xFF2196f3),
                          width: 0.5,
                          style: BorderStyle.solid),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Service Description',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: new Icon(
                                FontAwesomeIcons.quoteLeft,
                                color: Colors.grey,
                              )),
                          validator: (value) => value.isEmpty
                              ? 'Description can\'t be empty'
                              : null,
                          onSaved: (value) => _serviceDescription = value,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 24.0,
                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: new Text(
                          "PARTNERS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196f3),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _getPartnersChips(context),
                _buttonCreate(context)
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _getToolbar(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: new BackButton(color: Colors.white));
  }

  Container _getPartnersChips(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 4.0, left: 30.0, right: 4.0),
      child: Wrap(
        spacing: 4.0, // gap between adjacent chips
        runSpacing: 1.0, // gap between lines
        direction: Axis.horizontal,
        children: <Widget>[
          ChipPersonalised(
            _servicePartners,
          ),
          FloatingActionButton(
            heroTag: "AddPartnersButton",
            mini: true,
            child: Icon(Icons.add),
            onPressed: () => {_addPartners()},
          ),
        ],
      ),
    );
  }

  Center _buttonCreate(BuildContext context) {
    return new Center(
      child: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
        ),
        alignment: Alignment.bottomCenter,
        child: Align(
          alignment: Alignment.center,
          child: PhysicalModel(
            elevation: 8,
            shadowColor: Colors.black12,
            color: Color(0xFF43e97b),
            borderRadius: BorderRadius.circular(25),
            child: Container(
              key: _globalKey,
              height: 48,
              width: _width,
              child: RaisedButton(
                animationDuration: Duration(milliseconds: 1000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.all(0),
                child: setUpButtonChild(),
                onPressed: () {
                  setState(() {
                    if (_state == 0 &&
                        _validateAndSave() &&
                        _servicePartners.length > 0) {
                      animateButton();
                      dataFetch.createService(_serviceName, _serviceLocation,
                          _serviceDescription, _serviceImage, _servicePartners);
                    }
                  });
                },
                elevation: 4,
                color: Color(0xFF2196f3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setUpButtonChild() {
    if (_state == 0) {
      return Text(
        "Create service !",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontFamily: 'Satisfy',
        ),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      Navigator.maybePop(context);
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 1500), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
