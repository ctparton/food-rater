import 'dart:collection';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapState extends StatefulWidget {
  @override
  _MapStateState createState() => _MapStateState();
}

class _MapStateState extends State<MapState> {
  Set<Marker> _markers = HashSet<Marker>();
  GoogleMapController mapController;
  final LatLng _center = const LatLng(54.2321181, -6.4204719);

  @override
  Widget build(BuildContext context) {
    final _ratings = Provider.of<List<FoodRating>>(context);
    return _ratings != null
        ? GoogleMap(
            onMapCreated: (GoogleMapController c) {
              mapController = c;
            },
            markers: createMarkers(_ratings),
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 5.0,
            ),
          )
        : LoadingSpinner();
  }

  Set<Marker> createMarkers(List<FoodRating> ratings) {
    if (ratings != null) {
      ratings = ratings
          .where((element) =>
              element.latitude != null && element.longitude != null)
          .toList();
      _markers = ratings
          .map((e) => Marker(
              markerId: MarkerId(e.docID),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(title: e.rName, snippet: e.mealName)))
          .toSet();
    }
    return _markers;
  }
}
