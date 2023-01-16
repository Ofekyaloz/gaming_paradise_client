import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gaming_social_network/post/popularPostItem.dart';
import '/post/postPage.dart';
import '../entities/Post.dart';
import '../utils.dart';
import 'postItem.dart';
import 'package:http/http.dart';

class PostsOverviewScreen extends StatefulWidget {
  PostsOverviewScreen(this.isGamePage, this.gameId, {super.key});

  bool isGamePage;
  int gameId;

  @override
  _PostsOverviewScreenState createState() => _PostsOverviewScreenState();
}

class _PostsOverviewScreenState extends State<PostsOverviewScreen> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  late bool userPost;
  final int _numberOfPostsPerRequest = 10;
  late List<Post> _posts;
  final int _nextPageTrigger = 3;
  late int _lastLoadIndex;
  late int _numOfPopular;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _posts = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _lastLoadIndex = 0;
    userPost = !widget.isGamePage;
    _numOfPopular = 100;
  }

  // If this page is game page - fetch this game posts, else fetch popular posts by user and then
  // fetch recent posts from the server.
  Future<void> fetchData() async {
    Response response;
    if (widget.isGamePage) {
      response = await get(
          Uri.parse("${Constants.url}posts/popular/game/${widget.gameId}?offset=$_pageNumber"));
    } else if (userPost) {
      response = await get(
          Uri.parse("${Constants.url}posts/popular/user/${Constants.userid}?offset=$_pageNumber"));
    } else {
      response = await get(Uri.parse("${Constants.url}posts/popular?offset=$_pageNumber"));
    }

    // if succeed to fetch posts
    if (response.statusCode == 200) {
      List responseList = json.decode(response.body);

      // create tmp post list from the response
      List<Post> postList = responseList.map((data) => Post.fromJson(data)).toList();

      // update the posts list and increase the offset for the next request
      setState(() {
        _isLastPage = postList.length < _numberOfPostsPerRequest;
        _pageNumber = _pageNumber + 1;
        _lastLoadIndex = _pageNumber;
        _posts.addAll(postList);
      });

      // if its the last page and done with the popular post per user, request the recent posts from
      // offset 0.
      if (_isLastPage && userPost) {
        setState(() {
          _numOfPopular = _posts.length;
          _loading = true;
          _pageNumber = 0;
          userPost = !userPost;
        });
        Future.delayed(const Duration(seconds: 3), () {
          fetchData();
        });
        return;
      }

      return;
      // if response has no content - if its user posts, change to recent posts.
    } else if (response.statusCode == 204) {
      if (userPost) {
        setState(() {
          _numOfPopular = _posts.length;
          _loading = true;
          _pageNumber = 0;
          userPost = !userPost;
        });
        Future.delayed(const Duration(seconds: 3), () {
          fetchData();
        });

        return;
      }
      return;
      // if failed - show error message
    } else {
      setState(() {
        _loading = false;
        _error = true;
        _lastLoadIndex = _lastLoadIndex - 1;
      });
    }
  }

  // show error message and retry button
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
    Future.delayed(const Duration(seconds: 1), () {
      fetchData();
    });

    return Scaffold(
      body: buildPostsView(),
    );
  }

  // List view of posts
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

    // Refresh the posts list if the user pull up the page
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _posts = [];
              _pageNumber = 0;
              _lastLoadIndex = 0;
              userPost = !widget.isGamePage;
              _loading = true;
              _isLastPage = false;
              _error = false;
              userPost = !widget.isGamePage;
            });
            fetchData();
          });
        },
        child: ListView.builder(
            itemCount: _posts.length + (_isLastPage ? 0 : 1),
            itemBuilder: (context, index) {

              // if is the end of a page, fetch new posts and show loading bar
              if (index == _posts.length - _nextPageTrigger &&
                  !_loading &&
                  index != _lastLoadIndex) {
                fetchData();
                setState(() {
                  _loading = true;
                  _lastLoadIndex = index;
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
                  // on tap a post, goes to post page
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => postPage(post))),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      // show differently popular post or regular post
                      child: index < _numOfPopular
                          ? PopularPostItem(post.Title, post.Content)
                          : PostItem(post.Title, post.Content)));
            }));
  }
}
