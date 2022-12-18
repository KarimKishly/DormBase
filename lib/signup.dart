import 'package:flutter/material.dart';
import 'package:dorm_base/reusable/constants.dart';
import 'package:dorm_base/reusable/methods.dart';
import 'package:dorm_base/sqlconn/Services.dart';
import 'package:dorm_base/main.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUp(),
  ));
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int page = 0;
  PageController control = PageController();
  var results;
  Set<String> allUsernames = {};
  Map<String, String> userData = {
    'username': '',
    'password': '',
    'studentID': '',
    'email': '',
    'phoneNum': ''
  };

  @override
  void initState() {
    Services.selectAllFromDB(tableName: 'user', columns: ['username'])
        .then((value) => results = value)
        .then((value) {
      results.forEach((element) {
        allUsernames.add(element['username']);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Column userColumn = buildOnePage(
      topText: 'Choose username',
      hintText: 'Enter your username',
      buttonText: 'Next',
      onChanged: (value) {
        userData['username'] = value;
      },
      onPressed: () {
        (!allUsernames.contains(userData['username']) &&
                userData['username']!.isNotEmpty)
            ? setState(() {
                page++;
                control.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.ease);
              })
            : null;
      },
      set: allUsernames,
    );
    return Scaffold(
      appBar: (page == 0)
          ? buildAppBar()
          : buildAppBarWithBackButton(
              backButton: BackButton(
              onPressed: () {
                  setState(() {
                    page--;
                    control.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  });
              },
              color: Colors.white,
            )),
      backgroundColor: Colors.grey[900],
      body: PageView(
        controller: control,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildOnePage(
            topText: 'Choose username',
            hintText: 'Enter your username',
            buttonText: 'Next',
            onChanged: (value) {
              userData['username'] = value;
            },
            onPressed: () {
              (!allUsernames.contains(userData['username']) && userData['username']!.isNotEmpty)
                  ? setState(() {
                      page++;
                      control.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    })
                  : null;
            },
            set: allUsernames,
          ),
          buildOnePage(
              topText: 'Choose password',
              hintText: 'Enter your password',
              buttonText: 'Next',
              obscuring: true,
              onChanged: (value) {
                userData['password'] = value;
              },
              onPressed: () {
                if (userData['password']!.isNotEmpty) {
                  setState(() {
                    page++;
                    control.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  });
                }
              }),
          buildOnePage(
              topText: 'Input your ID',
              hintText: 'Enter your studentID',
              buttonText: 'Next',
              onChanged: (value) {
                userData['studentID'] = value;
              },
              onPressed: () {
                if (userData['studentID']!.isNotEmpty) {
                  setState(() {
                    page++;
                    control.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  });
                }
              }),
          buildOnePage(
              topText: 'Input email',
              hintText: 'Enter your email',
              buttonText: 'Next',
              onChanged: (value) {
                userData['email'] = value;
              },
              onPressed: () {
                if (userData['email']!.isNotEmpty) {
                  setState(() {
                    page++;
                    control.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  });
                }
              }),
          buildOnePage(
              topText: 'Input phone number',
              hintText: 'Enter your phone',
              buttonText: 'Confirm',
              phoneInput: true,
              onChanged: (value) {
                userData['phoneNum'] = value;
              },
              onPressed: () {
                if(userData['phoneNum']!.isNotEmpty) {
                  setState(() async {
                    await Services.addUser(userData);
                    String userID = (await Services.selectSomeFromDB(tableName: 'user', columns: ['userID'], condition: 'username = \'${userData['username']}\''))[0]['userID'];
                    Navigator.pushReplacementNamed(context, '/home', arguments: userID);
                  });
                }
              }),
        ],
      ),
    );
  }
}
