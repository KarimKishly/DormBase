import 'package:flutter/material.dart';
import 'package:dorm_base/reusable/methods.dart';
import 'package:dorm_base/reusable/constants.dart';
import 'package:dorm_base/signup.dart';
import 'package:dorm_base/main.dart';
import 'package:dorm_base/sqlconn/Services.dart';
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.grey[900],
      // body: Column(
      //   children: [
      //     SizedBox(height: 20),
      //     buildTextField(inputText: 'Enter username'),
      //   ],
      // ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: whiteStyle,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                    ),
                    labelText: 'Username',
                    labelStyle: whiteStyle,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  style: whiteStyle,
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                    )),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeColor,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle: whiteStyle,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    onPressed: () async {
                      print(nameController.text);
                      print(passwordController.text);
                      List<dynamic> response = await Services.selectSomeFromDB(tableName: 'user', columns: ['userID', 'username', 'email'], condition: 'username = \'${nameController.text}\' and password = \'${passwordController.text}\'');
                      if(response.isEmpty) {
                        return;
                      }
                      else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                              (route) => route.isFirst,
                          arguments: response[0]['userID']
                        );
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: const Text('Login')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Do not have an account?',
                    style: whiteStyle,
                  ),
                  TextButton(
                    onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                    },
                    style: TextButton.styleFrom(foregroundColor: themeColor),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
