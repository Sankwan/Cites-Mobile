import 'package:cites/authentication/auth.api.dart';
import 'package:cites/authentication/deleteaccount.dart';
import 'package:cites/authentication/login.dart';
import 'package:cites/utils/users.api.dart';
import 'package:cites/widgets/pagesnavigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("email");
  if (email != null) {
    return email;
  } else {
    throw Exception("Email not found");
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool _isLoading = false;
  String _errorMessage = '';

  // Fetch User information
  Future<void> getUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String email = await getEmail();
      var user = await retrieveUsers(email);
      setState(() {
        this.user = user;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to fetch user details';
      });
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void _showDeleteAccountDialog(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountDialogue(email).build(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              String email = await getEmail();
              _showDeleteAccountDialog(email);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : user == null
                  ? const Center(child: Text('No user data available'))
                  : ListView(
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'Find below the credentials of the Officer in charge of this account',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 50.0,
                          child: Image(
                              image: AssetImage('assets/images/cites.png')),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Name: '),
                            Text(
                              user!['fullname'], // Display full name here
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Email: '),
                            Text(
                              user!['email'], // Display email here
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Phone Number: '),
                            Text(
                              user![
                                  'phone_number'], // Display phone number here
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Country of Residence: '),
                            Text(
                              '${user!['country']}, ${user!['country_code']}', // Display country and country code here
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                        Center(
                          child: TextButton(
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove("email");
                              nextNavRemoveHistory(context, const LoginPage());
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
