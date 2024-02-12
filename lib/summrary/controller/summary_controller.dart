import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_application/summrary/model/polyLineModel.dart';

class SummaryController extends GetxController {

  final mPolyLineModel  = PolyLineModel([], '', "", "", "").obs;
  final isLoading = false.obs;
  final mResponseStatus = 0.obs;

  ///* get the date from google api and retrive the prefect path to draw
  Future<void> getPolyLineResult(LatLng startLatLon, LatLng endLatLon) async {
    try {
       isLoading.value = true ;

      String apiKey = 'AIzaSyC6cHedv6lJT1WCNhcpSrZJt3zPAXxEAH0';

      String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startLatLon.latitude},${startLatLon.longitude}&destination=${endLatLon.latitude},${endLatLon.longitude}&key=$apiKey";

      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {

        mResponseStatus.value = 200 ;

        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);
        if (kDebugMode) {
          print("response.statusCode ${data}");
        }

        final List<LatLng> mLatLngPolyPointsLocal = [];
        List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          String encodedPolyline = step['polyline']['points'];
          List<LatLng> decodedPolyline = _decodePolyline(encodedPolyline);
          mLatLngPolyPointsLocal.addAll(decodedPolyline);
        }

          var distanceText = data['routes'][0]['legs'][0]['distance']['text'];
          var distanceValue = data['routes'][0]['legs'][0]['distance']['value'];
          var durationText = data['routes'][0]['legs'][0]['duration']['text'];
          var durationValue = data['routes'][0]['legs'][0]['duration']['value'];

        mPolyLineModel.value.mLatLngPolyPointsLocal = mLatLngPolyPointsLocal ;
        mPolyLineModel.value.mDistanceText = distanceText;
        mPolyLineModel.value.mDistanceValue = distanceValue;
        mPolyLineModel.value.mDurationText =durationText;
        mPolyLineModel.value.mDurationValue =durationValue ;

        // print(response);
        // setState(() {
        //   mLatLngPolyPoints.addAll(mLatLngPolyPointsLocal);
        //   _mapController?.animateCamera(
        //     CameraUpdate.newCameraPosition(
        //       CameraPosition(target: startLatLon, zoom: 16),
        //     ),
        //   );
        // });

        // Future.delayed(const Duration(seconds: 3), () {
        //   setState(() {
        //     _mapController?.animateCamera(
        //       CameraUpdate.newCameraPosition(
        //         CameraPosition(target: startLatLon, zoom: 14),
        //       ),
        //     );
        //   });
        // });

      } else {
          print("Request failed with status: ${response.statusCode}");
      }

    } catch (e) {
      // Handle network error
      print('Error: $e');
    }finally{
      isLoading.value = false;
    }
  }

  /// *
  ///* decode the step from google api result
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    var index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;
      LatLng point = LatLng(latitude, longitude);
      poly.add(point);
    }
    return poly;
  }
}
