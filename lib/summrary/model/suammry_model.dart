

import 'package:google_maps_flutter/google_maps_flutter.dart';

class SummaryModel {
  final String startLocationName ;
  final LatLng startLocation ;
  final LatLng destinationLocation;
  final String destinationLocationName ;
  final String distanceValue;

  SummaryModel(
      this.startLocationName,
      this.startLocation,
      this.destinationLocation,
      this.destinationLocationName,
      this.distanceValue);


}


