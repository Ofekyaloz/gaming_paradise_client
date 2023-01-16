import 'dart:convert';
import 'package:flutter/material.dart';
import 'reviewItem.dart';
import '../entities/Review.dart';
import 'package:http/http.dart';
import '../utils.dart';
import 'ReviewPage.dart';

class gameReviews extends StatefulWidget {
  gameReviews(this.gameId, {super.key});

  int gameId;

  @override
  _gameReviewsState createState() => _gameReviewsState();
}

class _gameReviewsState extends State<gameReviews> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfReviewsPerRequest = 10;
  late List<Review> _reviews;
  final int _nextPageTrigger = 3;
  late int _lastLoadIndex;

  @override
  void initState() {
    super.initState();
    _pageNumber = 0;
    _reviews = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    _lastLoadIndex = 0;
    fetchData();
  }

  // Fetch reviews
  Future<void> fetchData() async {
    Response response = await get(Uri.parse(
        "${Constants.url}games/${widget.gameId}/reviews?offset=$_pageNumber"));

    // if succeed add the reviews to the list and try to fetch the next offset
    if (response.statusCode == 200) {
      List responseList = json.decode(response.body);
      List<Review> postList = responseList.map((data) => Review.fromJson(data)).toList();

      setState(() {
        _isLastPage = postList.length < _numberOfReviewsPerRequest;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        _reviews.addAll(postList);
      });

      // if failed or there is no reviews show error and retry button
    } else {
      setState(() {
        _loading = false;
        _error = false;
        _lastLoadIndex = _pageNumber;
      });
      if (_reviews.isEmpty) {
        setState(() {
          _error = true;
        });
      }
    }
  }


  // error dialog - retry button
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

  // show the review list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildReviewView(),
    );
  }

  Widget buildReviewView() {
    if (_reviews.isEmpty) {
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
    // Refresh the review list if the user pull up the page
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _pageNumber = 0;
              _lastLoadIndex = 0;
              _loading = true;
              _reviews = [];
              _isLastPage = false;
              _error = false;
            });
            fetchData();
          });
        },
        child: ListView.builder(
            itemCount: _reviews.length + (_isLastPage ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == _reviews.length - _nextPageTrigger &&
                  !_loading &&
                  index != _lastLoadIndex) {
                fetchData();
                setState(() {
                  _loading = true;
                  _lastLoadIndex = index;
                });
              }
              if (index == _reviews.length) {
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
              final Review review = _reviews[index];
              return GestureDetector(
                // on pat, goes to review page
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ReviewPage(review))),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ReviewItem(review.UserName, review.Content)));
            }));
  }
}
