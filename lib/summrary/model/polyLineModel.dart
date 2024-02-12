

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineModel {

  List<LatLng> mLatLngPolyPointsLocal ;
  var mDistanceText ;
  var mDistanceValue ;
  var mDurationText ;
  var mDurationValue ;

  PolyLineModel(this.mLatLngPolyPointsLocal, this.mDistanceText,
      this.mDistanceValue, this.mDurationText, this.mDurationValue);
}