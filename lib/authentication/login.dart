import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cites/animation/slideanimate.dart';
import 'package:cites/authentication/forgotpassword.dart';
import 'package:cites/authentication/signup.dart';
import 'package:cites/screens/homepage.dart';
import 'package:cites/utils/users.api.dart';
import 'package:cites/widgets/customwidgets.dart';
import 'package:cites/widgets/formfields.dart';
import 'package:cites/widgets/pagesnavigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoggingIn = false; // Track whether login is in progress
  bool loginError = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  //AAAAAAA
  //   Future<Map<String, dynamic>?> fetchSingleUsers({
  //     required BuildContext context,
  //     required String email,
  //     required String password,
  //   }) async {
  //     String url = "http://10.5.17.11/cites/v1/users/login.php?email=$email&password=$password";
  //     // final response = await http.post(Uri.parse(url));

  // print('http://10.5.17.11/cites/v1/users/login.php?email=$email&password=$password $url');
  //     try {
  //       final response = await http.get(
  //         Uri.parse(url),
  //         headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //         // body: {
  //         //   'email': email,
  //         //   'password': password,
  //         // },
  //       );

  //       if (response.statusCode == 200) {
  //         var jsonRes = json.decode(response.body);
  //         print('Server response: $jsonRes');
  //         return jsonRes;
  //       } else {
  //         print('Server returned status code: ${response.statusCode}');
  //         return null;
  //       }
  //     } catch (e) {
  //       print('Error fetching user data: $e');
  //       return null;
  //     }
  //   }

  Future<Map<String, dynamic>?> fetchSingleUsers({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    String baseUrl = "http://192.168.0.128/cites/v1/users/login.php";
    String url = "$baseUrl?email=$email&password=$password";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.statusCode == 200) {
        var jsonRes = json.decode(response.body);
        print('Server response: $jsonRes');
        return jsonRes;
      } else {
        print('Server returned status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/citeslogo.jpg',
                      height: 120,
                      width: 220,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Welcome Back', style: TextStyle(fontSize: 25)),
              const SizedBox(height: 5),
              const Text('Login to use App', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Column(
                children: <Widget>[
                  CustomTextField(
                    controller: emailController,
                    label: 'email',
                    icon: Icons.mail,
                    hint: 'email',
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 25),
                  PasswordFormField(
                    controller: passwordController,
                    label: 'password',
                    icon: Icons.lock,
                    validator: passwordValidator,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 180),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PasswordResetPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  PrimaryButton(
                    onpress: () async {
                      // Ensure the correct callback name
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoggingIn = true; // Start the login process
                          loginError = false; // Reset login error status
                        });

                        var email = emailController.text;
                        var password = passwordController.text;

                        try {
                          BotToast.showLoading(); // Show loading toast

                          var data = await fetchSingleUsers(
                            context: context,
                            email: email,
                            password: password,
                          );
                          print('Email: $email, Password: $password');

                          BotToast.closeAllLoading(); // Close the loading toast

                          if (data != null && data['log_status'] == true) {
                            print(data['log_status']);
                            // Login successful, navigate to MyHomePage
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("email", email);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Login successful!'),
                                ),
                              );

                            nextNavRemoveHistory(context, MyHomePage());
                          } else {
                            // Login failed, set error status and show snackbar
                            setState(() {
                              isLoggingIn =
                                  false; // Stop the circular progress indicator
                              loginError = true;
                            });
                            String errorMessage =
                                data?['message'] ??
                                'Login failed, user doesn\'t exist';
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                          }
                        } catch (error) {
                          // Handle network or other errors here
                          setState(() {
                            isLoggingIn =
                                false; // Stop the circular progress indicator
                            loginError = true;
                          });
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  'An error occurred. Please try again.',
                                ),
                              ),
                            );
                        }
                      }
                    },
                    label: isLoggingIn ? 'LOGGING IN...' : 'LOG IN',
                  ),
                  if (isLoggingIn)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'New to CITES?',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  const SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      nextNav(context, const SignupPage());
                    },
                    child: const Text(
                      'Register Here',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 30),
              // TextButton(
              //   onPressed: () {
              //     nextNav(context, const MyHomePage());
              //   },
              //   child: const Text('Skip Login'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
