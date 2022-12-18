import 'package:flutter/material.dart';
import 'package:dorm_base/filter/checkbox_state.dart';
import 'package:dorm_base/main.dart';
import 'package:dorm_base/reusable/constants.dart';

import '../reusable/constants.dart';
void main() {
  runApp(const MaterialApp(
    home: checking(),
  ));
}

class checking extends StatefulWidget {
  const checking({Key? key}) : super(key: key);

  @override
  State<checking> createState() => _checkingState();
}

class _checkingState extends State<checking> {
  CheckBoxState shuttleBox = CheckBoxState(title: 'Shuttle');
  CheckBoxState laundryBox = CheckBoxState(title: 'Laundry');
  CheckBoxState parkingBox = CheckBoxState(title: 'Parking');
  CheckBoxState gymBox = CheckBoxState(title: 'Gym');

  late final List<CheckBoxState> listCheckboxes = [
    shuttleBox, laundryBox, parkingBox, gymBox
  ];
  late String userID;
  @override
  void didChangeDependencies() {
    userID = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your preferences'),
        centerTitle: true,
        backgroundColor: themeColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ...listCheckboxes.map(buildSingleCheckbox).toList(),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: ElevatedButton(
                onPressed: () {
                  Map<String, String> pref = {
                    'shuttleBoolean' : shuttleBox.value ? '1' : '0',
                    'laundryBoolean' : laundryBox.value ? '1' : '0',
                    'parkingBoolean' : parkingBox.value ? '1' : '0',
                    'gymBoolean' : gymBox.value ? '1' : '0',

                  };
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyApp(show: pref), settings: RouteSettings(arguments: userID)));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(themeColor)
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18
                  ),
                )
              ),
          ),
        ],
      ),
    );
  }
  CheckboxListTile buildSingleCheckbox (CheckBoxState checkbox) => CheckboxListTile(
    controlAffinity: ListTileControlAffinity.leading,
    activeColor: themeColor,
    value: checkbox.value,
    title: Text(
      checkbox.title,
      style: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'Times New Roman'
      ),
    ),
    onChanged: (val) {
      setState(() {
        checkbox.value = val!;
      });
    }
  );
}

