import 'package:bloodsugar_app/authentication/loginPage.dart';
import 'package:flutter/material.dart';
//import "package:bloodsugar_app/loginScreen.dart";
import 'package:bloodsugar_app/route.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({Key? key}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) =>
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage())));
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(159,169,78,1),
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "asset/Logo.png"
                  ),
                  fit: BoxFit.cover,
                )
              ),
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
              width: 20,
            ),
            const Text(
                "version 1.1.1 by Julia Shang",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),
            )
          ],
        )
      ),
    );
  }
}
