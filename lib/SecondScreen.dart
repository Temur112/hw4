import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hw4/thirdScreen.dart';
import 'package:sqflite/sqflite.dart';

class SecondScreen extends StatefulWidget {
  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<SecondScreen> {
  List<dynamic> userList = [];

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=5'));
    if (response.statusCode == 200) {
      setState(() {
        userList = jsonDecode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Two'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              fetchUsers();
            },
            child: Text('Get More Users'),
          ),
          ElevatedButton(
            onPressed: () {
              // Store selected data into SQLite database
              saveUserDataToDatabase();
            },
            child: Text('Store Selected Data'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userList[index]['name']['first']),
                  subtitle: Text(userList[index]['email']),
                );
              },
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) => ScreenThree(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        }));
              },
              child: const Text("Go"))
        ],
      ),
    );
  }

  Future<void> saveUserDataToDatabase() async {
    // Initialize the database
    final Future<Database> database = openDatabase(
      'user_database.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, firstName TEXT, email TEXT)',
        );
      },
      version: 1,
    );

    // Insert selected user data into the database
    final Database db = await database;
    for (var user in userList) {
      await db.insert(
        'users',
        {
          'firstName': user['name']['first'],
          'email': user['email'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Show a snackbar or perform other actions upon successful storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected data stored in local database.'),
      ),
    );
  }
}
