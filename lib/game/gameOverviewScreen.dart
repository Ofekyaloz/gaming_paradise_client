import 'dart:convert';
import 'package:flutter/material.dart';
import '../entities/Game.dart';
import '../utils.dart';
import 'gamePage.dart';
import 'package:http/http.dart';
import 'gameItem.dart';


class GamesOverviewScreen extends StatefulWidget {
  @override
  _GamesOverviewScreenState createState() => _GamesOverviewScreenState();
}

class _GamesOverviewScreenState extends State<GamesOverviewScreen> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfGamesPerRequest = 10;
  late List<Game> _games;
  final int _nextPageTrigger = 3;
  late int _lastloadindex;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _games = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _lastloadindex = 0;
    fetchData();
  }

  // fetch games from the server
  Future<void> fetchData() async {
    try {
      final response =
          await get(Uri.parse("${Constants.url}games?offset=$_pageNumber"));

      List responseList = json.decode(response.body);
      List<Game> gameList =
          responseList.map((data) => Game.fromJson(data)).toList();


      // add all the games to ths list and update the page number.
      setState(() {
        _isLastPage = gameList.length < _numberOfGamesPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _games.addAll(gameList);
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = true;
        _lastloadindex = _pageNumber - 1;
      });
    }
  }

  // If failed to fetch games show this error dialog.
  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the games.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPostsView(),
    );
  }

  Widget buildPostsView() {
    if (_games.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(child: errorDialog(size: 20));
      }
    }

    // Create a list of games
    return ListView.builder(
        itemCount: _games.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _games.length - _nextPageTrigger && !_loading && index != _lastloadindex) {
            fetchData();
            setState(() {
              _loading = true;
              _lastloadindex = index;
            });
          }
          if (index == _games.length) {
            if (_error) {
              return Center(child: errorDialog(size: 15));
            } else {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }
          final Game game = _games[index];
          return GestureDetector(
            // go to gamePage
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => gamePage(game))),
            child: Padding(
                padding: const EdgeInsets.all(15.0), child: GameItem(game.Name)),
          );
        });
  }
}
