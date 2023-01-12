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
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? error;

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  Future<void> signup() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('${Constants.url}register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'UserName': fullNameController.text,
          'Password': passController.text
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.pop(context);

        return;
      } else {
        setState(() {
          error = "Failed to register.";
        });
        throw Exception('Failed to register.');
      }
    }
  }

  Widget showAlert() {
    if (error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
                child: Text(error.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Gaming Paradise!",
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.blue,
            title: const Text('Search for games!'),
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
          body: SafeArea(
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
                        const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: DropdownButtonExample(),
                            )),
                        Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child:
                                  Container(height: 200, child: MyCustomForm()),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          selectedValue = value;
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        children: [
          TextField(
            controller: myController,
          ),
          Padding(
            padding: EdgeInsets.all(50.0),
            child: ElevatedButton(onPressed: () {}, child: Text("Search")),
          )
        ],
      ),
    ));
  }
}
