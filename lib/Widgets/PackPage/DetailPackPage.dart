import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myservicesadmin/Widgets/MultiChoicesWidget/MultiChoicesUpdate.dart';
import 'package:myservicesadmin/services/fetch_data.dart' as dataFetch;

class DetailPackPage extends StatefulWidget {
  DetailPackPage({Key key,this.packName, this.packId, this.allServices, this.packServices}) : super(key: key);

  final String packName;
  final String packId;
  final List<String> allServices;
  final List<String> packServices;

  State<StatefulWidget> createState() => new _DetailPackPageState();
}

class _DetailPackPageState extends State<DetailPackPage>
    with TickerProviderStateMixin {
  String _packName;
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  final _formKey = new GlobalKey<FormState>();
  double _width = double.maxFinite;
  List<String> selectedReportList = List();

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

    @override
  void initState() {
    super.initState();
    setState(() {
      selectedReportList = widget.packServices;
    });
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
                          initialValue: widget.packName,
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: new Icon(
                                FontAwesomeIcons.suitcase,
                                color: Colors.grey,
                              )),
                          validator: (value) =>
                              value.isEmpty ? 'Name can\'t be empty' : null,
                          onSaved: (value) => _packName = value,
                        ),
                      ),
                    ],
                  ),
                ),
                MultiSelectChipUpdate(
                  widget.allServices,
                  packServices: widget.packServices,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      selectedReportList = selectedList;
                    });
                  },
                ),
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
                    if (_state == 0 && _validateAndSave() && selectedReportList.length > 0) {
                      animateButton();
                      dataFetch.updatePack(_packName, selectedReportList, widget.packId);
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
        "Update pack !",
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
