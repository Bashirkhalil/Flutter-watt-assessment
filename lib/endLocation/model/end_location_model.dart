

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_application/startLocation/view/start_location_page.dart';

class EndLocationModel {
  final String endLocationName ;
  final LatLng endLocationLanLon ;

  EndLocationModel(this.endLocationName, this.endLocationLanLon);
}