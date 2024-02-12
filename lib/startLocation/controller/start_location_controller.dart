import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_application/startLocation/model/start_location_model.dart';

class StartLocationController extends GetxController {

  final _mStartUserLocationLatLon  = StartLocationModel("", const LatLng(0.0, 0.0)).obs;

  void setUserStartLocation  (StartLocationModel mStartLocationModel) =>
  _mStartUserLocationLatLon.value = mStartLocationModel ;

  Rx<StartLocationModel> getStartUserLocation () => _mStartUserLocationLatLon ;

}