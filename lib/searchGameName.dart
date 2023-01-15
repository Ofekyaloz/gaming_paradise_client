import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/gamePage.dart';
import 'package:http/http.dart';
import 'game/gameItem.dart';
import 'entities/Game.dart';

class SearchGameNameScreen extends StatefulWidget {
  String url;
  SearchGameNameScreen(this.url, {super.key});

  @override
  _SearchGameNameState createState() => _SearchGameNameState();
}

class _SearchGameNameState extends State<SearchGameNameScreen> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
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

  Future<void> fetchData() async {

      final response =
          await get(Uri.parse("${widget.url}&offset=$_pageNumber"));

      if (response.statusCode == 200) {
        List responseList = json.decode(response.body);
        List<Game> postList =
        responseList.map((data) => Game.fromJson(data)).toList();

        setState(() {
          _isLastPage = postList.length < _numberOfPostsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _games.addAll(postList);
        });
      } else {
      setState(() {
        _loading = false;
        _error = true;
        _lastloadindex = _lastloadindex - 1;
      });
    }
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
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
    return MaterialApp(
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
        body: buildPostsView(),
      ),
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
    return ListView.builder(
        itemCount: _games.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == _games.length - _nextPageTrigger &&
              !_loading &&
              index != _lastloadindex) {
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
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => gamePage(game))),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GameItem(game.Name)),
          );
        });
  }
}
