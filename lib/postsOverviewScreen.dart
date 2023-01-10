import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gaming_social_network/postPage.dart';
import 'postItem.dart';
import 'package:http/http.dart';
import 'entities/Post.dart';
import 'utils.dart';

class PostsOverviewScreen extends StatefulWidget {
  PostsOverviewScreen(this.isGamePage, {super.key});

  bool isGamePage;

  @override
  _PostsOverviewScreenState createState() => _PostsOverviewScreenState();
}

class _PostsOverviewScreenState extends State<PostsOverviewScreen> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfPostsPerRequest = 10;
  late List<Post> _posts;
  final int _nextPageTrigger = 3;
  late int _lastloadindex;
  late int _day;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _lastloadindex = 0;
    _day = 0;
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Response response;
      if (widget.isGamePage) {
        response = await get(Uri.parse("${Constants.url}posts/popular/user/${Constants.username}?offset=$_pageNumber&day=$_day"));
      } else {
        response = await get(Uri.parse("${Constants.url}posts/popular?offset=$_pageNumber&day=$_day"));
      }
      List responseList = json.decode(response.body);
      List<Post> postList = responseList.map((data) => Post.fromJson(data)).toList();

      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _posts.addAll(postList);
      });
    } catch (e) {
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
            style: TextStyle(fontSize: size, fontWeight: FontWeight.w500, color: Colors.black),
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
    if (_posts.isEmpty) {
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
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _pageNumber = 0;
              _lastloadindex = 0;
              _loading = true;
              _posts = [];
              fetchData();
            });
          });
        },
        child: ListView.builder(
            itemCount: _posts.length + (_isLastPage ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == _posts.length - _nextPageTrigger &&
                  !_loading &&
                  index != _lastloadindex) {
                fetchData();
                setState(() {
                  _loading = true;
                  _lastloadindex = index;
                });
              }
              if (index == _posts.length) {
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
              final Post post = _posts[index];
              return GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => postPage(post))),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: PostItem(post.Title, post.Content)));
            }));
  }
}
