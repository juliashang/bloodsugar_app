import 'dart:convert';

import 'package:bloodsugar_app/widgets/SugarInfoPage.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Alternative extends StatefulWidget {
  const Alternative({Key? key, required this.text, required this.title})
      : super(key: key);
  final String text;
  final String title;

  @override
  State<Alternative> createState() => _AlternativeState();
}

class _AlternativeState extends State<Alternative> {
  Map info = {};
  @override
  void initState(){
    super.initState();
    get_alternative();
  }
  get_alternative() {
    http
        .post(
      Uri.parse('https://glucobake.mclovin0213.repl.co/alternative'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'title': widget.title, 'ingredient': widget.text}),
    )
        .then((response) {
      if (response.statusCode == 200) {
        Map result = jsonDecode(response.body);
        print(result);
        setState(() {
          info = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    snapBarBuilder(String snapBar){
      final snackBar = SnackBar(content: Text(snapBar));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
    saveRecipe(){
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      Map<String, dynamic> recipeInfo = {"title": widget.title, "ingredients": widget.text};
      snapBarBuilder('Recipe was saved');
      // addSavedRecipeLog(recipeInfo).then((value) {
      //   snapBarBuilder('Recipe was saved');
      // });
    };

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
            child: info.isNotEmpty
            ? ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Color.fromRGBO(159,169,78,1),
                child: ListView(
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            info["alternative_recipe"][index],
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        );
                      },
                      itemCount: info["alternative_recipe"].length,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159,169,78,1),
                      ),
                      onPressed: saveRecipe,
                      child: Text("Save Recipe"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          List<String>? new_ingredient = List<String>.from(info["alternative_recipe"] as List);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SugarInfoPage(
                                      text: new_ingredient.join("\n"),
                                      title: widget.title,
                                      isAlternate: true,
                                  )
                              )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(159,169,78,1),
                            padding: EdgeInsets.only(left: 10, right: 10)
                        ),
                        child: Text(
                            "Analyze Sugar"
                        )
                    )
                  ],
                ),
              ),
            )
          : ListView(
        children: [
        Center(
        child: CircularProgressIndicator(
            backgroundColor: Colors.blue
        ),
      )
      ],
      )
        ),
      ),
    );
  }
}
