import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data.dart';
import 'notes.dart';

class viewNote extends StatefulWidget {
  NotePageState notePageState;
  String title;
  String note;
  int id;

  viewNote(NotePageState notePageState, int id, String title, String note) {
    this.notePageState = notePageState;
    this.title = title;
    this.note = note;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() {
    return viewNoteState(this.notePageState, this.id, this.title, this.note);
  }
}

class viewNoteState extends State<viewNote> {
  int id;
  String title;
  String note;
  NotePageState notePageState;
  final TitleController = TextEditingController();
  final NotesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  viewNoteState(
      NotePageState notePageState, int id, String title, String note) {
    this.notePageState = notePageState;
    this.title = title;
    this.note = note;
    this.id = id;

    NotesController.text = this.note;
    TitleController.text = this.title;
  }

  @override
  Widget build(BuildContext context) {
    double widdth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff323031),
        actions: [
          SizedBox(
            width: widdth * 20 / 100,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              shape: CircleBorder(),
              color: Colors.orangeAccent,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final now = DateTime.now();
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  final String formatted = formatter.format(now);
                  print(formatted);
                  var data = Data();
                  if (id != -1) {
                    await data.updatee("notes", TitleController.text,
                        NotesController.text, id);
                  } else {
                    await data.insert("notes", {
                      "title": TitleController.value.text,
                      "message": NotesController.value.text,
                      "date": formatted
                    });
                  }
                  this.notePageState.message = await Data().getNotes();
                  Navigator.pop(context);
                  this.notePageState.setState(() {});
                }
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
                size: widdth * 9 / 100,
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double height = constraints.maxHeight;
          double width = constraints.maxWidth;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(
                        left: width * 5 / 100,
                        bottom: widdth * 5 / 100,
                        top: height * 5 / 100),
                    width: widdth / 2,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please enter the title";
                          }
                          return null;
                        },
                        controller: TitleController,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: widdth * 6 / 100),
                        decoration: InputDecoration(
                            hintText: "Enter Note Title",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: widdth * 6 / 100)),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff7bd02),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(
                      left: width * 5 / 100, top: height * 1 / 100),
                  padding: EdgeInsets.only(
                      left: width * 4 / 100, right: width * 4 / 100),
                  height: height * 75 / 100,
                  width: width * 90 / 100,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: NotesController,

                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: "write your Note here",
                              hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          scrollPadding: EdgeInsets.all(20.0),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          // autofocus: true,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
