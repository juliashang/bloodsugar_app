
import "package:bloodsugar_app/widgets/ResultScan.dart";
import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import "dart:io";
import "package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart";

class ScanRecipePage extends StatefulWidget {
  const ScanRecipePage({Key? key}) : super(key: key);

  @override
  State<ScanRecipePage> createState() => _ScanRecipePageState();
}

class _ScanRecipePageState extends State<ScanRecipePage> {

  final ImagePicker _imagePicker = ImagePicker();
  File? selectedImage;
  final textRecognizer = TextRecognizer();
  var recipeName = TextEditingController();

  ImageFromCamera() async {
    final image =
        await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 100
        );
    setState(() {
      selectedImage = File(image!.path);
    });
  }

  ImageFromLibrary()async {
    final image =
    await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100
    );
    setState(() {
      selectedImage = File(image!.path);
    });
  }

  void ShowPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Photo Library"),
                onTap: (){
                  ImageFromLibrary();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_rounded),
                title: Text("Take a picture"),
                onTap:(){
                  ImageFromCamera();
                  Navigator.of(context).pop();
                } ,
              )
            ],
          );
        }
    );
  }

  Future<void> ShowDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Do you want to change the cucrent image?"),
                ]
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    selectedImage = null;
                    Navigator.of(context).pop();
                    ShowPicker();
                  },
                  child: Text("Yes")
              ),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("No")
              ),
            ],
          );
        }
    );
  }

  showLoading() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return CircularProgressIndicator();
        }
    );
  }

  Padding ImageContainer(double width, double height) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: Container(
        height: height * 0.5,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(
                color: Colors.black
            )
        ),
        child: selectedImage == null
          ? IconButton(
          icon: Icon(Icons.camera_alt,
          size: 100,
          ),
          onPressed: () {
            ShowPicker();
          },
        )
        : Stack(
          children: [
            Container(
              child: Image.file(
                File(selectedImage!.path)
              ),
              alignment: Alignment.center,
            ),
            Positioned(
              right: 0.01,
              top: 5,
              child: MaterialButton(
                  onPressed: (){
                    ShowDialog();
                  },
                child: Icon(
                    Icons.edit,
                  size: 30,
                  color: Color.fromRGBO(246, 233, 203, 1),
                ),
                shape: CircleBorder(),
                color: Color.fromRGBO(159,169,78,1),
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> scanImage() async {
    if (selectedImage == null) return;
    try {
      final inputImage = InputImage.fromFile(selectedImage!);
      final recognizedText = await textRecognizer.processImage(inputImage);

      print(recognizedText.text);

      print(recognizedText.blocks);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScanPage(
            text: recognizedText.text,
            title: recipeName.text.trim(),
          ),
        ),
      ).then((value) {
        recipeName.text = '';
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
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
        body: Container(
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: GlowingOverscrollIndicator(
              axisDirection: AxisDirection.down,
              color: Color.fromRGBO(159,169,78,1),
              child: ListView(
                children: [
                  const Text(
                      "Scan Recipe",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      counterText: " ",
                      labelText: "Recipe Name",
                      hintText: "Cake",
                      border: OutlineInputBorder(),
                    ),
                    controller: recipeName,
                  ),
                  ImageContainer(width,height),
                  ElevatedButton(
                      onPressed: scanImage,//scanImage(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159,169,78,1),
                      ),
                      child: const Text("Scan Recipe")
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
