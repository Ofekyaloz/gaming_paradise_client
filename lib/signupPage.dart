import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? error;

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Constants.url}register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserName': userNameController.text,
          'Password': passController.text
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context);

        return;
      } else {
        setState(() {
          error = "Failed to register.";
        });
        throw Exception('Failed to register.');
      }
    }
  }

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
                child: Text(error.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold))),
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
    return const SizedBox(height: 0,);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Gaming Paradise!",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.blue,
            title: const Text('Gaming Paradise!'),
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                )),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        showAlert(),
                        const SizedBox(height: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                  ],
                                  controller: userNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.account_circle_outlined),
                                    labelText: 'UserName',
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'UserName can\'t be empty';
                                    }
                                    if (text.length < 3) {
                                      return 'UserName must be 3 characters or longer!';
                                    }
                                    if (text.length > 20) {
                                      return 'UserName must be 20 characters or shorter!';
                                    }
                                    if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(text)) {
                                      return 'UserName contains only letters&numbers!';
                                    }
                                    return null;
                                  },
                                  onChanged: (text) =>
                                      setState(() => _name = text),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                  ],
                                  obscureText: true,
                                  controller: passController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.password),
                                    labelText: 'Password',
                                  ),
                                  validator: (text) {
                                    if (text == null || text == "") {
                                      return 'Password can\'t be empty';
                                    }
                                    if (text.length < 6) {
                                      return 'The password must be 6 characters or longer!';
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
                                  onChanged: (text) =>
                                      setState(() => _name = text),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(30),
                                  ],
                                  controller: confPassController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.password),
                                    labelText: 'Confirm Password',
                                  ),
                                  validator: (text) {
                                    if (text == null || text == "") {
                                      return 'Password can\'t be empty';
                                    }
                                    if (text != passController.value.text) {
                                      return 'The passwords are different!';
                                    }
                                    if (text.length < 6) {
                                      return 'The password must be 6 characters or longer!';
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
                                  onChanged: (text) =>
                                      setState(() => _name = text),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.only(top: 3, left: 3),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 60,
                                      onPressed:
                                    confPassController.text.isNotEmpty && _name.isNotEmpty && passController.text.isNotEmpty ? signup : null,
                                      color: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Login button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Already have an account?'),
                            TextButton(
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
