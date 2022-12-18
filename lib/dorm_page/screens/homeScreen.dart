import 'package:dorm_base/reusable/constants.dart';
import 'package:flutter/material.dart';
import 'package:dorm_base/dorm_page/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dorm_base/dorm_page/body.dart';
import 'package:dorm_base/reusable/methods.dart';
import 'package:dorm_base/sqlconn/Services.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dormInfo = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: buildAppBar(),
      body: Body(dorm: dormInfo['dormInfo']),
      bottomNavigationBar: BookRoomButton(dorm: dormInfo),
      );
  }
}
class BookRoomButton extends StatelessWidget {
  BookRoomButton({
    Key? key,
    this.dorm = const {}
  }) : super(key: key);
  Map<String, dynamic> dorm;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 5, 80, 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: BottomAppBar(
          elevation: 0,
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: primaryColor,
              ),
              child: OutlinedButton(
                onPressed: () async {
                  List<dynamic> roomTypes = (await Services.selectSomeFromDB(tableName: 'room', columns: ['distinct type'], condition: 'dormID = ${dorm['dormInfo']['dormID']}'));
                  print(roomTypes);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey[900],
                        actionsAlignment: MainAxisAlignment.center,
                        title: const Text('What room are you looking for?', style: whiteStyle),
                        actions: <Widget>[
                          Column(
                            children: [
                              ...roomTypes.map((e) => buildOption(e, dorm['dormInfo']['dormID'], dorm['userID'], dorm['dormInfo']['dormName'], context)).toList(),
                            ],
                          ),
                        ],
                      );
                    }
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                ),
                child: const Text("Book Room", style: TextStyle(
                  color: textColorLight,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
              )


          ),
        ),
      ),
    );
  }
}
ElevatedButton buildOption(Map<String, dynamic> types, String dormID, String userID, String dormName, BuildContext context) {
  return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(
            context,
            '/room',
          arguments: {
              'userID': userID,
              'dormID': dormID,
            'roomType' : types['type'],
            'dormName': dormName,
          }
        );
      },
      child: Text(types['type']),
    style: ElevatedButton.styleFrom(
      backgroundColor: themeColor
    ),
  );
}




