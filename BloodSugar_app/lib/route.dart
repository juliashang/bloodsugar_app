import 'package:flutter/material.dart';
import "package:bloodsugar_app/widgets/HomeScreen.dart";
import "package:bloodsugar_app/widgets/ProfileScreen.dart";
import "package:bloodsugar_app/widgets/ScanRecipePage.dart";

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _selectedIndex = 0;
  static List<Widget>? _widgetOptions;

  @override
  void initState() {
    _widgetOptions = [
      HomePage(),
      ProfilePage(),
      ScanRecipePage()
    ];
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "profile"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: "Scan Recipe"
          )
        ],
        currentIndex:_selectedIndex,
        selectedItemColor: Color.fromRGBO(159,169,78,1),
        onTap: _onItemTapped,
      ),
    );
  }
}
