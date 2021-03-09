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
    final _ratings = Provider.of<List<FoodRating>>(context)
        .where(
            (element) => element.latitude != null && element.longitude != null)
        .toList();

    return _ratings != null
        ? Stack(children: [
            GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController c) {
                mapController = c;
              },
              markers: createMarkers(_ratings),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 5.0,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(
                  0, MediaQuery.of(context).size.height * 0.80, 0, 32),
              child: ListView.builder(
                  itemExtent: 200,
                  scrollDirection: Axis.horizontal,
                  itemCount: _ratings.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text(
                              _ratings[index].rName,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                                '${_ratings[index].mealName} on ${_ratings[index].date}',
                                style: TextStyle(color: Colors.white)),
                            onTap: () {
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(CameraPosition(
                                      target: LatLng(_ratings[index].latitude,
                                          _ratings[index].longitude),
                                      zoom: 15.0)));
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ])
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
