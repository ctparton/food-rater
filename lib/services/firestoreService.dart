import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServce {
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  FirestoreServce({this.uid});

  Future addRating(rName, rCity) async {
    return await userCollection
        .doc(uid)
        .collection("ratings")
        .add({'rName': rName + " id: " + uid, 'rCity': rCity + " id: " + uid});
  }

  Stream<QuerySnapshot> get ratings {
    return userCollection.doc(uid).collection("ratings").snapshots();
  }
  // Stream getRatings() {

  // }
}
