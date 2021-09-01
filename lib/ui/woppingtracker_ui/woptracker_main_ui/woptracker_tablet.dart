import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_detail_ui/woptracker_detail_mobile_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapBaseWidgetWrapperUI.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapUI.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_welcome_ui/woptracker_welcome_mobile_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_wrapper/woptracker_summary_stream_wrapper_ui.dart';


class WopTrackerTabletUI extends StatefulWidget {

  final User user;

  final List<QueryDocumentSnapshot> listDocumentSnapshot;

  const WopTrackerTabletUI({Key? key,required this.user, required this.listDocumentSnapshot}) : super(key: key);


  @override
  _WopTrackerTabletUIState createState() => _WopTrackerTabletUIState();
}

class _WopTrackerTabletUIState extends State<WopTrackerTabletUI> {

  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  String snackBarText = "";

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _isDrawerBeingShown = true;

  final List<Map<String,dynamic>> listEditMenu = [{"value": "Edit", "Icon": Icon(Icons.edit)}, {"value": "Delete", "Icon": Icon(Icons.delete)}];

  final ScrollController _scrollController = ScrollController();

  bool _isScrolled = false;

  _navigateDetailPage(BuildContext context, Map<String,dynamic> data) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WopTrackerMobileDetailUI(data: data)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {

    final snackBar = SnackBar(content: Text(snackBarText));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if(_isDrawerBeingShown) {
              setState(() {
                _isDrawerBeingShown = false;
              });
            } else {
              setState(() {
                _isDrawerBeingShown = true;
              });
            }
          },
          icon: (_isDrawerBeingShown) ? Transform.rotate(angle: pi/2, child:Icon(Icons.menu),) : Transform.rotate(angle: 0, child:Icon(Icons.menu),) ,
        ),
        title: Text("WopTracker"),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          (_isDrawerBeingShown) ? Drawer(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                DrawerHeader(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.user.email.toString(),
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                    trailing:Icon(Icons.add),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String? result = await _authService.signOut();

                    if (result != null) {
                      setState(() {
                        snackBarText = result;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: ListTile(
                    title: Text("Sign Out"),
                    trailing: Icon(Icons.logout),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WopTrackerSummaryStreamWrapperUI(user: widget.user)),
                    );
                  },
                  child: ListTile(
                    title: Text("Daily Summary"),
                    trailing: Icon(Icons.summarize),
                  ),
                ),
              ],
            ),
          ) : Container(),
          Expanded(
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              children: widget.listDocumentSnapshot.map((DocumentSnapshot documents) {
                Map<String,dynamic> data = documents.data() as Map<String,dynamic>;
                return Padding(
                  padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 0.0),
                  child: InkWell(
                    onTap: () {
                      _navigateDetailPage(context, data);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: (data["track_name"] != null) ? Text(data["track_name"]) : null,
                            subtitle: (data["track_date"] != null) ? Text(formatter.format(DateTime.fromMicrosecondsSinceEpoch(data["track_date"].microsecondsSinceEpoch))) : null,
                            trailing: PopupMenuButton(
                              child: Icon(Icons.more_vert_outlined),
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
                          (data["track"] != null) ? Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                            child: Container(
                                height: 200.0,
                                child: Stack(
                                  children: <Widget>[
                                    WopTrackerMainGoogleMapBaseWidgetUI(data: data,detailMode: false,),
                                    GestureDetector(
                                      onTap: () {
                                        _navigateDetailPage(context, data);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ): Container(),
                        ],
                      )
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
      floatingActionButton: (_isScrolled) ? FloatingActionButton(onPressed: () {
        _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(milliseconds: 5), curve: Curves.linear);
      },child: Icon(Icons.arrow_upward),) : null,
    );
  }
}
