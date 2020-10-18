import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/data.dart';
import 'package:notes_app/viewNote.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'calender.dart';

class passwords extends StatefulWidget {
  List<dynamic> message;

  passwords(List<dynamic> message) {
    this.message = message;
  }

  @override
  State<StatefulWidget> createState() {
    return passwordsState(message);
  }
}

class passwordsState extends State<passwords> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> message;
  final myController = TextEditingController();

  passwordsState(List<dynamic> message) {
    this.message = message;
  }

  Widget myText(String s) {
    var mystyle;
    if (isURL(s)) {
      mystyle = TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          //fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 20);
    } else {
      mystyle = TextStyle(
        //fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: Colors.white,
          fontSize: 20);
    }

    return
      InkWell(
          child: Text(s, style: mystyle),
          onTap: () async {
            String x = s;
            print("a");
            if (await canLaunch("$s")) {
              print("efrg");
              await launch("$x");
            } else {
              if (isURL(x)) {
                print("efrg");
                x = "http://" + x;
                await launch("$x");
              }
            }
          });

  }

  List<Color> x = [
    Color(0xff323031),
    Color(0xffffc857),
    Color(0xffdb3a34),
    Color(0xff084c61),
    Color(0xff177e89),
  ];

  int i = 0;

  @override
  Widget build(BuildContext context) {
    double widthh = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String newPsswordTitle;
    String newPssword;
    return Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(
                shape: CircleBorder(),
                color: Color(0xffdb3a34),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          "Create password",
                          style: TextStyle(
                              fontSize: widthh * 6 / 100,
                              color: Colors.black87),
                        ),
                        content: Container(
                          child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: height * 1 / 100,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            fontSize: widthh * 4 / 100),
                                        validator: (value) {

                                          if (value.isEmpty) {
                                            return 'Please enter the title';
                                          }
                                          return null;
                                        },
                                        onChanged: (a) {
                                          newPsswordTitle = a;
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                fontSize: widthh * 4 / 100,
                                                color: Colors.grey),
                                            hintText: "Enter password title"),
                                      ),
                                      SizedBox(
                                        height: height * 1 / 100,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            fontSize: widthh * 4 / 100),
                                        validator: (value) {

                                          if (value.isEmpty) {
                                            return 'Please enter the password';
                                          }
                                          return null;
                                        },
                                        onChanged: (a) {
                                          newPssword = a;
                                        },
                                        decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                fontSize: widthh * 4 / 100,
                                                color: Colors.grey),
                                            hintText: "Enter password"),
                                      ),
                                      FlatButton(
                                        color: Color(0xffFFCA3A),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                        ),
                                        child: Text(
                                          "create",
                                          style: TextStyle(
                                              fontSize: widthh * 5 / 100,
                                              color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          final now = DateTime.now();
                                          final DateFormat formatter = DateFormat('yyyy-MM-dd');
                                          final String formatted = formatter.format(now);
                                          if (_formKey.currentState
                                              .validate()) {
                                            await Data().insert("passwords",
                                                {"message": newPssword,"title":newPsswordTitle,"date":formatted});
                                            this.message =
                                            await Data().getPasswords();
                                            //myFolderList.add({newFolderNmae});
                                            setState(() {});
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ))),
                        ),
                      ));
                },
                child: Icon(
                  Icons.add_box,
                  color: Colors.white,
                )),
          ],
          backgroundColor: Color(0xff323031),
          leading: FlatButton.icon(
            padding: EdgeInsets.all(0),
            icon:Icon(Icons.arrow_back,color: Colors.white,),
            label: Text(""),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            "My passwords",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              return Container(
                  width: width,
                  height: height * 90 / 100,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 90 / 100,
                          margin: EdgeInsets.only(bottom: height * .1 / 100),
                          width: width,
                          color: Color(0xfff0f2f5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: this.message.map((e) {
                                i++;
                                return Card(
                                  margin: EdgeInsets.only(
                                      left: width * 3 / 100,
                                      right: width * 3 / 100,
                                      top: width * 3 / 100),
                                  color: x[(i - 1) % 4],
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width * 5 / 100,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "images/a.png",
                                            width: width * 15 / 100,
                                            height: width * 15 / 100,
                                          ),
                                          Text(
                                            e['date'].toString(),
                                            style:
                                            TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 5 / 100,
                                      ),

                                      Container(
                                        width: widthh*35/100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e['title'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20
                                              ),

                                            ),
                                            myText(
                                              "*"*e['message'].toString().length,

                                            )
                                          ],
                                        ),
                                      ),
                                      // Expanded(child: Text(e['message'].toString(),style: TextStyle(color: Colors.black),),),
                                      Column(
                                        children: [
                                          FlatButton.icon(
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: e['message']
                                                        .toString()));
                                              },
                                              icon: Icon(
                                                Icons.content_copy,
                                                color: Colors.white,
                                              ),
                                              label: Text("")),
                                          FlatButton.icon(
                                              onPressed: () async {
                                                var data = Data();
                                                await data.delete(
                                                    "passwords", e["id"]);
                                                this.message =
                                                await data.getPasswords();
                                                setState(() {});
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              label: Text("")),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ));
  }
}
