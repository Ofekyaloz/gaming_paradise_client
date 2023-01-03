import 'dart:convert';
import 'package:comment_box/comment/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gameOverviewScreen.dart';
import 'signup.dart';
import 'new_post.dart';
import 'entities/User.dart';
import 'postPage.dart';
import 'entities/Post.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

// Future<Game> fetchGames() async {
//   final response = await http.get(Uri.parse('http://localhost:8000/api/games'));
//
//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Game.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load Game');
//   }
// }

Future<Post> fetechPost() async {
  final response =
  await http.get(Uri.parse('${Constants.url}posts/1/'));
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Game');
  }
}

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

  // late Future<Game> futureGame;
  late Future<Post> futruePost;
  // late Post post;

  @override
  void initState() {
    super.initState();
    // futureGame = fetchGames();
    // futruePost = fetechPost();
    // futruePost.then((result) => {
    //       setState(() {
    //         post = Post(result.Id, result.UserName, result.Title,
    //             result.GameName, result.TimestampCreated, result.Content);
    //       })
    //     });
  }

  List<User> users = <User>[User("ofek", "123")];

  Post post = Post(1,
      "Ofek Yaloz",
      "The best game I have played so far",
      "Bakushou!! All Yoshimoto Quiz-Ou Ketteisen",
      "1/1/2020",
      "The turn-based Strategy/RPG developed by a team called Shin's Deko was another of the Korean 3Ddddddddddddddddd exc... The turn-based Strategy/RPG developed by a team called Shin's Deko was another of the Korean 3DO exc...");

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        error = "Incorrect Email or Password";
      });
    }
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

    if (response.statusCode == 200) {
      if (!mounted) return;
      Constants.username = usernameController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => SignupPage(users)),
          // builder: (context) => postPage(post, true)),
            builder: (context) => GamesOverviewScreen()),
      );
      return;
    } else {
      setState(() {
        error = "Incorrect Email or Password";
      });
      throw Exception('Failed to login.');
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
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // FutureBuilder<Game>(
                          //   future: futureGame,
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData) {
                          //       return Text(snapshot.data!.Name);
                          //     } else if (snapshot.hasError) {
                          //       return Text('${snapshot.error}');
                          //     }
                          //
                          //     // By default, show a loading spinner.
                          //     return const CircularProgressIndicator();
                          //   },
                          // ),
                          Container(
                            padding: const EdgeInsets.all(10),
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
                              // keyboardType: TextInputType.emailAddress,
                              // validator: (text) {
                              //   if (text == null || text.isEmpty) {
                              //     return 'Email address can\'t be empty';
                              //   }
                              //   if (text.length < 8) {
                              //     return 'Email address must be 8 characters or longer!';
                              //   }
                              //   if (!RegExp(
                              //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              //       .hasMatch(text)) {
                              //     return 'Invalid email address!';
                              //   }
                              //   return null;
                              // },
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
                              // validator: (text) {
                              //   if (text == null || text == "") {
                              //     return 'Password can\'t be empty';
                              //   }
                              //   if (text.length < 6) {
                              //     return 'The password must be 8 characters or longer!';
                              //   }
                              //   if (!RegExp(".*[0-9].*").hasMatch(text)) {
                              //     return 'The password must contain at least one numeric character!';
                              //   }
                              //   if (!RegExp(".*[a-z].*").hasMatch(text)) {
                              //     return 'The password must contain at least one lowercase character!';
                              //   }
                              //   if (!RegExp(".*[A-Z].*").hasMatch(text)) {
                              //     return 'The password must contain at least one uppercase character!';
                              //   }
                              //   return null;
                              // },
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                onPressed: _name.isNotEmpty && _pass.isNotEmpty
                                    ? login
                                    : null,
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
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewPost("ofek", "The Sims 3")),
                            );
                          },
                          child: const Text(
                            'Forgot Password',
                          ),
                        ),
                      ],
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
                              MaterialPageRoute(
                                // builder: (context) => SignupPage()),
                                  builder: (context) =>
                                      postPage(post, false)), // get post id
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
