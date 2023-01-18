import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mainPage.dart';
import 'signupPage.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Gaming Paradise!';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _name = '', _pass = '';
  String? error;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Send a login request to the server
  void login() async {
    // check if the username and the password are valid
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // send a login request
    final response = await http.post(
      Uri.parse('${Constants.url}login/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UserName': usernameController.text,
        'Password': passwordController.text
      }),
    );

    // if succeed update the username and id and clear the fields and go to the main page
    if (response.statusCode == 200) {
      if (!mounted) return;

      setState(() {
        _pass = '';
        _name = '';
        Constants.username = usernameController.text;
        Constants.userid = json.decode(response.body);
      });
      usernameController.clear();
      passwordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => mainPage()),
      );
      return;

      // if failed show an error
    } else {
      setState(() {
        error = "Incorrect Email or Password";
      });
      throw Exception('Failed to login.');
    }
  }

  // if error is not none, write the error
  Widget showAlert() {
    if (error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: Text(error.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      home: Scaffold(
        appBar: AppBar(title: const Text(MyApp._title), centerTitle: true),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    showAlert(),
                    const SizedBox(height: 20),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            // username field
                            child: TextFormField(
                              controller: usernameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.account_circle_outlined),
                                labelText: 'UserName',
                              ),

                              // UserName validations
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'UserName can\'t be empty';
                                }
                                if (text.length < 3) {
                                  return 'UserName address must be 3 characters or longer!';
                                }
                                if (text.length > 20) {
                                  return 'UserName must be 20 characters or shorter!';
                                }
                                if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(text)) {
                                  return 'UserName contains only letters&numbers!';
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() => _name = text),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(30),
                              ],
                              obscureText: true,
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.password),
                                labelText: 'Password',
                              ),
                              // Password validations
                              validator: (text) {
                                if (text == null || text == "") {
                                  return 'Password can\'t be empty';
                                }
                                if (text.length < 6) {
                                  return 'The password must be 8 characters or longer!';
                                }
                                if (text.length > 20) {
                                  return 'The password must be 20 characters or shorter!';
                                }
                                if (!RegExp(".*[0-9].*").hasMatch(text)) {
                                  return 'The password must contain at least one numeric character!';
                                }
                                if (!RegExp(".*[a-z].*").hasMatch(text)) {
                                  return 'The password must contain at least one lowercase character!';
                                }
                                if (!RegExp(".*[A-Z].*").hasMatch(text)) {
                                  return 'The password must contain at least one uppercase character!';
                                }
                                if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(text)) {
                                  return 'Password contains only letters&numbers!';
                                }
                                return null;
                              },
                              onChanged: (text) => setState(() => _pass = text),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.blueAccent,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                onPressed: _name.isNotEmpty && _pass.isNotEmpty ? login : null,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Login'),
                                    SizedBox(width: 20),
                                    Icon(Icons.login)
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            usernameController.clear();
                            passwordController.clear();
                            setState(() {
                              _pass = '';
                              _name = '';
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupPage()),
                              //   builder: (context) =>
                              //       mainPage()),
                              //       postPage(post)), // get post id
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }
}
