import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getMaxID() async {
  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Get a reference to the Firestore database
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query the collection and order documents by ID in descending order
    QuerySnapshot querySnapshot = await firestore
        .collection('songCategoris')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    // Check if any documents were found
    if (querySnapshot.size > 0) {
      // Get the document data and return the value of the 'id' field
      return querySnapshot.docs.first['id'];
    } else {
      // No documents found
      return null;
    }
  } catch (error) {
    print('Error getting max ID: $error');
    return null;
  }
}

void main() async {
  String? maxID = await getMaxID();
  if (maxID != null) {
    print('Max ID: $maxID');
  } else {
    print('No documents found.');
  }
}
