import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entities/Game.dart';
import '../post/newPostPage.dart';
import '../post/postsOverviewScreen.dart';
import 'gameInfo.dart';
import '../review/gameReviews.dart';

class gamePage extends StatefulWidget {
  gamePage(this.game, {super.key});
  Game game;

  @override
  State<gamePage> createState() => _gamePageState();
}

class _gamePageState extends State<gamePage> {
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

    // bottom bar pages
    _pages = <Widget>[
      GameInfo(widget.game),
      PostsOverviewScreen(true, widget.game.ID),
      gameReviews(widget.game.ID)
    ];
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
            MaterialPageRoute(builder: (context) => NewPost(widget.game.ID.toString())),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.post_add),
      ),
      body: SafeArea(

        // Shows the selected page
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Reviews',
          ),
        ],
      ),
    );
  }
}
