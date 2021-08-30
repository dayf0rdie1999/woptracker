import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/woppingtracker_ui/google_map_ui/googlemapwrapperui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_detail_ui/woptracker_detail_desktop_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_detail_ui/woptracker_detail_mobile_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapUI.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils_ui/header_title_ui.dart';


class WopTrackerDesktopUI extends StatefulWidget {

  final User user;

  final List<DocumentSnapshot> documents;

  final Map<String,dynamic>? receivedData;

  const WopTrackerDesktopUI({Key? key, required this.user, required this.documents, required this.receivedData}) : super(key: key);

  @override
  _WopTrackerDesktopUIState createState() => _WopTrackerDesktopUIState();
}

class _WopTrackerDesktopUIState extends State<WopTrackerDesktopUI> {

  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Map<String,dynamic>? _data;

  String? _docId;

  String snackBarText = "";

  final List<Map<String,dynamic>> listEditMenu = [{"value": "Edit", "Icon": Icon(Icons.edit)}, {"value": "Delete", "Icon": Icon(Icons.delete)}];

  final ScrollController _scrollController = ScrollController();

  bool _isScrolled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getReceivedData();
    _scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (_scrollController.offset != _scrollController.initialScrollOffset) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }


  Map<String,dynamic>? getReceivedData() {
    if(widget.receivedData != null) {
      return widget.receivedData;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final snackBar = SnackBar(content: Text(snackBarText));

    return Scaffold(
      appBar: AppBar(
        title: Text("WopTracker"),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: Text(widget.user.email!),
                    ),
                  )
                ),
                InkWell(
                  onTap: () async {

                    String? result = await _storeService.createEmptyTracker(widget.user.uid);

                    if (result != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WopTrackerAddUIWrapper(userId: widget.user.uid,docId: result,editMode: false,)),
                      );
                    } else {
                      setState(() {
                        snackBarText = "Can't connect to the server";
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                  },
                  child: ListTile(
                    title: Text("Add Track"),
                    trailing: Icon(Icons.add),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String? result = await _authService.signOut();

                    if (result != null) {

                      setState(() {
                        snackBarText = "Can't Connect to The Authentication Service";
                      });

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: ListTile(
                    title: Text("Sign Out"),
                    trailing: Icon(Icons.logout),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          children: widget.documents.map((documents) {
                            Map<String,dynamic> data = documents.data() as Map<String,dynamic>;
                            return Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                              child: Container(
                                width: 256.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => WopTrackerDesktopUI(user: widget.user,documents: widget.documents,receivedData: data,)),
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  color: Colors.blueAccent,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: PopupMenuButton(
                                                      child: Icon(Icons.more_vert_outlined),
                                                      iconSize: 24.0,
                                                      onSelected: (result) async {
                                                        if (result == "Edit") {
                                                          Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => WopTrackerAddUIWrapper(userId: widget.user.uid, docId: documents.id, editMode: true)),
                                                          );
                                                        } else if (result == "Delete") {
                                                          String? result = await _storeService.deleteTracker(widget.user.uid, documents.id);

                                                          if (result == null) {
                                                            setState(() {
                                                              snackBarText = "Can't connect to the server";
                                                            });
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          }
                                                        }
                                                      },
                                                      itemBuilder: (context) {
                                                        return listEditMenu.map((Map<String,dynamic> val) {
                                                          return PopupMenuItem(
                                                            value: val["value"],
                                                            child: Center(
                                                              child: val["Icon"],
                                                            ),
                                                          );
                                                        }).toList();
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
                                          child: SectionHeader(headerTitle: "Track Name")
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
                                          child: Container(
                                            height: 32.0,
                                            child: Center(
                                              child: (data["track_name"] != null) ? Text(data["track_name"],style: TextStyle(color: Colors.blueAccent,fontSize: 20.0),) : null,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
                                          child: SectionHeader(headerTitle: "Track Date")
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
                                          child: Container(
                                            height: 32.0,
                                            child: Center(
                                              child: (data["track_date"] != null) ? Text(formatter.format(DateTime.fromMicrosecondsSinceEpoch(data["track_date"].microsecondsSinceEpoch)), style: TextStyle(color: Colors.blueAccent,fontSize: 20.0),) : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Todo: Adding Return initial position
                      (_isScrolled) ? Expanded(
                        flex: 0,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(milliseconds: 5), curve: Curves.linear);
                                },
                                child: Expanded(
                                  child: Container(
                                    color: Colors.blueAccent,
                                    child: Icon(Icons.arrow_left),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ): Container(color: Colors.transparent,),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Divider(
                    thickness: 4.0,
                    endIndent: 16.0,
                    indent: 16.0,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                      child: (_data != null) ? WopTrackerDesktopDetailUI(data: _data!,) : Text("Select a Track", style: TextStyle(fontSize: 32.0,color: Colors.blueAccent),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


