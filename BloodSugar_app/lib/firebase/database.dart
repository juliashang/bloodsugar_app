import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'authentication.dart';

Future<Map?> getUserInfo() async{
  Map? data;
  String UserId = AuthenticationFunctions().UserId;
  try {

    await FirebaseFirestore.instance
        .collection("recipe")
        .doc(UserId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map?;
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }catch(e){
    print(e);
  }
  return data;
}

Future<bool> editUserInfo(Map<String, dynamic> data) async{
  String uid = AuthenticationFunctions().UserId;
  List logs = await getSavedRecipes();
  if (logs.isNotEmpty) {
    data['saved_recipe'] = logs;
  }

  FirebaseFirestore.instance.collection("recipe").doc(uid).set(data);
  return true;
}

Future<List> getSavedRecipes() async{
  List savedRecipes = [];
  await getUserInfo().then((data){
    try{
      List temporaryList = data!["saved_recipe"];
      savedRecipes = temporaryList;
    } catch(_){
      print("user has no saved recipes");
    }
  });
  return savedRecipes;
}

Future<bool> addSavedRecipes(Map recipe) async{
  String uid = AuthenticationFunctions().UserId;
  List allSavedRecepies = await getSavedRecipes();
  // String recipeID = UniqueKey().toString();
  // recipe["recipeId"] = recipeID;
  allSavedRecepies.add(recipe);
  FirebaseFirestore.instance
      .collection("recipe")
      .doc(uid)
      .update({'saved_recipe': allSavedRecepies});
  return true;
}

// Future<bool> deleteSavedRecipeLog(Map data) async {
//   String uid = AuthenticationFunctions().UserId;
//   List saved_recipes = await getSavedRecipes();
//
//   // Find the index of the recipe to be deleted
//   int recipeIndex = saved_recipes.indexWhere((recipe) => recipe['recipeId'] == data['recipeId']);
//
//   if (recipeIndex != -1) {
//     // If the recipe is found, remove it from the list
//     saved_recipes.removeAt(recipeIndex);
//
//     // Update the Firestore document with the updated list
//     await FirebaseFirestore.instance
//         .collection("recipe")
//         .doc(uid)
//         .update({'saved_recipe': saved_recipes});
//
//     return true;
//   } else {
//     // If the recipe is not found in the list, return false
//     return false;
//   }
// }