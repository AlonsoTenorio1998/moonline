import 'package:flutter/material.dart';
import 'package:moonline/src/pages/compartir_page.dart';
import 'package:moonline/src/pages/home_page.dart';
import 'package:moonline/src/pages/sharing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoonLine',
      debugShowCheckedModeBanner: false,
      initialRoute: 'ReceiveSharingPage',
      routes: {
        'HomePage'           : (BuildContext context)=> HomePage(),
        'CompartirPage'      : (BuildContext context)=> CompartirPage(),
        'ReceiveSharingPage' : (BuildContext context)=> ReceiveSharingPage(),
      },
    );
  }
}
