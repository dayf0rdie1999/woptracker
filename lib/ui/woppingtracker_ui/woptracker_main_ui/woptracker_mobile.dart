import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_detail_ui/woptracker_detail_mobile_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_google_map_main_ui/WopTrackerMainGoogleMapBaseWidgetWrapperUI.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_welcome_ui/woptracker_welcome_mobile_ui.dart';


class WopTrackerMobileUI extends StatefulWidget {

  final String userId;

  final List<QueryDocumentSnapshot> listDocumentSnapshot;

  const WopTrackerMobileUI({Key? key, required this.userId, required this.listDocumentSnapshot}) : super(key: key);

  @override
  _WopTrackerMobileUIState createState() => _WopTrackerMobileUIState();
}

class _WopTrackerMobileUIState extends State<WopTrackerMobileUI> {

  final _authService = AuthService(auth: FirebaseAuth.instance);

  final _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

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

    final snackBar = SnackBar(content: Text("Can't Connect to the Internet"),);

    return Scaffold(
      appBar: AppBar(
        title: Text("WopTracker"),
        centerTitle: true,
        actions: [
          IconButton(
            key: Key("SignOutButton"),
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              String? result = await _authService.signOut();
              if(result != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
              }
            },
          )
        ],
      ),
      body:
      (widget.listDocumentSnapshot.length != 0) ? Stack(
        children: [
            ListView(
            controller: _scrollController,
            children: widget.listDocumentSnapshot.map((DocumentSnapshot document) {
              Map<String,dynamic> data = document.data()! as Map<String,dynamic>;
              print(data["track_date"]);
              return Padding(
                padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      _navigateDetailPage(context,data);
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: (data["track_name"] != null) ? Text(data["track_name"]) : null,
                          subtitle: (data["track_date"] != null) ? Text("Track Date: ${formatter.format(DateTime.fromMicrosecondsSinceEpoch(data["track_date"].microsecondsSinceEpoch))}") : null,
                          trailing: PopupMenuButton(
                            child: Icon(Icons.more_vert_outlined),
                            onSelected: (result) async {
                              if (result == "Edit") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WopTrackerAddUIWrapper(userId: widget.userId,docId: document.id,editMode: true,))
                                );
                              } else if (result == "Delete") {
                                String? result = await _storeService.deleteTracker(widget.userId, document.id);

                                if (result == null) {
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
                                      _navigateDetailPage(context,data);
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
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: (_isScrolled) ? Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent
                ),
                child: IconButton(
                  onPressed: () {
                    _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(milliseconds: 5), curve: Curves.linear);
                  },
                  icon: Icon(Icons.arrow_upward),
                ),
              ): null,
            ),
          ),
        ],
      ) : WopTrackerWelcomeUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? result = await _storeService.createEmptyTracker(widget.userId);
          if (result != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WopTrackerAddUIWrapper(userId: widget.userId,docId: result,editMode: false,)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Icon(
            Icons.add_circle_outline
        ),
      ),
    );
  }
}


