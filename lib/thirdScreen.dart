import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ScreenThree extends StatefulWidget {
  @override
  _ScreenThreeState createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {
  List<Map<String, dynamic>> storedUsers = [];

  @override
  void initState() {
    super.initState();
    retrieveStoredUsers();
  }

  Future<void> retrieveStoredUsers() async {
    final Future<Database> database = openDatabase(
      'user_database.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, firstName TEXT, email TEXT)',
        );
      },
      version: 1,
    );

    final Database db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');

    setState(() {
      storedUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Three'),
      ),
      body: storedUsers.isEmpty
          ? Center(
              child: Text('No stored users found.'),
            )
          : ListView.builder(
              itemCount: storedUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(storedUsers[index]['firstName']),
                  subtitle: Text(storedUsers[index]['email']),
                );
              },
            ),
    );
  }
}
