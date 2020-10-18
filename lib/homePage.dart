import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/data.dart';
import 'package:notes_app/passwords.dart';
import 'package:notes_app/viewNote.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'links.dart';
import 'notes.dart';
class homepage extends  StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return homepageState();
  }

}
class homepageState  extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Scaffold (
      appBar: AppBar(
        leading: Icon(Icons.speaker_notes),
        title: Text("Notes app",style: TextStyle(color: Colors.black,fontSize: 20),),
        backgroundColor: Colors.white,
      ),
      body: Center(

        child:Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: ()async{
                    List<dynamic> message = await Data().getNotes();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {

                        return NotePage(message);
                      }),
                    );
                  },
                  padding: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("notes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width*7/100),),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.orange,
                    ),
                    margin: EdgeInsets.only(right: width*5/100),

                    width: width*40/100,
                    height: width*40/100,
                  ),
                ),
                FlatButton(
                  onPressed: ()async{
                    List<dynamic> message = await Data().getPasswords();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {

                        return passwords(message);
                      }),
                    );
                  },
                  padding: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("passwords",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width*7/100),),

                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.pink,
                    ),

                    width: width*40/100,
                    height: width*40/100,
                  ),
                )
              ],
            ),
            SizedBox(height: height*2/100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: ()async{
                    List<dynamic> message = await Data().getLinks();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {

                        return Links(message);
                      }),
                    );
                  },
                  padding: EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("URL Links",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width*7/100),),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xff6a4c93),
                    ),
                    margin: EdgeInsets.only(right: width*5/100),

                    width: width*40/100,
                    height: width*40/100,
                  ),
                ),

              ],
            ),
          ],
        )
      ),
    );

  }

}