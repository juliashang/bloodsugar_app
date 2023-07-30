import 'package:flutter/material.dart';
import '../firebase/database.dart';
import "SugarInfoPage.dart";

class IngredientPage extends StatelessWidget {
  final String text;
  final String title;
  final bool isRecommended;

  const IngredientPage({super.key, required this.text, required this.title, required this.isRecommended});


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
      Map<String, dynamic> recipeInfo = {"title": title, "ingredient": text};
      addSavedRecipes(recipeInfo).then((value) {
        snapBarBuilder('Recipe was saved');
      });
    };
    double height = MediaQuery.of(context).size.height;
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
                  Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    )
                  ),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  Text(
                      text,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black
                      )
                  ),
                  Container(
                    child: isRecommended ? null
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(159,169,78,1),
                      ),
                      onPressed: saveRecipe,
                      child: Text("Save Recipe"),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SugarInfoPage(
                                    text: text,
                                    title: title,
                                    isAlternate: false
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
        ),
      ),
    );
  }
}
