import 'package:flutter/material.dart';
import '../firebase/database.dart';
import "IngredientScreen.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List recommendedRecipes = [
    {"title":"Healthy Chocolate Cake", "ingredient":"1 cup powdered sugar \n1/2 cup sweetener \n1/2 cup cocoa powder \n2 teaspoon vanilla extract \n1/2 cup unsweetened almond milk.",},
    {"title":"Healthy carrot cake with yoghurt frosting", "ingredient":"2 cups blanched almonds \n1/4 cup brown sugar \n80g unsalted butter \n500g cream cheese \n3 eggs \n2/3 cup sugar \n500g Greek yogurt \n2 teaspoon vanilla extract \n2 tablespoon yuzu juice \n2 tbs cornflour",},
    {"title":"Rhubarb and honey cake", "ingredient":"4 eggs \n1/2 cup honey \n1/2 cup extra virgin olive oil \n1 orange \n1 teaspoon vanilla extract \n3.5 cups almond meal \n2 tsp baking powder \n1 tbs pomegranate molasses \n1 pomegranate",},
  ];
  List savedRecipes = [];

  bool loadSavedRecipe = true;
  bool loadRecommendedRecipe = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  getInfo() async {
    getSavedRecipes().then((info){
      if(info != null){
        setState(() {
          savedRecipes = info;
          loadSavedRecipe = false;
        });
      }
    });
  }

  Container buildRecipeList(
      double width, double height, List recipeList, String title, bool isRec){
    return Container(
      width: width,
      height: height * 0.3,
      decoration: const ShapeDecoration(
        color: Color.fromRGBO(246, 233, 203, 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)))
      ),
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Color.fromRGBO(159,169,78,1),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                title,
                maxLines: 2,
                style: TextStyle(fontSize: 20),
              ),
              Container(
                color: Color.fromRGBO(159,169,78,0.6),
                height: 2,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.all(7),
                itemCount: recipeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(recipeList[index]["title"]),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => IngredientPage(text: recipeList[index]["ingredient"], title: recipeList[index]["title"], isRecommended: isRec)
                          )
                      )
                    },
                  );
                },
                separatorBuilder:(BuildContext context, int index) => Divider()
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
        body: !loadSavedRecipe && !loadRecommendedRecipe
            ? Center(
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: Color.fromRGBO(159,169,78,1),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Your Recipes",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 20
                      ),
                      buildRecipeList(width, height, savedRecipes, "Saved Recipes", true),
                      SizedBox(
                        height: 20
                      ),
                      buildRecipeList(width, height, recommendedRecipes, "Recommended Recipes", false),
                    ],
                  ),
                ),
              )
            )
          : Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          ),
        )
      ),
    );
  }
}
