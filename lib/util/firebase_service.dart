import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebaseService {
  static final CollectionReference<Map<String, dynamic>> instance =
      FirebaseFirestore.instance.collection('allSongs');
  static bool enabledWifi = false;
  static bool isAlert = true;
}
