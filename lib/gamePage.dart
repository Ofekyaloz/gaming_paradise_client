import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gameInfo.dart';
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
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
    _pages =  <Widget>[
      GameInfo(widget.game),
      PostsOverviewScreen(),
    ];
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('${Constants.url}games/${widget.game.Name}/'));
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
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(color: Colors.greenAccent, size: 40),
        selectedItemColor: Colors.greenAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.deepOrangeAccent,
        ),
        unselectedItemColor: Colors.deepOrangeAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Posts',
          ),
        ],
      ),
    );
  }
}
