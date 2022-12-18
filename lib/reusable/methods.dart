import 'package:flutter/material.dart';
import 'package:dorm_base/reusable/constants.dart';

Widget buildAttributeTag({required String text}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6), color: Colors.pink[800]),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),
    ),
  );
}

Container buildRoundContainer({required String text}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.5),
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      shape: BoxShape.rectangle,
    ),
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(2.0),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

AppBar buildAppBar({IconButton? button}) {
  List<Widget> appBarList = [];
  if (button != null) {
    appBarList.add(button);
  }
  return AppBar(
    title: Image.asset(
      'assets/LOGO2.png',
      fit: BoxFit.cover,
      height: 65.0,
      width: 65.0,
      color: Colors.grey[100],
    ),
    backgroundColor: themeColor,
    centerTitle: true,
    actions: appBarList,
  );
}

AppBar buildAppBarWithBackButton(
    {IconButton? button, required BackButton backButton}) {
  List<Widget> appBarList = [];
  if (button != null) {
    appBarList.add(button);
  }
  return AppBar(
    title: Image.asset(
      'assets/LOGO2.png',
      fit: BoxFit.cover,
      height: 65.0,
      width: 65.0,
      color: Colors.grey[100],
    ),
    leading: backButton,
    backgroundColor: themeColor,
    centerTitle: true,
    actions: appBarList,
  );
}

Row buildCardBottom(
    {required String dormName,
    required String walking,
    required String car,
    required String rating}) {
  return Row(
    children: [
      Text(
        dormName,
        style: const TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      const SizedBox(width: 3.0),
      const Icon(
        color: Colors.white,
        Icons.directions_walk,
      ),
      buildRoundContainer(text: walking),
      const SizedBox(
        width: 3.0,
      ),
      const Icon(color: Colors.white, Icons.drive_eta),
      buildRoundContainer(text: car),
      const Spacer(),
      Text(
        rating,
        style: const TextStyle(
          color: Colors.amberAccent,
        ),
      ),
      const Icon(
        Icons.star,
        color: Colors.amberAccent,
      ),
    ],
  );
}

Center buildIntroText({String? text}) {
  return Center(
      heightFactor: 1.3,
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 30,
          color: Colors.grey[300],
          fontFamily: 'Times New Roman',
        ),
        textAlign: TextAlign.center,
      ));
}

Drawer buildDrawer({String? userID, String? name, String? email, BuildContext? context, bool? filterSettings}) {
  return Drawer(
    backgroundColor: Colors.grey[900],
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text(email!),
          accountName: Text(name!),
          decoration: const BoxDecoration(
              color: themeColor,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/profile-bg3.jpg'),
              )),
        ),
        ListTile(
          leading: const Icon(Icons.home, color: Colors.white),
          title: const Text('Home', style: whiteStyle),
          onTap: () => {
            if(!filterSettings!) {
              Navigator.of(context!).pop()
            }
            else {
            Navigator.of(context!).pushReplacementNamed('/home', arguments: userID)
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app_outlined, color: Colors.white,),
          title: const Text('Logout', style: whiteStyle),
          onTap: () {
            // Show the alert dialog when the button is pressed
            showDialog(
              routeSettings: const RouteSettings(),
              context: context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: Text('Confirm Log Out', style: whiteStyle,),
                  content: Text('Are you sure you want to log out?', style: whiteStyle,),
                  actions: [
                    FloatingActionButton(
                      backgroundColor: themeColor,
                      child: Text('Yes'),
                      onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacementNamed(context, '/');
                          Navigator.of(context).pop();
                      },
                    ),
                    FloatingActionButton(
                      backgroundColor: themeColor,
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    ),
  );
}

Padding buildFilterCard(BuildContext context, String userID) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
    child: Card(
        elevation: 5.0,
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.filter_list),
            const SizedBox(width: 10.0),
            const Text('Filter results'),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/filter', arguments: userID);
              },
              icon: const Icon(Icons.arrow_drop_down),
              padding: const EdgeInsets.all(0.0),
            ),
          ],
        )),
  );
}

TextField buildTextField({required String inputText}) {
  return TextField(
    onChanged: (value) {
      //Do something with the user input.
    },
    style: const TextStyle(
      color: Colors.white,
    ),
    decoration: InputDecoration(
      hintText: inputText,
      hintStyle: const TextStyle(color: Colors.white),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    ),
  );
}

InputDecoration textFieldDecoration({required String hintText}) {
  return InputDecoration(
      hintStyle: whiteStyle,
      hintText: hintText,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      )),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: themeColor, width: 2.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ));
}

Container buildNextButton(
    {required void Function() onPressed, required String text}) {
  return Container(
    width: 350,
    height: 50,
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: themeColor),
        child: Text(text)),
  );
}

Column buildOnePage({
  required String topText,
  required String hintText,
  required void Function(String) onChanged,
  required void Function() onPressed,
  required String buttonText,
  bool phoneInput = false,
  bool obscuring = false,
  Set<String> set = const {},
}) {
  return Column(children: [
    const SizedBox(height: 10),
    Text(
      topText,
      style: const TextStyle(
          fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
    ),
    Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if(value!.isEmpty) {
            return 'Value must not be empty';
          }
          else if(set.contains(value)) {
            return 'Username already taken';
          }
          else {
            return null;
          }
        },
        obscureText: obscuring,
        style: whiteStyle,
        onChanged: onChanged,
        decoration: textFieldDecoration(hintText: hintText),
        keyboardType: (phoneInput) ? TextInputType.phone : TextInputType.text,
      ),
    ),
    const SizedBox(height: 15),
    buildNextButton(text: buttonText, onPressed: onPressed),
  ]);
}
