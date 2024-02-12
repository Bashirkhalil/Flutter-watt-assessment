

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_application/startLocation/view/start_location_page.dart';

class StartLocationModel {
  final String startLocationName ;
  final LatLng startLocationLatLon ;

  StartLocationModel(this.startLocationName, this.startLocationLatLon);
}