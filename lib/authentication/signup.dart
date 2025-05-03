import 'dart:async';
import 'package:cites/screens/homepage.dart';
import 'package:cites/widgets/customwidgets.dart';
import 'package:cites/widgets/formfields.dart';
import 'package:cites/widgets/pagesnavigator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:country_picker/country_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController lastPasswordController = TextEditingController();

  String selectedCountry = '';
  String selectedCountryCode = '';
  String selectedCountryName = '';

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    numberController.dispose();
    lastPasswordController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> sendUserData(
    String fullname,
    String email,
    String phone_number,
    String country_code,
    String country,
    String password,
    String status,
  ) async {
    // String url = 'http://10.5.17.11/cites/v1/users/insert.php';
    String url = 'http://10.5.4.40/cites/v1/users/insert.php';
    print(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': fullname,
          'email': email,
          'phone_number': phone_number,
          'country_code': selectedCountryCode,
          'country': selectedCountryName,
          'password': password,
          'status': '0',
        },
      );
      print(fullname);
      print(email);
      print(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Server returned status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFffffff),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/citeslogo.jpg',
                    height: 120,
                    width: 220,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'New to Cites?',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Register to use App',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: fullnameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  hint: 'Enter your full name',
                  validator: nameValidator,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.mail,
                  hint: 'Enter your email',
                  validator: emailValidator,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: numberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.phone),
                    hintText: 'Phone Number',
                    labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  validator: numberValidator,
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: _selectCountry,
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: TextEditingController(text: selectedCountry),
                      label: 'Select Your Country',
                      icon: Icons.flag,
                      hint: 'Select your country',
                      validator: countryValidator,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                PasswordFormField(
                  controller: lastPasswordController,
                  label: 'Password',
                  icon: Icons.lock,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 35),
                //register button
                PrimaryButton(
                  onpress: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      var fullname = fullnameController.text;
                      var email = emailController.text;
                      var phone_number = numberController.text;
                      var country_code = selectedCountryCode;
                      var country = selectedCountry;
                      var password = lastPasswordController.text;
                      var status = '0';

                      var response = await sendUserData(
                        fullname,
                        email,
                        phone_number,
                        country_code,
                        country,
                        password,
                        status,
                      );

                      if (response != null &&
                          response['status'] != null &&
                          response['status']) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              content: Text('Registration successful!')));

                        setState(() {
                          _isLoading = false;
                        });

                        // Clear form fields after successful registration
                        fullnameController.clear();
                        emailController.clear();
                        numberController.clear();
                        lastPasswordController.clear();
                        selectedCountry = '';
                        selectedCountryCode = '';
                        selectedCountryName = '';

                        // Navigate to home page
                        nextNavRemoveHistory(context, MyHomePage());
                      } else {
                        setState(() {
                          _isLoading = false;
                          _errorMessage = response != null &&
                                  response.containsKey('message')
                              ? response['message']
                              : 'Registration failed';
                        });

                        Timer(const Duration(seconds: 3), () {
                          setState(() {
                            _errorMessage = '';
                          });
                        });
                      }
                    }
                  },
                  label: 'REGISTER',
                ),

                // Show loading animation if _isLoading is true
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),

                // Show error message if _errorMessage is not empty
                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country.displayName;
          selectedCountryCode = country.countryCode;
          selectedCountryName = country.name;
        });
      },
    );
  }
}
