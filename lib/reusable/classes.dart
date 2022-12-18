import 'package:dorm_base/reusable/constants.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  List<dynamic> list = [];
  String userID;
  MySearchDelegate({required this.list, required this.userID});
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        hintColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: themeColor,
        ),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        )
      )
    );
  }
    @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
      onPressed: () {
        if(query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
      icon: const Icon(Icons.clear),
    ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
    //return Navigator.pushNamed(context, '/$query');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestions = list.where((list) {
      final result = list['dormName'].toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              foregroundImage: AssetImage('assets/dormImages/${suggestions[index]['dormName'].toLowerCase()}/1.jpg'),
            ),
            title: Text(suggestions[index]['dormName']),
            onTap: () {
              query = suggestions[index]['dormName'];
              showResults(context);
              Navigator.pushReplacementNamed(context, '/dorm', arguments: {'userID': userID, 'dormInfo': suggestions[index]});
            },
          );
        }
    );
  }

}