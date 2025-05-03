import 'dart:convert';
import 'package:cites/screens/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../utils/users.api.dart';

//sign up user
Future<Map> fetchUsers({fullname, email, country, password}) async {
  // String url = "http://fciis2.fcghana.org/cites/v1/users/create.php";
  // String url = "http://cites.fcghana.org/v1/users/create.php";
  String url = "http://10.5.4.40/cites/v1/users/create.php";
  final response = await http.post(Uri.parse(url), body: {
    "fullname": fullname,
    "email": email,
    "country": country,
    "password": password
  });
  return jsonDecode(response.body);
}

//not being used!!!
//login the user
Future<Map<String, dynamic>?> fetchSingleUsers({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  String url =
      "http://10.5.4.40/cites/v1/users/login.php?email=madi@gmail.com&password=madI@1234";
  final response = await http.get(Uri.parse(url));

  print(
      'http://10.5.4.40/cites/v1/users/login.php?email=$email&password=$password $url');
// try{
//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     var jsonRes = jsonDecode(response.body);
//     if (jsonRes['log_status'] == true) {
//       print('successful fetch of user data');
//       return jsonRes;
//     } else if (jsonRes['log_status'] == false) {
//       print('login failed, user doesn\'t exist');
//       return jsonRes;
//     }
//   } else {
//     throw Exception('Failed to fetch user data');
//   }
// }catch (error) {
//     print('Error occurred: $error');
//     throw Exception('Failed to fetch user data: $error');
//   }
  return null;
}

//delete user account
// Future<bool> deleteAccount(String email) async {
//   // const url = 'http://fciis2.fcghana.org/cites/v1/users/delete.php';
//   const url = 'http://10.5.17.11/cites/v1/users/delete.php';
//   final response = await http.post(
//     Uri.parse(url),
//     body: {'email': email},
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     return jsonResponse['status'];
//   } else {
//     throw Exception('Failed to delete account');
//   }
// }

//fetch users details into profile page
// Future<Map<String, dynamic>> retrieveUsers(String email) async {
//   // const url = 'http://fciis2.fcghana.org/cites/v1/users/retrieve.php';
//   // const url = 'http://cites.fcghana.org/v1/users/retrieve.php';
//   const url = 'http://10.5.17.11/cites/v1/users/retrieve.php';
//   final response = await http.post(
//     Uri.parse(url),
//     body: {'email': email},
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = json.decode(response.body);
//     return jsonResponse['data'];
//   } else {
//     throw Exception('Failed to fetch user details');
//   }
// }

//using this. it works
Future<Map<String, dynamic>> retrieveUsers(String email) async {
  final Uri url = Uri.parse('http://10.5.4.40/cites/v1/users/retrieve.php')
      .replace(queryParameters: {'email': email});

  final response = await http.get(url, headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
  });

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == true) {
      return jsonResponse['data'];
    } else {
      throw Exception(
          'Failed to fetch user details: ${jsonResponse['message']}');
    }
  } else {
    throw Exception('Failed to fetch user details');
  }
}
