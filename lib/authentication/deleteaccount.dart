import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cites/authentication/auth.api.dart';
import 'package:cites/authentication/signup.dart';
import 'package:cites/widgets/pagesnavigator.dart';

class DeleteAccountDialogue {
  final String email;

  DeleteAccountDialogue(this.email);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('This action cannot be undone. Are you sure?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            // Perform account deletion logic here
            bool success = await deleteAccount(email);
            Navigator.of(context).pop(); // Close the dialog
            if (success) {
              // Navigate to a confirmation or logout page
              nextNavRemoveHistory(context, const SignupPage());
            } else {
              // Handle deletion failure if necessary
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete account')),
              );
            }
          },
          child: const Text('Yes, Delete', style: TextStyle(color: Colors.red),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

Future<bool> deleteAccount(String email) async {
  const url = 'http://10.5.17.11/cites/v1/users/delete.php';
  final response = await http.post(
    Uri.parse(url),
    body: {'email': email},
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse['status'];
  } else {
    throw Exception('Failed to delete account');
  }
}
