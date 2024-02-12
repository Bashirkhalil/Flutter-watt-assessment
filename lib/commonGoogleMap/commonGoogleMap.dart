import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CommonGoogleMap extends StatelessWidget {

  CommonGoogleMap(
      {this.myLocationButtonEnabled = true,
      this.compassEnabled = true ,
      this.mapToolbarEnabled = false,
      this.myLocationEnabled = true,
      this.zoomControlsEnabled = false ,
      this.rotateGesturesEnabled = false,
      this.mapType = MapType.normal ,
      this.mLatLngPolyPoints ,
      this.markers,
      required this.onMapCreate,
      required this.onCameraIdle,
      required this.onCameraMoveStarted,
      required this.onCameraMove,
      required this.onMapLoading,
      super.key});

  Function(GoogleMapController controller) onMapCreate;
  Function(CameraPosition position) onCameraMove;
  Function (bool) onMapLoading;
  Function onCameraMoveStarted;
  Function onCameraIdle;

  final bool myLocationButtonEnabled ;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final bool myLocationEnabled;
  final bool zoomControlsEnabled;
  final bool rotateGesturesEnabled;
  final MapType mapType;
  final List<LatLng>? mLatLngPolyPoints;
  final Set<Marker>? markers  ; // Markers on the map

  final LatLng _center = const LatLng(37.7749, -122.4194); // Default center
  static double minZoom = 10;
  static double maxZoom = 17;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      polylines: const <Polyline>{} ,//getPolyLine(context),
      myLocationButtonEnabled: myLocationButtonEnabled,
      compassEnabled: compassEnabled,
      mapToolbarEnabled: mapToolbarEnabled,
      myLocationEnabled: myLocationEnabled,
      zoomControlsEnabled: zoomControlsEnabled,
      rotateGesturesEnabled: rotateGesturesEnabled,
      minMaxZoomPreference: MinMaxZoomPreference(minZoom, maxZoom),
      mapType: mapType,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        onMapCreate(controller);
      },
      onCameraIdle: () {
        onCameraIdle();
      },
      onCameraMoveStarted: () {
        onCameraMoveStarted();
      },
      onCameraMove: (CameraPosition position) {
        onCameraMove(position);
        onMapLoading(false);
      },
      markers: markers ?? {},
    );
  }

  getPolyLine(BuildContext context) {
    if(mLatLngPolyPoints!=null) {
     return Polyline(
        polylineId: const PolylineId('route'),
        color: Theme.of(context).primaryColor,
        width: 5,
        points: mLatLngPolyPoints!,
      );
  }else {
     return const <Polyline>{};
    }
  }

}
