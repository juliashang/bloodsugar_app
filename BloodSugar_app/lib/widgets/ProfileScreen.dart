import 'package:flutter/material.dart';

import '../firebase/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _age = TextEditingController();
  final _patientType = TextEditingController();
  final _bloodSugar = TextEditingController();
  var _genders = ["Male", "Female"];
  String? _genderSelection;

  getInfo() async {
    getUserInfo().then((info){
      if(info != null){
        setState(() {
          _weight.text = info!["weight"];
          _height.text = info!["height"];
          _age.text = info!["age"];
          _patientType.text = info!["patient type"];
          _bloodSugar.text = info!["blood sugar"];
          _genderSelection= info!["gender"];
        });
      }
    });
  }

  updateInfo(){
    Map<String, dynamic> userInfo = {
      "weight": _weight.text.trim(),
      "height": _height.text.trim(),
      "age": _age.text.trim(),
      "patient type": _patientType.text.trim(),
      "blood sugar": _bloodSugar.text.trim(),
      "gender": _genderSelection
    };
    buildLoading();
    editUserInfo(userInfo).then((value) {
      Navigator.of(context).pop();
      snapBarBuilder('User info edited');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  buildLoading(){
    return showDialog(
    context: context,
    builder: (BuildContext context){
      return Center(child: CircularProgressIndicator());
    }
    );
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(159,169,78,1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
          ),
          toolbarHeight: 100,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("asset/Logo.png"),
                          fit: BoxFit.fitHeight
                      )
                  ),
                ),
              )
            ],
          ),
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Color.fromRGBO(159,169,78,1),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                       const Text(
                          "Profile Page",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      TextField(
                        controller: _weight,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Weight",
                          hintText: "150",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      TextField(
                        controller: _height,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "height",
                          hintText: "5'4''",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      TextField(
                        controller: _age,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Age",
                          hintText: "30",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      TextField(
                        controller: _patientType,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Patient Type",
                          hintText: "A",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      TextField(
                        controller: _bloodSugar,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Blood Sugar",
                          hintText: "6.3",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ),
                      createRoundedDropdown(width),
                      ElevatedButton(
                          onPressed: updateInfo,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(159,169,78,1)
                          ),
                          child: const Text(
                            "Update Info",
                            style: TextStyle(
                                fontSize: 15
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createRoundedDropdown(width){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black45
        )
      ),
      height: 60,
      width: width * 0.95,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          onChanged: (newValue){
            setState(() {
              _genderSelection = newValue;
            });
          },
          borderRadius: BorderRadius.circular(10),
          style: TextStyle(fontSize: 10),
          hint: Text("Gender"),
          value: _genderSelection,
          isDense: true,
          items: _genders.map((document) {
            return DropdownMenuItem<String>(
              value: document,
              child: Text(
                  document,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  )
              ),
          );
          }).toList(),
        ),
      ),
    );
  }
}
