import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaming_social_network/search.dart';
import 'package:gaming_social_network/utils.dart';
import 'post/postsOverviewScreen.dart';
import 'game/gameOverviewScreen.dart';
import 'profilePage.dart';

class mainPage extends StatefulWidget {
  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  int _selectedIndex = 0;

  // update the current page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // Bottom bar options
  static final List<Widget> _pages = <Widget>[
    PostsOverviewScreen(false, -1),

    GamesOverviewScreen(),

    Search(),

    ProfilePage(Constants.userid.toString(), Constants.username!),
  ];

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

      // show the selected page
      body: SafeArea(child: Center(child: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ))),

      // bottom navigator bar view
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedFontSize: 20,
        selectedIconTheme:
            const IconThemeData(color: Colors.greenAccent, size: 40),
        selectedItemColor: Colors.greenAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(
          color: Colors.deepOrangeAccent,
        ),
        unselectedItemColor: Colors.deepOrangeAccent,
        currentIndex: _selectedIndex,

        // on tap icon call _onItemTapped function
        onTap: _onItemTapped,

        // icons and labels of bottom bar
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games_sharp),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_sharp),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

}
