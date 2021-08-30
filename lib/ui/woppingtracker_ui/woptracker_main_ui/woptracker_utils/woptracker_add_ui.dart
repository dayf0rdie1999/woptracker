import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';
import 'package:woptracker/services/store/store_service.dart';
import 'package:woptracker/ui/woppingtracker_ui/google_map_ui/googlemapwrapperui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils/woptracker_add_ui_utils/custom_dropdownmenu_button.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils_ui/datetime_picker_ui.dart';
import 'package:woptracker/ui/woppingtracker_ui/woptracker_main_ui/woptracker_utils_ui/header_title_ui.dart';

class WopTrackerAddUI extends StatefulWidget {

  final String docId;
  final String userId;
  final Map<String,dynamic> data;
  final bool editMode;

  const WopTrackerAddUI({Key? key, required this.docId, required this.userId, required this.data, required this.editMode}) : super(key: key);

  @override
  _WopTrackerAddUIState createState() => _WopTrackerAddUIState();
}

class _WopTrackerAddUIState extends State<WopTrackerAddUI> {

  final _addWopTrackerKey = GlobalKey<FormState>();

  // Todo: Adding controller to TextFormField
  final _trackNameController = TextEditingController();
  final _trackDistanceController = TextEditingController();
  final _trackAverageSpeedController = TextEditingController();

  // Todo: creating a date time object
  DateTime selectedDate = DateTime.now();

  // Todo: Creating an firestore system
  final StoreService _storeService = StoreService(fireStore: FirebaseFirestore.instance);

  // Todo: Creating a snackbar
  final snackBar = SnackBar(content: Text("Can't Update data to the server"),);

  final ScrollController _scrollController = ScrollController();

  bool _isScrolled = false;

  // Todo: Creating var to store running time
  int _trackHours = 0;
  int _trackMinutes = 0;
  int _trackSeconds = 0;

  // Todo: Average Running Speed (meters per hour)
  double avgRunSpeed = 12874.7;

  bool _showTrackDetail = false;

  double? googleMapApproximatedDistance;



  // Todo:
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode:  DatePickerEntryMode.input,
    );
    if (picked != null && picked != selectedDate) {
      String? result = await _storeService.updateTracker("track_date", picked, widget.userId, widget.docId);

      if(result != null) {
        setState(() {
          selectedDate = picked;
        });
      } else {
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    _getTrack();
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

  void _getTrack() async {
    if (widget.data["track_name"] != null) {
      _trackNameController.text = widget.data["track_name"]!;
    }

    if (widget.data["track_date"] != null) {
      selectedDate = DateTime.fromMicrosecondsSinceEpoch(widget.data["track_date"].microsecondsSinceEpoch);
    } else {

      String? result = await _storeService.updateTracker("track_date", DateTime.now(), widget.userId, widget.docId);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    if (widget.data["track"] != null) {
      setState(() {
        _showTrackDetail = true;
      });

      // Todo: Calculating the GreatCircleDistance
      var gcd = GreatCircleDistance.fromDegrees(latitude1: widget.data["track"]!['origin'][0],longitude1: widget.data["track"]!['origin'][1],latitude2: widget.data["track"]!['destination'][0],longitude2: widget.data["track"]!['destination'][1]);


      // Todo: Calculating the amount of time need to travel with average speed
      calWopTime(gcd.haversineDistance());
    }
  }

  void calWopTime(double distance) async {
    googleMapApproximatedDistance = distance;

    // Todo: giving average running speed
    var wopTime = distance/avgRunSpeed;

    var wopTimeHour = wopTime.toInt();
    wopTime = wopTime - wopTimeHour;
    var wopTimeMinutes = (wopTime*60).toInt();
    wopTime = (wopTime*60)- wopTimeMinutes;
    var wopTimeSeconds = (wopTime*60).toInt();

    Map<String,int> trackMapTime = {'Hours': wopTimeHour, 'Minutes': wopTimeMinutes,'Seconds': wopTimeSeconds};

    String? result = await _storeService.updateTracker("track_time", trackMapTime, widget.userId, widget.docId);
    String? resultDistance = await _storeService.updateTracker("track_distance", distance.toInt().toString(), widget.userId, widget.docId);
    String? resultAvgSpeed = await _storeService.updateTracker("track_avg_speed", avgRunSpeed.toString(), widget.userId, widget.docId);

    if (result == null || resultDistance == null || resultAvgSpeed == null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      _trackAverageSpeedController.text = avgRunSpeed.toString();
      _trackDistanceController.text = distance.toInt().toString();
      _trackHours = wopTimeHour;
      _trackMinutes = wopTimeMinutes;
      _trackSeconds = wopTimeSeconds;
    });

  }

  @override
  Widget build(BuildContext context) {

    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Track"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              if (widget.editMode == false) {
                String? result = await _storeService.deleteTracker(widget.userId, widget.docId);

                if (result != null) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              } else {
                Navigator.pop(context);
              }

            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Form(
              key: _addWopTrackerKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: SectionHeader(headerTitle: "Title",),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: TextFormField(
                      controller: _trackNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelText: "Enter Track Name *",
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Input Required";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) async {
                        if(_addWopTrackerKey.currentState!.validate()) {
                          String? result = await _storeService.updateTracker("track_name", _trackNameController.text, widget.userId, widget.docId);

                          if (result == "Success") {
                            return null;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: SectionHeader(headerTitle: "Track Date",),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: WopTrackerDatePicker(
                      selectedDate: selectedDate,
                      updateSelectedDate: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: SectionHeader(headerTitle: "Wopping Track",),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: Container(
                      height: 200.0,
                      child: Stack(
                        children: <Widget>[
                          GoogleMapWrapperUI(userId: widget.userId, docId: widget.docId,data: widget.data, showFullScreen: false,editMode: widget.editMode,),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => GoogleMapWrapperUI(userId: widget.userId, docId: widget.docId, data: widget.data,showFullScreen: true,editMode: widget.editMode,)),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (_showTrackDetail) ? Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: SectionHeader(headerTitle: "Track Detail",),
                  ) : Container(color: Colors.transparent,),

                  // Todo: Adding Track_Distance
                  (_showTrackDetail) ? Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _trackDistanceController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              labelText: "Enter Track Distance (meters) *",
                            ),
                            onChanged: (val) async {

                              if (_trackDistanceController.text.isNotEmpty) {
                                String? result = await _storeService.updateTracker("track_distance",_trackDistanceController.text, widget.userId, widget.docId);

                                if (result == "Success") {
                                  return null;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }

                            },
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: IconButton(onPressed: () {
                            if(googleMapApproximatedDistance != null) {
                              _trackDistanceController.text = googleMapApproximatedDistance!.toInt().toString();
                            }
                          }, icon: Icon(Icons.refresh)),
                        ),
                      ],
                    )
                  ): Container(color: Colors.transparent,),

                  // Todo: Adding Track_Running Speed
                  (_showTrackDetail) ? Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _trackAverageSpeedController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              labelText: "Enter Track Average Speed (meters/hour) *",
                            ),
                            onChanged: (val) async {

                              if (_trackAverageSpeedController.text.isNotEmpty) {
                                String? result = await _storeService.updateTracker("track_avg_speed",_trackAverageSpeedController.text, widget.userId, widget.docId);

                                if (result == "Success") {
                                  return null;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }

                            },
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: IconButton(onPressed: () {
                            _trackAverageSpeedController.text = avgRunSpeed.toString();
                          }, icon: Icon(Icons.refresh)),
                        ),
                      ],
                    )

                  ): Container(color: Colors.transparent,),

                  // Todo: Adding Track_Running Time
                  (_showTrackDetail) ? Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Hours"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CustomDropDownMenuButton(dropDownValue: _trackHours,listGeneratedValue: 25,updateDropDownValue: (newValue) async {

                            Map<String,int> trackMapTime = {'Hours': newValue, 'Minutes': _trackMinutes,'Seconds': _trackSeconds};

                            String? result = await _storeService.updateTracker("track_time", trackMapTime, widget.userId, widget.docId);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
                              setState(() {
                                _trackHours = newValue;
                              });
                            }

                          },),
                        ),
                        SizedBox(width: 8.0,),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Minutes"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CustomDropDownMenuButton(dropDownValue: _trackMinutes,listGeneratedValue: 61,updateDropDownValue: (newValue) async {

                            Map<String,int> trackMapTime = {'Hours': _trackHours, 'Minutes': newValue,'Seconds': _trackSeconds};

                            String? result = await _storeService.updateTracker("track_time", trackMapTime, widget.userId, widget.docId);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
                              setState(() {
                                _trackMinutes = newValue;
                              });
                            }
                          },),
                        ),
                        SizedBox(width: 8.0,),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text("Seconds"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: CustomDropDownMenuButton(dropDownValue: _trackSeconds,listGeneratedValue: 61,updateDropDownValue: (newValue) async {

                            Map<String,int> trackMapTime = {'Hours': _trackHours, 'Minutes': _trackMinutes,'Seconds': newValue};

                            String? result = await _storeService.updateTracker("track_time", trackMapTime, widget.userId, widget.docId);

                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
                              setState(() {
                                _trackSeconds = newValue;
                              });
                            }

                          },),
                        ),
                      ],
                    ),
                  ): Container(color: Colors.transparent,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (){
                              if (widget.data["track_name"] != null && widget.data["track_date"] != null && widget.data["track"] != null) {
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Missing required inputs")));
                              }
                            },
                            child: Text("Submit"),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: (_isScrolled) ? FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          onPressed: () {
            setState(() {
              _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(milliseconds: 5), curve: Curves.linear);
            });
          },
        ): null,
      ),
    );
  }
}





