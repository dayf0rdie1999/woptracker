import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woptracker/services/auth/auth_service.dart';
import 'package:woptracker/ui/ui_wrapper.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_wrapper/woppingtracker_wrapper.dart';
import 'package:percent_indicator/percent_indicator.dart';

class WopTrackerSummaryMobileUI extends StatefulWidget {

  final User user;

  final List<DocumentSnapshot> documents;

  const WopTrackerSummaryMobileUI({Key? key, required this.user, required this.documents}) : super(key: key);

  @override
  _WopTrackerSummaryMobileUIState createState() => _WopTrackerSummaryMobileUIState();
}

class _WopTrackerSummaryMobileUIState extends State<WopTrackerSummaryMobileUI> {

  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  String snackBarText = "Can't connect to the server";

  double aveRunSpeed = 0.0;
  double runTotalDistance = 0.0;
  int totalRunHour = 0;
  int totalRunMinute = 0;
  int totalRunSecond = 0;

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
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 110.0,
                  lineWidth: 10.0,
                  percent: (aveRunSpeed/12874.7 > 1.0) ? 1.0 : aveRunSpeed/12874.7,
                  center: Text(
                    "${((aveRunSpeed/12874.7)*100).round()}%",
                  ),
                  progressColor: Colors.green,
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Average Speed Run",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(aveRunSpeed.toString()),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 110.0,
                  lineWidth: 10.0,
                  percent: (runTotalDistance/3218.69 > 1.0) ? 1.0 : runTotalDistance/3218.69,
                  center: Text(
                    "${((runTotalDistance/3218.69)*100).round()}%",
                  ),
                  progressColor: Colors.green,
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Total Distance",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(runTotalDistance.toString()),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularPercentIndicator(
                  radius: 110.0,
                  lineWidth: 10.0,
                  percent: (getPercentMinutes() > 1.0) ? 1.0 : getPercentMinutes(),
                  center: Text(
                    "${(getPercentMinutes()*100).round()}%",
                  ),
                  progressColor: Colors.green,
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Total Time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "${totalRunHour.toString()}:${totalRunMinute.toString()}:${totalRunSecond.toString()}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getPercentMinutes() {

    var totalMinutes = totalRunHour * 60 + totalRunMinute + totalRunSecond/60;

    return totalMinutes/30;

  }


}
