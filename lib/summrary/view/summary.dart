import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_application/endLocation/model/end_location_model.dart';

import '../../commonGoogleMap/commonGoogleMap.dart';
import '../../endLocation/controller/destination_location_controller.dart';
import '../../startLocation/controller/start_location_controller.dart';
import '../../startLocation/model/start_location_model.dart';
import '../../utilis/Utilis.dart';
import '../controller/summary_controller.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPage();
}

class _SummaryPage extends State<SummaryPage> {
  GoogleMapController? mMapController;
  LatLng? mUserMapLocation;
  Placemark? mPlaceMark;
  String mLocationAddress = "";
  bool isFirstLaunch = true;
  bool isLookingForAddress = false;

  double defaultZoom = 13;
  final List<LatLng> mLatLngPolyPoints =
      []; // For holding Co-ordinates as LatLng
  final Set<Marker> markersPint = {};

  final EndLocationController mEndLocationController = Get.find();
  final StartLocationController mStartLocationController = Get.find();
  late StartLocationModel mStartLocation;

  late EndLocationModel mEndLocation;

  final SummaryController mSummaryController = Get.put(SummaryController());

  @override
  void initState() {
    super.initState();

    mStartLocation = mStartLocationController.getStartUserLocation().value;
    mEndLocation = mEndLocationController.getEndUserLocation().value;

    iniGetUserLocation();

    mSummaryController.getPolyLineResult(
        mStartLocation.startLocationLatLon, mEndLocation.endLocationLanLon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('The Calculation Result'),
        ),
        body: Stack(
          children: [
            buildGoogleMapWidget(),
            buildShowStartLocationButton(),
          ],
        ));
  }

  Widget buildGoogleMapWidget() {
    return CommonGoogleMap(
        mLatLngPolyPoints: mLatLngPolyPoints,
        markers: markersPint,
        onMapLoading: (status) {},
        onMapCreate: (controller) {
          print("Hello onMapCreate");

          // onMapCreated change the exist style
          _onMapCreated(controller);

          // onMapCreated change the exist style
          initSetMapStyle(controller);

          addTheTowPointMarker();

          drawLine();
        },
        onCameraIdle: () {
          print("Hello onCameraIdle");
          if (mUserMapLocation != null && !isFirstLaunch) {
            // indicate the user is touch the screen so we will show the progress
            updateIsLookingForAddress(false);

            getLocationAddress(mUserMapLocation!);
          }
        },
        onCameraMoveStarted: () {
          print("Hello onCameraMoveStarted 12");
          if (isFirstLaunch) {
            isFirstLaunch = false;
          }
        },
        onCameraMove: (position) {
          print("Hello onCameraMove 3");
          updateIsLookingForAddress(true);
          mUserMapLocation = position.target;
        });
  }

  Widget buildOverTheMapMyLocationButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
          alignment: Alignment.topRight,
          child: Column(
            children: [
              RawMaterialButton(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                fillColor: Colors.white,
                onPressed: () {},
                constraints: const BoxConstraints.tightFor(
                  width: 56.0,
                  height: 56.0,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              RawMaterialButton(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                fillColor: Colors.white,
                onPressed: () {
                  // animate the camera
                  animateAndZoomTheCamera(10);

                  iniGetUserLocation();
                },
                constraints: const BoxConstraints.tightFor(
                  width: 56.0,
                  height: 56.0,
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                ),
              ),
            ],
          )),
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
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeInUp(
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              color: Colors.white),
          child: Column(
            children: [
              // start
              Container(
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        mStartLocation.startLocationName,
                        //  style: blackBodyText14,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),

              // End
              Container(
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        mEndLocation.endLocationName,
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        // style: blackBodyText14,
                      ),
                    )
                  ],
                ),
              ),

              GetBuilder<SummaryController>(
                builder: (controller) {
                  // Distance
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.social_distance,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              //  "Distance in KM : ${controller.mPolyLineModel.value.mDistanceValue}",
                              "Distance in KM :",
                              // style: blackBodyText14,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (controller.isLoading.isTrue)
                              buildCircleLoaderIndicator(),
                            if (controller.mResponseStatus.value == 200)
                              Text(
                                //  "Distance in KM : ${controller.mPolyLineModel.value.mDistanceValue}",
                                getDistanceBetweenPoint(),
                                // style: blackBodyText14,
                              )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),

              Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      goClose();
                    },
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    child: const Text('Close'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWidgetLookingForAddress() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          buildCircleLoaderIndicator(),
          const SizedBox(
            width: 15,
          ),
          const Text(
            "Looking for Address Name ...",
          )
        ],
      ),
    );
  }

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

  void goClose() {
    Get.back();
  }

  void _onMapCreated(GoogleMapController controller) =>
      mMapController = controller;

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

  void animateAndZoomTheCamera(double zoomValue) async {
    if (mMapController != null) {
      setState(() {
        mMapController!.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(mUserMapLocation!.latitude, mUserMapLocation!.longitude),
            zoomValue));
      });
    }
  }

  void updateIsLookingForAddress(bool isLookingForAddressValue) =>
      setState(() => isLookingForAddress = isLookingForAddressValue);

  void updateLastUserLocation(Position position) => setState(
      () => mUserMapLocation = LatLng(position!.latitude, position!.longitude));

  String getDistanceBetweenPoint() => Utilis.calculateDistance(
          mStartLocation.startLocationLatLon.latitude,
          mStartLocation.startLocationLatLon.longitude,
          mEndLocation.endLocationLanLon.latitude,
          mEndLocation.endLocationLanLon.latitude)
      .toStringAsFixed(2)
      .toString();

  Future<void> addTheTowPointMarker() async {
    print("TestCase");

    var mIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 11)),
      "assets/images/location_pin.png",
    );

    setState(() {
      // start
      markersPint.add(
        Marker(
          markerId: MarkerId('Marker 1 ${mStartLocation.startLocationName}'),
          position: mStartLocation.startLocationLatLon,
          infoWindow: InfoWindow(
            title: mStartLocation.startLocationName,
            snippet: mStartLocation.startLocationName,
          ),
          icon: mIcon,
        ),
      );

      // end
      markersPint.add(
        Marker(
          markerId: MarkerId('Marker 1 ${mEndLocation.endLocationLanLon}'),
          position: mEndLocation.endLocationLanLon,
          infoWindow: InfoWindow(
            title: mEndLocation.endLocationName,
            snippet: mEndLocation.endLocationName,
          ),
          icon: mIcon,
        ),
      );
    });
  }

  void drawLine() {

    LatLng mStart =  mStartLocation.startLocationLatLon;
    LatLng mEnd = mEndLocation.endLocationLanLon ;

    List<LatLng> polylineCoordinates = [
      LatLng(mStart.latitude ,mStart.longitude),
      LatLng(mEnd.latitude ,mEnd.longitude),
    ];

    setState(() {
      mLatLngPolyPoints.addAll(polylineCoordinates);
    });
  }
}
