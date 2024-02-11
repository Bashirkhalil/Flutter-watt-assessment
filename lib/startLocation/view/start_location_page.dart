import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StartLocationPage extends StatefulWidget {
  const StartLocationPage({super.key});

  @override
  State<StartLocationPage> createState() => _StartLocationPageState();
}

class _StartLocationPageState extends State<StartLocationPage> {
  late GoogleMapController mMapController;
  LatLng? mUserMapLocation;
  Placemark? mPlaceMark;
  String mLocationAddress = "";
  bool isFirstLaunch = true;
  bool isLookingForAddress = false;

  double defaultZoom = 13;
  final LatLng _center = const LatLng(37.7749, -122.4194); // Default center
  final Set<Marker> _markers = {}; // Markers on the map

  static double minZoom = 10;
  static double maxZoom = 17;

  @override
  void initState() {
    super.initState();

    iniGetUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
        ),
        body: Stack(
          children: [
            buildGoogleMapWidget(),
            buildMapMarker(),
            buildShowStartLocationButton()
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) =>
      mMapController = controller;

  void iniGetUserLocation() async {
    var permission = await Geolocator.checkPermission();
    print('isLocationPermission Granted?');
    print(permission != LocationPermission.denied);

    if (permission != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      updateLastUserLocation(position);

      animateToUserLocation(position);
    } else {
      var permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      } else {
        iniGetUserLocation();
      }
    }
  }

  void updateLastUserLocation(Position position) {
    setState(() {
      mUserMapLocation = LatLng(position!.latitude, position!.longitude);
    });
  }

  void initSetMapStyle(GoogleMapController controller) async {
    var mMapStyle = await rootBundle.loadString('assets/map_style/grey.json');
    controller!.setMapStyle(mMapStyle);
  }

  void animateToUserLocation(Position position) {
    if (mMapController != null) {
      mMapController!.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(position!.latitude, position!.longitude), defaultZoom));
    }
  }

  Widget buildGoogleMapWidget() {
    return GoogleMap(
      myLocationButtonEnabled: false,
      // compassEnabled: true,
      // mapToolbarEnabled: false,
      myLocationEnabled: true,
      // zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      minMaxZoomPreference: MinMaxZoomPreference(minZoom, maxZoom),
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 10.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        // onMapCreated change the exist style
        _onMapCreated(controller);

        // onMapCreated change the exist style
        initSetMapStyle(controller);
      },
      onCameraIdle: () {
        print("Hello testing");
        if (mUserMapLocation != null && !isFirstLaunch) {

          // indicate the user is touch the screen so we will show the progress
          updateIsLookingForAddress(false);

          getLocationAddress(mUserMapLocation!);

        }
      },
      onCameraMoveStarted: () {
        print("Hello testing 12");
        if (isFirstLaunch) {
          isFirstLaunch = false;
        }
      },
      // onCameraMove:(CameraPosition position) => mUserMapLocation = position.target ,
      onCameraMove: (CameraPosition position) {
        print("Hello testing 3");
        updateIsLookingForAddress(true);
        mUserMapLocation = position.target;
      },
      markers: _markers,
    );
  }

  Widget buildMapMarker() {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/svg/Location.svg",
                color: Colors.black,
                width: 36,
                height: 36,
                matchTextDirection: true,
              ),

              //  Image.asset("assets/images/location_b.png",),
              //  Container(color: Colors.black, height: 42),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCircleLoaderIndicator() => const Center(
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            )),
      );

  Widget buildShowStartLocationButton() {
    return mLocationAddress.isNotEmpty
        ? Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeInUp(
              child: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15)),
                    color: Colors.white),
                child: Column(
                  children: [

                    Visibility(
                      visible: !isLookingForAddress,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Current Location",
                              // style: blackBodyText14,
                            )
                          ],
                        ),
                      ),
                    ),

                    const Visibility(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),

                    Visibility(
                        visible: isLookingForAddress,
                        child: buildWidgetLookingForAddress()),

                    const SizedBox(
                      height: 10,
                    ),

                    Visibility(
                        visible: !isLookingForAddress,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          //const EdgeInsets.only(left: 16,right: 16 ,top: 8,bottom: 16),
                          child: Text(
                            mLocationAddress,
                            //  style: blackBodyText14,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )),

                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            goToDestinationPage();
                          },
                          child: Text('PickUp my Location '),
                          style:
                              ElevatedButton.styleFrom(shape: StadiumBorder()),
                        )),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  void getLocationAddress(LatLng mUserMapLocation) async {
    try {
      mLocationAddress = "";
      mPlaceMark = null;
      if (mUserMapLocation != null) {
        List<Placemark> mPlaceMarks = await placemarkFromCoordinates(
            mUserMapLocation!.latitude, mUserMapLocation!.longitude,
            localeIdentifier: 'en_US');

        //log("ADDress: ${placemarks[0].name}, ${placemarks[0].street}, ${placemarks[0].administrativeArea}, ${placemarks[0].postalCode}");
        setState(() {
          mLocationAddress = mPlaceMarks[0].name ?? "";
          mLocationAddress += mPlaceMarks[0].street != null
              ? ", " + mPlaceMarks[0].street!
              : "";
          mLocationAddress += mPlaceMarks[0].administrativeArea != null
              ? ", ${mPlaceMarks[0].administrativeArea!}"
              : "";
          mLocationAddress += mPlaceMarks[0].postalCode != null &&
                  mPlaceMarks[0].postalCode!.isNotEmpty
              ? ", ${mPlaceMarks[0].postalCode!}"
              : "";
          mPlaceMark = mPlaceMarks[0];

          print("mLocationAddress = ${mLocationAddress}");
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void goToDestinationPage() {}

  Widget buildWidgetLookingForAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          buildCircleLoaderIndicator(),
          const SizedBox(
            width: 15,
          ),
          Text(
            "Looking for Address Name ...",
          )
        ],
      ),
    );
  }

  void updateIsLookingForAddress(bool isLookingForAddressValue) {
   setState(() {
     isLookingForAddress = isLookingForAddressValue;
   });
  }
}
