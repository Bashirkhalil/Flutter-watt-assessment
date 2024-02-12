import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {

  final isLoading = false.obs;
  final mResponseStatus = 0.obs;

  String mUsername ="123";
  String mPassword ="123";

  // I am just simulating the api but in real we need to check with API
  Future<void> fetchAndCheckUserFromTheAPI(String username ,String pwd) async {
    try {
      isLoading.value = true ;

      String url = "";

      // then we will use http to send the request
     // http.Response response = await http.get(Uri.parse(url));
      // Map<String, dynamic> data = json.decode(response.body);

      if (username==mUsername && pwd == mPassword) {

        mResponseStatus.value = 200 ;

      //  print("The data -> ${data}");
      } else {

        mResponseStatus.value = 500 ;

     //   print("Request failed with status: ${response.statusCode}");
      }

    } catch (e) {
      // Handle network error
      print('Error: $e');
    }finally{
      isLoading.value = false;
    }
  }




}