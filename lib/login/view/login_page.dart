import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tracking_application/commonGoogleMap/common_constant_widget.dart';
import 'package:tracking_application/commonGoogleMap/common_editText.dart';

import '../../startLocation/view/start_location_page.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController mLoginController = Get.put(LoginController());
  String username = "";
  String password = "";

  var fToast = FToast();

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page '),
        ),
        body:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    "assets/images/location_pin.png",
                  )),
              mHeight_5,
              CommonEditText(
                keyboardType: TextInputType.number,
                inputType: InputType.normalNumber,
                labelName: "labelName",
                hint: "Enter Mobile Number ",
                onChanged: (value) {
                  username = value;
                },
                onSubmitted: (value) {},
              ),
              CommonEditText(
                keyboardType: TextInputType.number,
                inputType: InputType.password,
                labelName: "labelName",
                hint: "Enter password ",
                onChanged: (value) {
                  password = value;
                },
                onSubmitted: (value) {},
              ),
              mHeight_10,
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                    onPressed: () {
                      mLoginController.fetchAndCheckUserFromTheAPI(
                          username, password);

                      if (username.isEmpty && password.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter valid username and password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      mLoginController.fetchAndCheckUserFromTheAPI(
                          username, password);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder()),
                    child: Obx(() {

                      try{
                        print("ValueR -> ${mLoginController.mResponseStatus.value}");

                        if(mLoginController.mResponseStatus.value == 200){
                          Get.to(() => const StartLocationPage());
                        }else if(mLoginController.mResponseStatus.value == 500){
                          Fluttertoast.showToast(
                              msg: "Error valid username and password",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }catch(e){
                        print("Error ${e}");
                      }

                      return const Text('Login');
                    })),
              ),
            ])

        );
    //);
  }
}
