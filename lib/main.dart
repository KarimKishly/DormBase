import 'package:dorm_base/dorm_page/screens/homeScreen.dart';
import 'package:dorm_base/room_page/main.dart';
import 'package:flutter/material.dart';
import 'package:dorm_base/frontend_widgets/transparent_image_card.dart';
import 'package:dorm_base/filter/filterPage.dart';
import 'package:dorm_base/reusable/classes.dart';
import 'package:dorm_base/reusable/constants.dart';
import 'package:dorm_base/reusable/methods.dart';
import 'package:dorm_base/sqlconn/Services.dart';
import 'package:dorm_base/signup.dart';
import 'package:dorm_base/login.dart';
import 'package:dorm_base/dorm_page/ReviewPage.dart';
import 'bookings.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/home': (context) => MyApp(),
      '/filter': (context) => checking(),
      '/': (context) => LoginPage(),
      '/signup': (context) => SignUp(),
      '/dorm': (context) => HomePage(),
      '/reviews': (context) => ReviewPage(),
      '/room': (context) => RoomsPage(),
      '/booking': (context) => Booking(),
    },
  ));
}

class MyApp extends StatefulWidget {
  Map<String, String> show;

  MyApp({Key? key, this.show = const {}}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> listDorms = [];
  bool filtered = false;
  late Future<List<dynamic>> dorms, user;

  @override
  void initState() {
    dorms = Services.selectAllFromDB(tableName: 'dorm', columns: ['*']);
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    filtered = false;
    String userID = ModalRoute.of(context)!.settings.arguments as String;
    debugPrint('this is the navigator: ${Navigator.of(context).toString}');
    Future<List<dynamic>> user = Services.selectSomeFromDB(
        tableName: 'user', columns: ['*'], condition: 'userID = $userID');
    return FutureBuilder(
        future: Future.wait([dorms, user]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Container();
            }
            if (snapshot.hasData) {
              List<dynamic> dormInfo = [];
              List<dynamic> searchInfo = snapshot.data[0];
              if (widget.show.isEmpty) {
                dormInfo = snapshot.data[0];
              } else {
                filtered = true;
                snapshot.data[0].forEach((element) {
                  if (element['dormShuttle'] == widget.show['shuttleBoolean'] &&
                      element['dormLaundry'] == widget.show['laundryBoolean'] &&
                      element['dormParking'] == widget.show['parkingBoolean'] &&
                      element['dormGym'] == widget.show['gymBoolean']) {
                    dormInfo.add(element);
                  }
                });
              }
              final userInfo = snapshot.data[1];
              Widget clearChanges = (snapshot.data[0] == dormInfo)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.show = {};
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Clear Changes',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
              return Scaffold(
                  backgroundColor: Colors.grey[900],
                  appBar: buildAppBar(
                    button: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: MySearchDelegate(
                                userID: userID, list: searchInfo),
                          );
                        },
                        icon: const Icon(
                          Icons.search,
                        )),
                  ),
                  drawer: buildDrawer(
                      userID: userID,
                      name: userInfo[0]['username'],
                      email: userInfo[0]['email'],
                      context: context,
                      filterSettings: filtered),
                  body: Column(
                    children: <Widget>[
                      Expanded(
                          child: (dormInfo.isNotEmpty)
                              ? ListView(children: [
                                  buildIntroText(
                                      text: 'Explore Dorms near LAU Byblos'),
                                  buildFilterCard(context, userID),
                                  ListView.builder(
                                      physics: const ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: dormInfo.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(children: <Widget>[
                                            FutureBuilder(
                                              future: Future.wait([
                                                Services.selectSomeFromDB(
                                                    tableName: 'region',
                                                    columns: ['*'],
                                                    condition:
                                                        'regionID = ${dormInfo[index]['regionID']}'),
                                                Services.getRating(
                                                    dormID: dormInfo[index]
                                                        ['dormID'])
                                              ]),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (snapshot.hasError) {
                                                  return Container();
                                                }
                                                final regionInfo =
                                                    snapshot.data[0];
                                                print(snapshot.data[1]);
                                                String rating = (snapshot
                                                    .data[1][0]['rating']);
                                                rating = (rating.length > 2)
                                                    ? rating.substring(0, 3)
                                                    : rating;
                                                List<Widget> tagsList = [];
                                                if (dormInfo[index]
                                                        ['dormShuttle'] ==
                                                    '1') {
                                                  tagsList.add(
                                                      buildAttributeTag(
                                                          text: 'Shuttle'));
                                                }
                                                if (dormInfo[index]
                                                        ['dormLaundry'] ==
                                                    '1') {
                                                  tagsList.add(
                                                      buildAttributeTag(
                                                          text: 'Laundry'));
                                                }
                                                if (dormInfo[index]
                                                        ['dormParking'] ==
                                                    '1') {
                                                  tagsList.add(
                                                      buildAttributeTag(
                                                          text: 'Parking'));
                                                }
                                                if (dormInfo[index]
                                                        ['dormGym'] ==
                                                    '1') {
                                                  tagsList.add(
                                                      buildAttributeTag(
                                                          text: 'Gym'));
                                                }
                                                dormInfo[index]
                                                ['dormRating'] = rating;
                                                dormInfo[index]
                                                ['distance'] =
                                                regionInfo[0]
                                                ['distance'];
                                                return InkWell(
                                                  child: TransparentImageCard(
                                                    imageProvider: AssetImage(
                                                        'assets/dormImages/${dormInfo[index]['dormName'].toLowerCase()}/1.jpg'),
                                                    width: 400,
                                                    tags: tagsList,
                                                    title: buildCardBottom(
                                                      dormName: dormInfo[index]
                                                          ['dormName'],
                                                      walking:
                                                          '${regionInfo[0]['walkTime']} min',
                                                      car:
                                                          '${regionInfo[0]['carTime']} min',
                                                      rating: rating,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, '/dorm',
                                                        arguments: {
                                                          'userID': userID,
                                                          'dormInfo':
                                                              dormInfo[index]
                                                        });
                                                  },
                                                );
                                              },
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                          ]),
                                        );
                                      }),
                                  clearChanges,
                                ])
                              : Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 100),
                                      Text(
                                        'No results found',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      clearChanges,
                                    ],
                                  ),
                                )),
                    ],
                  ));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
