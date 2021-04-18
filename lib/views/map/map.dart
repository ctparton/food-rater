import 'dart:collection';
import 'package:food_rater/models/anim_type.dart';
import 'package:food_rater/views/common/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:food_rater/views/common/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:food_rater/models/food_rating_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A class which builds the Map view tab with a horizontal scrolling list of
/// the reviews that the user has made.
class MapState extends StatefulWidget {
  @override
  _MapStateState createState() => _MapStateState();
}

/// Holds the state of the map including markers
class _MapStateState extends State<MapState> {
  /// initialises the map markers
  Set<Marker> _markers = HashSet<Marker>();

  /// controller to handle the Google map
  GoogleMapController mapController;
  final LatLng _center = const LatLng(54.2321181, -6.4204719);
  String style;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Gets the food ratings and removes any that do not have a location
    final _ratings = Provider.of<List<FoodRating>>(context)
        .where(
            (element) => element.latitude != null && element.longitude != null)
        .toList();

    if (themeProvider.isDarkMode) {
      changeMapStyle();
    } else {
      if (mapController != null) {
        // reset from dark style
        mapController.setMapStyle(null);
      }
    }

    // build stack with the ratings on top of the Google map
    return _ratings != null
        ? Stack(children: [
            GoogleMap(
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController c) async {
                mapController = c;
                if (themeProvider.isDarkMode) {
                  String style = await DefaultAssetBundle.of(context)
                      .loadString("assets/map_style_dark.json");
                  c.setMapStyle(style);
                }
              },
              // add the map markers
              markers: createMarkers(_ratings),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 5.0,
              ),
            ),
            HorizontalReviewList(
                ratings: _ratings, mapController: mapController),
          ])
        : LoadingSpinner(animationType: AnimType.rating);
  }

  /// Returns a set of [Marker] based on the locations in the current
  /// [FoodRating] objects.
  Set<Marker> createMarkers(List<FoodRating> ratings) {
    if (ratings != null) {
      ratings = ratings
          .where((element) =>
              element.latitude != null && element.longitude != null)
          .toList();
      _markers = ratings
          .map(
            (e) => Marker(
              markerId: MarkerId(e.docID),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(title: e.rName, snippet: e.mealName),
            ),
          )
          .toSet();
    }
    return _markers;
  }

  /// Changes the map style to the dark style, if the theme dictates
  void changeMapStyle() async {
    style = await DefaultAssetBundle.of(context)
        .loadString("assets/map_style_dark.json");
    if (mapController != null) {
      mapController.setMapStyle(style);
    }
  }
}

/// A class to create the horizontal list of ratings, that sit on top of the
/// GoogleMap
class HorizontalReviewList extends StatelessWidget {
  const HorizontalReviewList({
    Key key,
    @required List<FoodRating> ratings,
    @required this.mapController,
  })  : _ratings = ratings,
        super(key: key);

  final List<FoodRating> _ratings;

  /// Map controller to allow onTap animation events on ratings
  final GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      // list takes up bottom 20% of the screen
      padding: EdgeInsets.fromLTRB(
          0, MediaQuery.of(context).size.height * 0.80, 0, 32),
      child: ListView.builder(
          itemExtent: 200,
          scrollDirection: Axis.horizontal,
          itemCount: _ratings.length,
          itemBuilder: (context, index) {
            return createHorizontalRatingCard(_ratings[index]);
          }),
    );
  }

  /// Creates the individual ratings card, which can be tapped to zoom the map
  /// to the restaurant
  Widget createHorizontalRatingCard(FoodRating rating) {
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
              rating.rName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${rating.mealName} on ${rating.date}',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // If rating tapped, move Google map to this rating
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(rating.latitude, rating.longitude),
                      zoom: 15.0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
