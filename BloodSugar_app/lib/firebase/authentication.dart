import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationFunctions{
  final FirebaseAuth authenticationInfo = FirebaseAuth.instance;

  get CurrentUser => authenticationInfo.currentUser;
  get UserId => CurrentUser.uid;

  Future SignUp({required String email, required String password}) async{
    try{
      await authenticationInfo.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future SignIn({required String email, required String password}) async{
    try{
      await authenticationInfo.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future SignOut() async{
    await authenticationInfo.signOut();
  }
  String getUID(){
    return CurrentUser.uid;
  }
}