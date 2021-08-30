import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woppingtracker_wrapper.dart';


class WopTrackerSummaryMobileUI extends StatefulWidget {

  final User user;

  const WopTrackerSummaryMobileUI({Key? key, required this.user}) : super(key: key);

  @override
  _WopTrackerSummaryMobileUIState createState() => _WopTrackerSummaryMobileUIState();
}

class _WopTrackerSummaryMobileUIState extends State<WopTrackerSummaryMobileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WopTracker Summary"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProviderScope(child: WopTrackerWrapperUI())),
            );
          }, icon: Icon(Icons.list_alt)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 16.0),
                    child: Text(widget.user.email!,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              )
            ),
            InkWell(
              onTap: () {
                print("Logging out user");
              },
              child: ListTile(
                title: Text("Sign Out"),
                trailing: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {

          },
          child: Text("Get Date"),
        ),
      ),
    );
  }
}
