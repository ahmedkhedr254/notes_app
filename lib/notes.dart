import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/data.dart';
import 'package:notes_app/viewNote.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'calender.dart';

class NotePage extends StatefulWidget {
  List<dynamic> message;

  NotePage(List<dynamic> message) {
    this.message = message;
  }

  @override
  State<StatefulWidget> createState() {
    return NotePageState(message);
  }
}

class NotePageState extends State<NotePage> {
  List<dynamic> message;
  final myController = TextEditingController();

  NotePageState(List<dynamic> message) {
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

    return Expanded(
        child: InkWell(
            child: SelectableText(s, style: mystyle),
            onTap: () async {
              String x = s;

              if (await canLaunch("$x")) {
                print("efrg");
                await launch("$x");
              } else {
                if (isURL(x)) {
                  x = "http://" + x;
                  await launch("$x");
                }
              }
            }));
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff323031),
          leading: FlatButton.icon(
            padding: EdgeInsets.all(0),
            onPressed:(){
              Navigator.pop(context);

            } ,
            icon:Icon(Icons.arrow_back,color: Colors.white,) ,
            label: Text(""),
          ),
          title: Text(
            "My Notes",
            style: TextStyle(color: Colors.white),
          ),

          actions: [
            FlatButton(
                shape: CircleBorder(),
                color: Color(0xfff7bd02),
                padding: EdgeInsets.all(0),
                onPressed: () async {
                  print(DateTime.now());
                  List<dynamic> date = await Data().getDistinctDate();
                  Map<DateTime, List> _events = {};
                  for (i = 0; i < date.length; i++) {
                    _events[DateTime.parse(
                            date[i]["date"].toString() + " 00:00:00")] =
                        await Data()
                            .getNotesWithDate(date[i]["date"].toString());
                  }
                  final now = DateTime.now();
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  final String formatted = formatter.format(now);
                  List selectedEvent = await Data().getNotesWithDate(formatted);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CalenderPage(_events, selectedEvent)),
                  );
                },
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                )),
            FlatButton(
                shape: CircleBorder(),
                color: Color(0xffdb3a34),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => viewNote(this,-1,"","")));
                },
                child: Icon(
                  Icons.add_box,
                  color: Colors.white,
                )),
          ],
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
                                  child: FlatButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                viewNote(this, e['id'],e['title'],e['message'])),
                                      );
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width * 5 / 100,
                                        ),
                                        Container(
                                          width: width * 20 / 100,
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "images/a.png",
                                                width: width * 15 / 100,
                                                height: width * 15 / 100,
                                              ),
                                              Text(
                                                e['date'].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 5 / 100,
                                        ),

                                        Container(
                                          width: width * 35 / 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e['title'],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: width * 6 / 100),
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 3 / 100),
                                                  child: Text(
                                                    e['message'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            width * 4 / 100),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        // Expanded(child: Text(e['message'].toString(),style: TextStyle(color: Colors.black),),),
                                        Column(
                                          children: [
                                            FlatButton.icon(
                                                onPressed: () async {
                                                  var data = Data();
                                                  await data.delete(
                                                      "notes", e["id"]);
                                                  this.message =
                                                      await data.getNotes();
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
