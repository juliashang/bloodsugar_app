import 'package:bloodsugar_app/authentication/signUpPage.dart';
import 'package:bloodsugar_app/firebase/authentication.dart';
import 'package:flutter/material.dart';
import "package:bloodsugar_app/route.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(159,169,78,1),
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
            "GlucoBake",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
              height: 10
          ),
          LoginForm(),
          Row(
            children: <Widget>[
              SizedBox(
                width: 30,
                height: 10,
              ),
              Text(
                  "New here?",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text(
                    "Get Registered Now!",
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

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _obscureText = true;

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
            obscureText: _obscureText,
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
                    .SignIn(email: email!, password: password!)
                    .then((result){
                   if (result == null){
                     Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => RoutePage()));
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
              child: Text("Log in")
          )
        ],
      ),
    );
  }
}

