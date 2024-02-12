import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_application/startLocation/model/start_location_model.dart';

import '../model/end_location_model.dart';

class EndLocationController extends GetxController {

  final _mEndLocationLatLon  =EndLocationModel("", const LatLng(0.0, 0.0)).obs;

  void setUserStartLocation  (EndLocationModel mEndLocationModel) =>
      _mEndLocationLatLon.value = mEndLocationModel ;

  Rx<EndLocationModel> getEndUserLocation () => _mEndLocationLatLon ;

}