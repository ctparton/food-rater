import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_rater/models/foodrating.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:opencage_geocoder/opencage_geocoder.dart';
import "package:google_maps_webservice/geocoding.dart";

class FirestoreServce {
  final String uid;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  FirestoreServce({this.uid});

  Future addRating(rName, rLocation, placeID, mealName, date, rating,
      [image, comments, cuisine]) async {
    String comment = comments ?? '';
    String imageUrl;
    dynamic result;
    double lat;
    double lng;

    if (image != null) {
      imageUrl = await uploadFile(image);
    }
    try {
      result = await getLocationData(rLocation, placeID);
      if (result != null) {
        lat = result['lat'];
        lng = result['lng'];
      }
    } catch (Exception) {
      print("failed to get location data ${Exception.toString()}");
    }

    DocumentReference doc = userCollection.doc(uid).collection("ratings").doc();

    return await doc.set({
      'rName': rName,
      'rLocation': rLocation,
      'mealName': mealName,
      'date': date,
      'rating': rating,
      'image': imageUrl,
      'comments': comment,
      'latitude': lat != null ? lat : null,
      'longitude': lng != null ? lng : null,
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

  Future<Map<String, double>> getLocationData(
      String rLocation, String placeID) async {
    var locationMap = new Map<String, double>();
    if (placeID != null) {
      print("geocoding using google");
      final geocoding = new GoogleMapsGeocoding(
          apiKey: "AIzaSyCS-Wk6uzVAnR7AW4U-WdLk2oaUjkFhilU");
      GeocodingResponse response = await geocoding.searchByPlaceId(placeID);
      if (response.isOkay) {
        Location location = response.results.first.geometry.location;
        locationMap['lat'] = location.lat;
        locationMap['lng'] = location.lng;
        return locationMap;
      } else {
        throw Exception("Could not get location data");
      }
    } else {
      print("geocoding using opengeocoder");
      final geocoder = new Geocoder("c2ef3364e065450098b524f349d373b0");
      GeocoderResponse response = await geocoder.geocode(rLocation);
      if (response != null) {
        Coordinates location = response.results.first.geometry;
        locationMap['lat'] = location.latitude;
        locationMap['lng'] = location.longitude;
        return locationMap;
      } else {
        throw Exception("Could not get location data");
      }
    }
  }

  List<FoodRating> _foodRatingFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => FoodRating(
            rName: doc.data()['rName'] ?? '',
            rLocation: doc.data()['rLocation'] ?? '',
            mealName: doc.data()['mealName'],
            date: doc.data()['date'],
            rating: doc.data()['rating'] ?? 1,
            image: doc.data()['image'],
            comments: doc.data()['comments'],
            docID: doc.data()['docID'],
            cuisine: doc.data()['cuisine'],
            latitude: doc.data()['latitude'],
            longitude: doc.data()['longitude']))
        .toList();
  }

  Stream<List<FoodRating>> get ratings {
    var ref = userCollection.doc(uid).collection("ratings");
    return ref.snapshots().map(_foodRatingFromSnapshot);
  }
}
