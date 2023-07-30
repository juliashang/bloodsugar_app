import 'package:bloodsugar_app/authentication/loginPage.dart';
import 'package:bloodsugar_app/firebase/authentication.dart';
import 'package:flutter/material.dart';
import "package:bloodsugar_app/route.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(159,169,78,1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
          ),
          toolbarHeight: 150,
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
        body: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Registeration",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
                height: 10
            ),
            SignUpForm(),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                  height: 10,
                ),
                Text(
                  "Already have an account?",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Log in Now!",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            )
          ],
        )
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _obscureText = false;
  bool agree = false;
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.account_circle),
              counterText: " ",
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
            onSaved: (val) {
              email = val;
            },
            validator: (value) {
              if (value!.isEmpty){
                return "Please Enter Email";
              }
              return null;
            },
          ),
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility
                ),
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              counterText: " ",
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            obscureText: !_obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value!.isEmpty){
                return "Please Enter Password";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              counterText: " ",
              labelText: "Confirmed Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value != pass.text){
                return "Passwords don't match";
              }
              return null;
            },
          ),
          Row(
            children: [
              Checkbox(
                onChanged: (_){
                  setState(() {
                    agree = !agree;
                  });
                },
                value: agree,
              ),
              Expanded(
                flex: 4,
                  child: Text(
                      "By creating account, I agree to Terms & Conditions and Privacy Policy.")
              ),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color.fromRGBO(159,169,78,1),
              ),
              onPressed: (){
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => RoutePage()));

                if(_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  AuthenticationFunctions()
                    .SignUp(email: email!, password: password!)
                    .then((result){
                   if (result == null){
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoutePage()));
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    result,
                    style: const TextStyle(fontSize:16),
                    ),
                    ));
                    }
                  });
                }
              },
              child: Text("Sign Up"),
          )
        ],
      ),
    );
  }
}

