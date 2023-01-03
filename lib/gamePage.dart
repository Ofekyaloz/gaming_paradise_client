import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'postsOverviewScreen.dart';
import 'entities/Game.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'entities/Post.dart';
import 'new_post.dart';
import 'utils.dart';

class gamePage extends StatefulWidget {
  gamePage(this.game, {super.key});
  Game game;

  @override
  State<gamePage> createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
  late Future<List<Post>> posts;

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  // Future<String> fetchLikes() async {
  //   final response =
  //   await http.get(Uri.parse('${Constants.url}posts/${widget.post.Id}/likes/'));
  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to load likes');
  //   }
  // }

  Future<List<Post>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('${Constants.url}games/${widget.game.Name}/'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Post.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load likes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPost(widget.game.Name)),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.post_add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      widget.game.Name,
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink),
                    ),
                    const SizedBox(height: 10),
                    widget.game.Developer != null
                        ? Text(
                            "By ${widget.game.Developer}",
                            softWrap: true,
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlueAccent),
                          )
                        : const SizedBox(),
                    widget.game.Developer != null
                        ? const SizedBox(height: 5)
                        : const SizedBox(),
                    widget.game.ReleaseYear != null
                        ? Text(
                            "ReleaseYear: ${widget.game.ReleaseYear}",
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          )
                        : const SizedBox(),
                    widget.game.ReleaseYear != null
                        ? const SizedBox(height: 5)
                        : const SizedBox(),
                    Text(
                      "MaxPlayers: ${widget.game.MaxPlayers}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "ESRB: ${widget.game.ESRB}",
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    const SizedBox(height: 20),
                    InputDecorator(
                        decoration: InputDecoration(
                          border: widget.game.OverView != null
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11.0),
                                )
                              : InputBorder.none,
                        ),
                        child: widget.game.OverView != null
                            ? Text(widget.game.OverView!,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold))
                            : const SizedBox()),
                    const SizedBox(
                      height: 30,
                    ),
                    PostsOverviewScreen(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
