import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:like_button/like_button.dart';
import 'utils.dart';
import 'entities/FullGame.dart';
import 'entities/Game.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameInfo extends StatefulWidget {
  GameInfo(this.game, {super.key});

  Game game;

  @override
  _GameInfoState createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  late List<String> platforms;
  late List<String> genres;
  bool isFavorite = false;

  void initState() {
    super.initState();
    platforms = [];
    genres = [];
    fetchFullGame();
  }

  Future<void> fetchFullGame() async {
    String gameName = Uri.encodeComponent(widget.game.Name);
    final response = await http.get(Uri.parse('${Constants.url}games/$gameName/'));
    if (response.statusCode == 200) {
      FullGame g = FullGame.fromJson(jsonDecode(response.body));
      setState(() {
        platforms = g.Platforms;
        genres = g.Genres;
      });
    } else {
      throw Exception('Failed to load FullGame');
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final response = await http.post(
      Uri.parse('${Constants.url}users/${Constants.username}/games/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'GameName': widget.game.Name,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        showIfLiked();
      });
    } else {
      setState(() {
        showIfLiked();
      });
    }
    return !isLiked;
  }

  Future<void> showIfLiked() async {
    final response = await get(
        Uri.parse("${Constants.url}users/${Constants.username}/games/${widget.game.Name}/"));
    if (response.statusCode == 200) {
      setState(() {
        isFavorite = true;
      });
    } else {
      setState(() {
        isFavorite = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                width: double.infinity,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  isFavorite ? const Text("This game in Favorites!") : const Text("Click here to save this game in favorites!"),
                  LikeButton(
                    isLiked: isFavorite,
                    circleColor: const CircleColor(
                        start: Colors.orangeAccent, end: Colors.deepOrangeAccent),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Colors.orangeAccent,
                      dotSecondaryColor: Colors.deepOrangeAccent,
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.flag,
                        color: isLiked ? Colors.orange : Colors.grey,
                      );
                    },
                    onTap: onLikeButtonTapped,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.game.Name,
                    softWrap: true,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                  const SizedBox(height: 20),
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
                  widget.game.Developer != null ? const SizedBox(height: 20) : const SizedBox(),
                  widget.game.ReleaseYear != null
                      ? Text(
                          "ReleaseYear: ${widget.game.ReleaseYear}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : const SizedBox(),
                  widget.game.ReleaseYear != null ? const SizedBox(height: 20) : const SizedBox(),
                  Text(
                    "MaxPlayers: ${widget.game.MaxPlayers}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "ESRB: ${widget.game.ESRB}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                  const SizedBox(height: 20),
                  genres.isNotEmpty
                      ? Text(
                          "Genres: ${genres.join(', ')}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : const SizedBox(),
                  genres.isNotEmpty ? const SizedBox(height: 20) : const SizedBox(),
                  platforms.isNotEmpty
                      ? Text(
                          "Platform: ${platforms.join(', ')}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                        )
                      : const SizedBox(),
                  platforms.isNotEmpty ? const SizedBox(height: 20) : const SizedBox(),
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
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 20,
                              ))
                          : const SizedBox()),
                  const SizedBox(height: 30)
                ]))));
  }
}
