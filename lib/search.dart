import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'searchGameName.dart';

List<String> list = <String>[
  'Search by game name',
  'Search by Genre',
  'Search by Platform'
];

String? selectedValue;

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _selectedOption = 'Search by game name';
  TextEditingController _searchController = TextEditingController();
  List<String> genrs = [], platforms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchGeners();
    // fetchPlatforms();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text(
                              "Search options:",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: DropdownButton<String>(
                                value: _selectedOption,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    _selectedOption = value!;
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                        TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a game',
                            )),
                        Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  String searchText = _searchController.text;
                                  String url = "hey";
                                  if (_selectedOption ==
                                      'Search by game name') {
                                    url =
                                        '${Constants.url}games/?game=$searchText';
                                  } else if (_selectedOption ==
                                      'Search by Genre') {
                                    url =
                                        '${Constants.url}genres/?genre=$searchText';
                                  } else if (_selectedOption ==
                                      'Search by Platform') {
                                    url =
                                        '${Constants.url}platforms/?platform=$searchText';
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchGameNameScreen(url)),
                                  );
                                },
                                child: const Text('Search'),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
