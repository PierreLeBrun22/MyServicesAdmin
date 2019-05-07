import 'package:flutter/material.dart';

class ChipPersonalised extends StatefulWidget {
  final List<String> reportList;

  ChipPersonalised(this.reportList);

  @override
  _ChipPersonalisedState createState() => _ChipPersonalisedState();
}

class _ChipPersonalisedState extends State<ChipPersonalised> {

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
          padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 10.0),
          child: Chip(
            deleteIcon: Icon(Icons.remove),
            deleteIconColor: Color(0xFF2196f3),
            onDeleted: () => {
                  setState(() {
                    widget.reportList.remove(item);
                  })
                },
            label: Text(item, style: TextStyle(fontFamily: 'Poppins'),),
          )));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
