import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {

  final FirebaseFirestore fireStore;

  StoreService({required this.fireStore});

  Future<String?> createEmptyTracker(String userId) {
    return fireStore.collection(userId).add({
      "track_name": null,
      "track_date": null,
      "track": null,
      "track_time": null,
      "track_distance": null,
      "track_avg_speed": null,
    })
    .then((value) => value.id)
    .catchError((onError) {
      print(onError);
    });
  }

  Future<String?> updateTracker(String key,dynamic val,String userId, String docId) {
    return fireStore.collection(userId).doc(docId).update({
      key: val,
    })
    .then((value) => "Success")
    .catchError((onError) {
      print(onError);
    });
  }

  Future<String?> deleteTracker(String userId, String docId) {
    return fireStore.collection(userId).doc(docId).delete()
      .then((val) => "Success")
      .catchError((onError) {
        print(onError);
    });
  }

  Stream<DocumentSnapshot> getTracker(String userId, String docId) {
    return fireStore.collection(userId).doc(docId).snapshots();
  }

  Stream<QuerySnapshot> getTracks(String userId) {
    return fireStore.collection(userId).orderBy("track_date",descending: true).snapshots();
  }


  // Todo: getting the wopping track that only did today
  Stream<QuerySnapshot> getTodayTracks(String userId) {
    var today = DateTime.now();
    var onlyDateTime = DateTime(today.year,today.month,today.day,);
    var onlyDateNight = DateTime(today.year,today.month,today.day,24,60,60);
    var todayMorningTimeStamp = Timestamp.fromDate(onlyDateTime);
    var todayNightTimeStamp = Timestamp.fromDate(onlyDateNight);
    return fireStore.collection(userId)
        .orderBy("track_date",descending: true)
        .where("track_date",isGreaterThan: todayMorningTimeStamp,isLessThan: todayNightTimeStamp)
        .snapshots();
  }
}