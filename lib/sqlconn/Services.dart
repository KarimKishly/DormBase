import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:dart_ipify/dart_ipify.dart';

class Services {
  static Uri ROOT = Uri(
      scheme: 'http',
      host: '192.168.1.3',
      path: '/dormbase_api/connection.php');
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_EMP_ACTION = 'ADD_EMP';
  static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  static const _DELETE_EMP_ACTION = 'DELETE_EMP';

  // Method to create the table Employees.
  static Future<String> createTable(dynamic output) async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<dynamic>> getDorms() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        //List<Employee> list = parseResponse(response.body);
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [
        {'hello': 'world'}
      ]; // return an empty list on exception/error
    }
  }

  static Future<List<dynamic>> selectAllFromDB(
      {required String tableName, required List<String> columns}) async {
    try {
      var map = Map<String, dynamic>();
      StringBuffer toColumns = StringBuffer("");
      String lastElement = columns.removeLast();
      for (String element in columns) {
        toColumns.write('$element, ');
      }
      toColumns.write(lastElement);
      map['action'] = 'SELECT_ALL';
      map['table'] = tableName;
      map['columns'] = toColumns.toString();
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return ['error'];
      }
    } catch (e) {
      return ['hello']; // return an empty list on exception/error
    }
  }

  static Future<List<dynamic>> selectSomeFromDB({
    required String tableName,
    required List<String> columns,
    required String condition,
  }) async {
    try {
      var map = Map<String, dynamic>();
      StringBuffer toColumns = StringBuffer("");
      String lastElement = columns.removeLast();
      for (String element in columns) {
        toColumns.write('$element, ');
      }
      toColumns.write(lastElement);
      map['action'] = 'SELECT_SPECIFIC';
      map['table'] = tableName;
      map['columns'] = toColumns.toString();
      map['condition'] = condition;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return []; // return an empty list on exception/error
    }
  }

  static Future<String> addUser(Map<String, dynamic> toAdd) async {
    try {
      toAdd['action'] = 'ADD_USER';
      final response = await http.post(ROOT, body: toAdd);
      print('addUser Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<dynamic>> getReviews({
    required String dormID,
  }) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_REVIEWS';
      map['dormID'] = dormID;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return ['something'];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static Future<List<dynamic>> getBookings({
    required String userID,
  }) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_BOOKINGS';
      map['userID'] = userID;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return ['something'];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }
  static Future<List<dynamic>> getRoomInfo({
    required String dormID,
  }) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_ROOM_INFO';
      map['dormID'] = dormID;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return ['something'];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static Future<void> bookRoom({
    required String roomID,
    required String userID,
  }) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'BOOK_ROOM';
      map['roomID'] = roomID;
      map['userID'] = userID;
      final response = await http.post(ROOT, body: map);
      print(response.body);
      return;
    } catch (e) {
      return; // return an empty list on exception/error
    }
  }

  static Future<List<dynamic>> getRating({
    required String dormID
  }) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = 'GET_RATING';
      map['dormID'] = dormID;
      final response = await http.post(ROOT, body: map);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [{'rating': '0'}]; // return an empty list on exception/error
    }
  }
}