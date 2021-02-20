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

  Future addRating(rName, rCity, mealName, date, rating,
      [image, comments]) async {
    String comment = comments ?? '';
    String imageUrl;
    // try {
    //   print(date.toString());
    //   // DateTime.parse();
    // } catch (FormatException) {
    //   return Future.error("Date is invalid");
    // }
    if (image != null) {
      imageUrl = await uploadFile(image);
    }
    return await userCollection.doc(uid).collection("ratings").add({
      'rName': rName,
      'rCity': rCity,
      'mealName': mealName,
      'date': date,
      'rating': rating,
      'image': imageUrl,
      'comments': comment
    });
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
            mealName: doc.data()['mealName'],
            date: doc.data()['date'],
            rating: doc.data()['rating'] ?? 1,
            image: doc.data()['image'],
            comments: doc.data()['comments']))
        .toList();
  }

  Stream<List<FoodRating>> get ratings {
    var ref = userCollection.doc(uid).collection("ratings");
    return ref.snapshots().map(_foodRatingFromSnapshot);
  }
}
