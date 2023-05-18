import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:medical_health_firebase/widgets/navbar_roots.dart';
import '../Data/constants.dart';
import 'SignUpScreen.dart';
import 'custom_flat_button.dart';

class TouchFingerView extends StatefulWidget {
  const TouchFingerView({Key? key}) : super(key: key);

  @override
  State<TouchFingerView> createState() => _TouchFingerViewState();
}

class _TouchFingerViewState extends State<TouchFingerView> {
  bool? _hasBioSensor;

  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      print(_hasBioSensor);
      if (_hasBioSensor!) {
        _getAuth();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
          localizedReason: 'Scan your fingerprint',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true));
      if (isAuth) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavBarRoots()));
      }
      print(isAuth);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Medical App",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            Text(
              'Quick login with Touch ID',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.fingerprint, size: 90, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Touch ID',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
            const Spacer(),
            CustomFlatButton(
                text: 'Login',
                color: MyColors.kPrimaryColor,
                textColor: Colors.white,
                onTap: () {
                  _checkBio();
                }),
            const SizedBox(height: 20),
            CustomFlatButton(
                text: 'Register',
                color: Colors.white,
                textColor: MyColors.kPrimaryColor,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                }),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
