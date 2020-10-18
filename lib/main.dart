import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/data.dart';
import 'package:notes_app/viewNote.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'calender.dart';
import 'homePage.dart';
import 'notes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var x=await Data();
   await x.getDistinctDate();
  List<dynamic> message = await Data().getNotes();
  runApp(mainApp(message));
}
class mainApp extends StatelessWidget{
  List<dynamic> message;
  mainApp( List<dynamic> message){
     this.message=message;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home://MyHomePage()
       //NotePage(message),
     // viewNote()
      homepage()
    );
  }

}