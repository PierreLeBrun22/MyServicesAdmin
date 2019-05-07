import 'package:flutter/material.dart';

class MultiSelectChipUpdate extends StatefulWidget {
  final List<String> reportList;
  final List<String> packServices;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChipUpdate(this.reportList, {this.onSelectionChanged, this.packServices});

  @override
  _MultiSelectChipUpdateState createState() => _MultiSelectChipUpdateState();
}

class _MultiSelectChipUpdateState extends State<MultiSelectChipUpdate> {
  // String selectedChoice = "";
  List<String> selectedChoices = List();

    @override
  void initState() {
    super.initState();
    widget.packServices.forEach((item) => {
       setState(() {
              selectedChoices.add(item);
            })
    });
  }

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.only(top: 40.0,right: 4.0, left: 4.0, bottom: 10.0),
        child: ChoiceChip(
          label: Text(item, style: TextStyle(fontFamily: 'Poppins', fontSize: 15),),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        direction: Axis.horizontal,
      children: _buildChoiceList(),
    );
  }
}
