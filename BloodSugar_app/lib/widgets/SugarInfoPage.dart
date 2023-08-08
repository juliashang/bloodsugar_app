import 'package:bloodsugar_app/widgets/Alternative.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

class SugarInfoPage extends StatefulWidget {

  const SugarInfoPage({Key? key, required this.text, required this.title, required this.isAlternate})
      : super(key: key);
  final String text;
  final String title;
  final bool isAlternate;


  @override
  State<SugarInfoPage> createState() => _SugarInfoPageState();
}

class _SugarInfoPageState extends State<SugarInfoPage> {
  Map info = {};

  @override
  void initState(){
    super.initState();
    analyzeRecipe();
  }

  analyzeRecipe() {
    http
        .post(
      Uri.parse('https://glucobake-server--shangjulia.repl.co/analyze'),
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
        body: info.isNotEmpty ?
            ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: Color.fromRGBO(159,169,78,1),
                child: ListView(
                  children: [
                    Center(
                      child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 40
                          ),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    Text(
                        "Sugar Analysis",
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      "total sugar: ${info['amount_sugar']} g",
                      style: TextStyle(fontSize: 20),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: info["ingredient"].length,
                      itemBuilder: (BuildContext context, int index){
                        String key = info["ingredient"].keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: ListTile(
                            title: Text(
                                key,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Text("${info["ingredient"][key]}"),
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(159,169,78,0.8),),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("OK")),
                    Container(
                      child: widget.isAlternate ? null
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(159,169,78,0.8),),
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext context) => Alternative(title: widget.title, text: widget.text,))
                            );
                          },
                          child: Text("Get a Healthier Alternative Recipe"))
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
    );
  }
}
