import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaming_social_network/post/postPage.dart';
import 'entities/Game.dart';
import 'entities/Post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils.dart';
import 'game/gamePage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(this.userid, this.username, {super.key});

  String userid;
  String username;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Post> posts;
  late List<Game> games;

  @override
  void initState() {
    super.initState();
    posts = [];
    games = [];
    fetchPosts();
    fetchGames();
  }

  // Fetch the posts of the connected user
  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('${Constants.url}posts/user/${Constants.userid}/'));
    if (response.statusCode == 200) {
      List responseList = json.decode(response.body);
      List<Post> tmpList = responseList.map((data) => Post.fromJson(data)).toList();

      setState(() {
        posts.addAll(tmpList);
      });
    }
  }

  // Fetch the games of the connected user
  Future<void> fetchGames() async {
    final response = await http.get(Uri.parse('${Constants.url}users/${Constants.userid}/games/'));
    if (response.statusCode == 200) {
      List responseList = json.decode(response.body);
      List<Game> tmpList = responseList.map((data) => Game.fromJson(data)).toList();

      setState(() {
        games.addAll(tmpList);
      });
    }
  }

  // List of the games
  Widget showGames() {
    if (games.isEmpty) {
      return const SizedBox();
    }
    return Container(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: games.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
        itemBuilder: (context, index) {
          final Game game = games[index];

          return Padding(
              padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
              child: Center(
                child: GestureDetector(

                    // On tap a game - goes to gamePage.
                    onTap: () async {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => gamePage(game)));
                    },
                    child: Text(
                        softWrap: true,
                        game.Name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
              ));
        },
      ),
    );
  }

  // List of posts
  Widget showPosts() {
    if (posts.isEmpty) {
      return const SizedBox();
    }
    return Container(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 1,
          );
        },
        itemBuilder: (context, i) {
          final Post post = posts[i];

          return Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
            child: Center(
              child: GestureDetector(
                // On tap a post - goes to postPage.
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => postPage(post)));
                },
                child: Text(
                    softWrap: true,
                    post.Title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: LayoutBuilder(
      // On pull up, refresh the page
      builder: (context, constraints) => RefreshIndicator(
          onRefresh: () {
            return Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                games = [];
                posts = [];
              });
              fetchGames();
              fetchPosts();
            });
          },
          child: SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Text(
                          Constants.username.toString(),
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const Text("Favorites Games:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                        const SizedBox(height: 10),
                        games.isNotEmpty
                            ? InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                child: showGames())
                            : const InputDecorator(
                                decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        const SizedBox(height: 20),
                        const Text("Posts:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                        posts.isNotEmpty
                            ? InputDecorator(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                child: showPosts())
                            : const InputDecorator(
                                decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                        const SizedBox(height: 30)
                      ]))))),
    ));
  }
}
