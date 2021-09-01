import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/ui_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woppingtracker_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_summary_ui/woptracker_summary_wrapper/woptracker_summary_stream_wrapper_ui.dart';

class WopTrackerSummaryDesktopUI extends StatefulWidget {

  final User user;

  final List<DocumentSnapshot> documents;

  const WopTrackerSummaryDesktopUI({Key? key, required this.user, required this.documents}) : super(key: key);

  @override
  _WopTrackerSummaryDesktopUIState createState() => _WopTrackerSummaryDesktopUIState();
}

class _WopTrackerSummaryDesktopUIState extends State<WopTrackerSummaryDesktopUI> {

  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  double aveRunSpeed = 0.0;
  double runTotalDistance = 0.0;
  int totalRunHour = 0;
  int totalRunMinute = 0;
  int totalRunSecond = 0;

  String snackBarText = "Can't connect to the server";

  @override
  void initState() {
    // TODO: implement initState
    getTodayWopSummary();
    super.initState();
  }

  void getTodayWopSummary() {

    if (widget.documents.isNotEmpty) {
      widget.documents.forEach((document) {
        var data = document.data() as Map<String,dynamic>;

        aveRunSpeed += double.parse(data["track_avg_speed"]);
        runTotalDistance += double.parse(data["track_distance"]);
        totalRunHour += int.parse(data["track_time"]["Hours"].toString());
        totalRunMinute += int.parse(data["track_time"]["Minutes"].toString());
        totalRunSecond += int.parse(data["track_time"]["Seconds"].toString());

        if (totalRunSecond >= 60) {
          totalRunSecond = totalRunSecond - 60;
          totalRunMinute = totalRunMinute + 1;
        }

        if (totalRunMinute >= 60) {
          totalRunMinute = totalRunMinute - 60;
          totalRunHour = totalRunHour + 1;
        }
      });

      aveRunSpeed = aveRunSpeed/widget.documents.length;
    }
  }

  @override
  Widget build(BuildContext context) {

    final snackBar = SnackBar(content: Text(snackBarText));

    return Scaffold(
      appBar: AppBar(),
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
                    String? result = await _authService.signOut();

                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthWrapper()),
                      );
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
                        MaterialPageRoute(builder: (context) => ProviderScope(child: WopTrackerWrapperUI())),
                    );
                  },
                  child: ListTile(
                    title: Text("Return Tracking List"),
                    trailing: Icon(Icons.list_alt),
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
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 256.0,
                        lineWidth: 24.0,
                        percent: (aveRunSpeed/12874.7 > 1.0) ? 1.0 : aveRunSpeed/12874.7,
                        center: Text(
                          "${((aveRunSpeed/12874.7)*100).round()}%",
                          style: TextStyle(
                            fontSize: 24.0
                          ),
                        ),
                        progressColor: Colors.green,
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "Average Speed Run",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Text(aveRunSpeed.toString(),style: TextStyle(
                        fontSize: 24.0,
                      )),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 256.0,
                        lineWidth: 24.0,
                        percent: (runTotalDistance/3218.69 > 1.0) ? 1.0 : runTotalDistance/3218.69,
                        center: Text(
                          "${((runTotalDistance/3218.69)*100).round()}%",
                          style: TextStyle(
                              fontSize: 24.0
                          ),
                        ),
                        progressColor: Colors.green,
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "Total Distance",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Text(runTotalDistance.toString(),style: TextStyle(
                          fontSize: 24.0
                      ),),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 256.0,
                        lineWidth: 24.0,
                        percent: (getPercentMinutes() > 1.0) ? 1.0 : getPercentMinutes(),
                        center: Text(
                          "${(getPercentMinutes()*100).round()}%",
                          style: TextStyle(
                              fontSize: 24.0
                          ),
                        ),
                        progressColor: Colors.green,
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "Total Time",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "${totalRunHour.toString()}:${totalRunMinute.toString()}:${totalRunSecond.toString()}",
                        style: TextStyle(
                            fontSize: 24.0
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  double getPercentMinutes() {

    var totalMinutes = totalRunHour * 60 + totalRunMinute + totalRunSecond/60;

    return totalMinutes/30;

  }
}
