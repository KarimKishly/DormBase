import 'package:dorm_base/reusable/methods.dart';
import 'package:flutter/material.dart';
import '../reusable/constants.dart';
import 'package:dorm_base/dorm_page/carousel.dart';
import 'package:dorm_base/sqlconn/Services.dart';

const textColor = Color.fromRGBO(83, 83, 83, 1);
const textColorLight = Color(0xFFACACAC);
const primaryColor = Color.fromRGBO(1, 98, 81, 1);
const IconData dollar = IconData(0xeea2, fontFamily: 'MaterialIcons');

void main() => runApp(MaterialApp(
      home: RoomsPage(),
      debugShowCheckedModeBanner: false,
    ));

class RoomsPage extends StatelessWidget {
  RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> roomInDorm =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String userID = roomInDorm['userID'];
    const roomEx = [
      2,
      1,
      202,
      true,
      "Double Room",
      "700",
      "Double rooms at Uniview contain two beds, two desk, two chairs,"
          "a TV, an AC, a small kitchen, and a bathroom."
    ];
    const List<String> roomNb = [
      'A101',
      'A102',
      'A103',
      'B006',
      'B202',
      'B100',
      'B222',
      'B206',
      'B111',
      'A200'
    ];
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: buildAppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: Future.wait([
              Services.selectSomeFromDB(
                tableName: 'room',
                columns: ['roomID, roomNumber'],
                condition:
                    'availability = 1 AND dormID = ${roomInDorm['dormID']}'),

            ]),

            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData) {
                  print(roomInDorm);
                  List<Map<String, dynamic>> roomNb = [];
                  snapshot.data[0].forEach((e) {
                    roomNb.add(e);
                  });
                  return Column(children: <Widget>[
                    Carousel(name: roomInDorm['dormName'].toLowerCase()),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text(
                            '${roomInDorm['roomType']} Room',
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: textColorLight,
                            ),
                          ),
                          const Spacer(),
                          const Icon(dollar, color: Colors.teal, size: 35.0),
                          Text(
                            roomEx[5].toString(),
                            style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              letterSpacing: 1.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            roomEx[6].toString(),
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white70,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: const [
                          Text(
                            'Available Rooms',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < roomNb.length; i++)
                            Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    6.0, 0.0, 6.0, 12.0),
                                child: TextButton(
                                    style: const ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Colors.teal),
                                    ),
                                    child: Text(
                                      roomNb[i]['roomNumber'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        routeSettings: const RouteSettings(),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[900],
                                            title: const Text(
                                              'Book Room',
                                              style: whiteStyle,
                                            ),
                                            content: const Text(
                                              'Confirm booking?',
                                              style: whiteStyle,
                                            ),
                                            actions: [
                                              FloatingActionButton(
                                                backgroundColor: themeColor,
                                                child: const Text('Yes'),
                                                onPressed: () async {
                                                  print(roomNb[i]['roomID']);
                                                  await Services.bookRoom(roomID: roomNb[i]['roomID'], userID: userID);
                                                  Navigator.of(context).pop();
                                                  Navigator.pushReplacementNamed(
                                                      context,
                                                      '/room',
                                                    arguments: roomInDorm,
                                                  );
                                                },
                                              ),
                                              FloatingActionButton(
                                                backgroundColor: themeColor,
                                                child: const Text('No'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }))
                        ],
                      ),
                    )
                  ]);
                }
              }
              return Container();
            },
          ),
        ));
  }
}
