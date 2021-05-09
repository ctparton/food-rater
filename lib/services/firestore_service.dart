import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_rater/services/recipe_service.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:opencage_geocoder/opencage_geocoder.dart';
import "package:google_maps_webservice/geocoding.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class to handle all interactions with FireStore.
///
/// This class currently handles upload and retrieval of the food ratings.
class FirestoreServce {
  final String uid;

  /// Instance of the recipe service to get cuisine information
  final RecipeService recipeService = RecipeService();

  /// Instance of the firestore users collection for uploading ratings to a user
  /// collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  FirestoreServce({this.uid});

  /// Returns a [Future] after uploading a food rating to Firestore.
  ///
  /// This method also calls helper methods to upload an image if available,
  /// and get location data in [double] coordinates of the rating
  Future addRating(rName, rLocation, placeID, mealName, date, rating,
      [image, comments]) async {
    String comment = comments ?? '';
    String imageUrl;
    dynamic cuisine;
    dynamic result;
    double lat;
    double lng;

    // Attempt to get the type of cuisine of the meal
    try {
      cuisine = await recipeService.getCuisine(mealName);
    } catch (err) {
      cuisine = null;
    }

    // if there has been an image uploaded
    if (image != null) {
      imageUrl = await uploadFile(image);
    }

    // Attempt to get the location
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

  /// Returns a [Future<String>] of the cloud firebase storage location of the
  /// uploaded file if the upload is successful, else returns null.
  Future<String> uploadFile(File _image) async {
    String returnURL;
    bool fileExists = await _image.exists();
    if (fileExists) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('meals/${p.basename(_image.path)}');
      // Create the task for uploading the file
      UploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.whenComplete(() => print('File Uploaded'));

      // Gets the URL of the uploaded image
      await storageReference.getDownloadURL().then((fileURL) {
        returnURL = fileURL;
      });
    }

    return returnURL;
  }

  /// Returns a [Future] with the updated [FoodRating] or an error.
  Future updateRating(FoodRating foodRating) async {
    return await userCollection
        .doc(uid)
        .collection("ratings")
        .doc(foodRating.docID)
        .update({'rating': foodRating.rating, 'comments': foodRating.comments});
  }

  /// Returns a [Future] with the deleted [FoodRating] or an error
  Future deleteRating(FoodRating foodRating) async {
    return await userCollection
        .doc(uid)
        .collection("ratings")
        .doc(foodRating.docID)
        .delete();
  }

  /// Retrieves the location data from a [String] location in the form
  /// "Restaurant Name, Location" or a [String] google Places ID.
  ///
  /// Returns a [Map] of lat, lng strings to the actual location data if
  /// successful
  Future<Map<String, double>> getLocationData(
      String rLocation, String placeID) async {
    var locationMap = new Map<String, double>();
    if (placeID != null) {
      // If we have a google places ID
      final geocoding = new GoogleMapsGeocoding(apiKey: env['G_KEY']);
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
      // If there is not a placeID associated with the FoodRating
      final geocoder = new Geocoder(env['GEO']);
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

  /// Returns a list of [FoodRating] objects with each document in a snapshot
  /// from firestore getting mapped to a [FoodRating] object
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

  /// Returns a stream of [FoodRating] if any new changes (e.g. CRUD operations)
  /// to the ratings collection are made
  Stream<List<FoodRating>> get ratings {
    var ref = userCollection.doc(uid).collection("ratings");
    return ref.snapshots().map(_foodRatingFromSnapshot);
  }
}
