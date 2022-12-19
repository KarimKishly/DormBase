import 'package:flutter/material.dart';
import 'package:dorm_base/dorm_page/constants.dart';
import 'package:dorm_base/dorm_page/carousel.dart';
import 'package:dorm_base/sqlconn/Services.dart';
import 'package:dorm_base/dorm_page/ReviewCard.dart';
import 'package:dorm_base/dorm_page/ReviewPage.dart';

class Body extends StatelessWidget {
  final Map<String, dynamic> dorm;

  const Body({Key? key, required this.dorm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> dormInfo = dorm;
    Size screenSize = MediaQuery.of(context).size;

    // change icon of the chip depending on the type

    Map<String, bool> attributes = {
      "Shuttle": (dormInfo['dormShuttle'] == '1') ? true : false,
      "Laundry": (dormInfo['dormLaundry'] == '1') ? true : false,
      "Cleaning": (dormInfo['dormCleaning'] == '1') ? true : false,
      "Paid Electricity": (dormInfo['dormElectricity'] == '1') ? true : false,
      "Lounge": (dormInfo['dormLounge'] == '1') ? true : false,
      "Common Kitchen": (dormInfo['dormCommonKitchen'] == '1') ? true : false,
      "Gym": (dormInfo['dormGym'] == '1') ? true : false,
      "Parking": (dormInfo['dormParking'] == '1') ? true : false,
    };

    const styles = TextStyle(
      color: textColorLight,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Image carousel showing dorm images
            Carousel(name: dormInfo['dormName'].toLowerCase()),

            // Main info about the dorm
            mainInfo(screenSize, dormInfo),
            const SizedBox(height: 10),

            // Description of the dorm
            Row(children: const [
              Text("Description",
                  style: TextStyle(
                      fontSize: 20,
                      color: textColorLight,
                      fontWeight: FontWeight.bold)),
              Spacer()
            ]),
            Text("${dormInfo['dormDescription']}", style: styles),
            const SizedBox(height: 10),

            Row(
              children: const [
                Text("Dorm Services",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColorLight,
                      fontSize: 16,
                    )),
                Spacer()
              ],
            ),
            dormServices(attributes, styles),
            const SizedBox(height: 10),
            FutureBuilder(
                future: Future.wait([
                  Services.selectSomeFromDB(
                      tableName: 'utility',
                      columns: ['utilityName', 'type'],
                      condition: 'regionID = ${dormInfo['regionID']}'),
                  Services.selectSomeFromDB(
                      tableName: 'ruleset',
                      columns: ['visitors', 'pets', 'nonUni'],
                      condition: 'rulesetID = ${dormInfo['rulesetID']}'),
                  Services.getReviews(dormID: dormInfo['dormID']),
                ]),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Container();
                    }
                    if (snapshot.hasData) {
                      List<dynamic> utilities =
                          snapshot.data[0] as List<dynamic>;
                      Map<String, dynamic> ruleset =
                          snapshot.data[1][0] as Map<String, dynamic>;
                      List<dynamic> reviews = snapshot.data[2] as List<dynamic>;
                      List<Chip> utilChips = [];
                      for (var i = 0; i < utilities.length; i++) {
                        String name = utilities[i]['utilityName'];
                        String type = utilities[i]['type'];

                        IconData icon = Icons.error;
                        if (type.toLowerCase() == "store") {
                          icon = Icons.store;
                        } else if (type.toLowerCase() == "gym") {
                          icon = Icons.sports_basketball;
                        } else if (type.toLowerCase() == "pharmacy") {
                          icon = Icons.medical_information;
                        } else if (type.toLowerCase() == "cafe") {
                          icon = Icons.local_cafe_rounded;
                        }

                        utilChips.add(Chip(
                          label: Text(name),
                          avatar: Icon(icon),
                        ));
                      }
                      return Column(
                        children: [
                          Row(children: const [
                            Text("Near Us",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColorLight,
                                  fontSize: 20,
                                )),
                            Spacer(),
                          ]),
                          const SizedBox(height: 10),
                          dormUtils(utilChips, styles),
                          const SizedBox(height: 10),
                          Row(children: const [
                            Text("Rules",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColorLight,
                                  fontSize: 20,
                                )),
                            Spacer(),
                          ]),
                          dormRules(ruleset),
                          const SizedBox(
                            height: 10,
                          ),
                          // ReviewCard(review: reviews[0]),
                          dormReviews(reviews: reviews),
                        ],
                      );
                    }
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  // Main info showing dorm name, phone, location, rating
  SizedBox mainInfo(
      Size screenSize, Map<String, dynamic> dorm) {
    return SizedBox(
      width: screenSize.width * 0.9,
      child: Column(children: [
        Row(
          children: [
            Text(
              dorm['dormName']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 28,
              ),
            ),
            const Spacer(),
            Text("${dorm['dormRating']}",
                style: const TextStyle(color: textColorLight, fontSize: 16)),
            const Icon(
              Icons.star,
              color: primaryColor,
              size: 26,
            ),
          ],
        ),
        Row(children: [
          const Icon(Icons.phone, color: primaryColor),
          Text(" ${dorm['dormPhone']}",
              style: const TextStyle(color: textColorLight, fontSize: 16)),
          const Spacer()
        ]),
        Row(children: [
          const Icon(Icons.location_on_outlined, color: primaryColor),
          Text(" ${dorm['distance']}m",
              textAlign: TextAlign.left,
              style: const TextStyle(color: textColorLight, fontSize: 16)),
          const Spacer(),
        ]),
      ]),
    );
  }

  // build the dorm services Wrap
  Wrap dormServices(Map<String, bool> attributes, TextStyle styles) {
    return Wrap(spacing: 4, children: [
      for (String key in attributes.keys)
        if (attributes[key] ?? false)
          Chip(
            label: Text(key, style: styles),
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          )
    ]);
  }

  Wrap dormUtils(List<Chip> utilChips, TextStyle styles) {
    return Wrap(
        spacing: 4,
        children: [for (var i = 0; i < utilChips.length; i++) utilChips[i]]);
  }

  ListView dormRules(Map<String, dynamic> rulesMap) {
    List<bool> rules = [];
    rulesMap.forEach((key, value) {
      (value == '1') ? rules.add(true) : rules.add(false);
    });
    final List<String> ruleNames = [
      "Visitors",
      "Pets",
      "Non-University Students"
    ];
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: ruleNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              text: "- ${ruleNames[index]}: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                    text: rules[index] ? "Allowed" : "Not Allowed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: rules[index] ? Colors.green : Colors.red,
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

class dormReviews extends StatelessWidget {
  const dormReviews({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  final List<dynamic> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add your product content here
        Row(
          children: const [
            Text(
              'Reviews',
              style: TextStyle(
                  fontSize: 20,
                  color: textColorLight,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: (reviews.isEmpty) ? 0 : (reviews.length == 1) ? 1 : 2,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ReviewCard(review: reviews[index]);
          },
        ),
        TextButton(
          child: const Text(
            'See all reviews',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/reviews',
              arguments: reviews,
            );
          },
        ),
      ],
    );
  }
}
