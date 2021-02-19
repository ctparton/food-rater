import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class FirestoreServce {
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  FirestoreServce({this.uid});

  Future addRating(rName, rCity, rating, image) async {
    String imageUrl;
    if (image != null) {
      imageUrl = await uploadFile(image);
    }
    return await userCollection.doc(uid).collection("ratings").add(
        {'rName': rName, 'rCity': rCity, 'rating': rating, 'image': imageUrl});
  }

  Future<String> uploadFile(File _image) async {
    String returnURL;
    bool fileExists = await _image.exists();
    if (fileExists) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('meals/${p.basename(_image.path)}');
      UploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.whenComplete(() => print('File Uploaded'));

      await storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
    }

    return returnURL;
  }

  List<FoodRating> _foodRatingFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => FoodRating(
            rName: doc.data()['rName'] ?? '',
            rCity: doc.data()['rCity'] ?? '',
            rating: doc.data()['rating'] ?? 1,
            image: doc.data()['image']))
        .toList();
  }

  Stream<List<FoodRating>> get ratings {
    var ref = userCollection.doc(uid).collection("ratings");
    return ref.snapshots().map(_foodRatingFromSnapshot);
  }
}
