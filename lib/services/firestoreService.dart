import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:opencage_geocoder/opencage_geocoder.dart';

class FirestoreServce {
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  FirestoreServce({this.uid});

  Future addRating(rName, rCity, mealName, date, rating,
      [image, comments, cuisine]) async {
    String comment = comments ?? '';
    String imageUrl;
    dynamic result;
    Coordinates coordinates;

    if (image != null) {
      imageUrl = await uploadFile(image);
    }
    try {
      result = await getLocationData(rName, rCity);
      if (result != null) {
        Result strongestMatch = result.results.first;
        coordinates = strongestMatch.geometry;
      }
    } catch (Exception) {
      print("failed to get location data");
    }

    DocumentReference doc = userCollection.doc(uid).collection("ratings").doc();

    return await doc.set({
      'rName': rName,
      'rCity': rCity,
      'mealName': mealName,
      'date': date,
      'rating': rating,
      'image': imageUrl,
      'comments': comment,
      'latitude': coordinates != null ? coordinates?.latitude : null,
      'longitude': coordinates != null ? coordinates?.longitude : null,
      'docID': doc.id,
      'cuisine': cuisine
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

  Future updateRating(FoodRating foodRating) async {
    return await userCollection
        .doc(uid)
        .collection("ratings")
        .doc(foodRating.docID)
        .update({'rating': foodRating.rating});
  }

  Future deleteRating(FoodRating foodRating) async {
    return await userCollection
        .doc(uid)
        .collection("ratings")
        .doc(foodRating.docID)
        .delete();
  }

  Future<GeocoderResponse> getLocationData(rName, city) async {
    final geocoder = new Geocoder("c2ef3364e065450098b524f349d373b0");
    return await geocoder.geocode("$rName $city");
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
            comments: doc.data()['comments'],
            docID: doc.data()['docID'],
            cuisine: doc.data()['cuisine']))
        .toList();
  }

  Stream<List<FoodRating>> get ratings {
    var ref = userCollection.doc(uid).collection("ratings");
    return ref.snapshots().map(_foodRatingFromSnapshot);
  }
}
