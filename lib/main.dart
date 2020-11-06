import 'package:flutter/material.dart';
import 'login.dart';
// import 'manage.dart';
import 'home.dart';


//void main() {
// runApp((MyApp));
//}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp2 = MaterialApp(
      title: "My Flutter App",
      routes: {
         '/': (context) => Login(),
        // 'Manage': (context) => Manage(),
        'home': (context) => Home(),
      },
     
    );
    var materialApp = materialApp2;
    return materialApp;
  }
}
