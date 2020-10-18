import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};



class CalenderPage extends StatefulWidget {
  Map<DateTime, List> _events;
  List _selectedEvents;
  CalenderPage( Map<DateTime, List> _events, List _selectedEvents){
    this._events=_events;
    this._selectedEvents=_selectedEvents;
  }

  @override
  CalenderPageState createState() => CalenderPageState(this._events,this._selectedEvents);
}

class CalenderPageState extends State<CalenderPage> with TickerProviderStateMixin {
  List<dynamic>date;
  List _selectedEvents;
  Map<DateTime, List> _events;
  CalenderPageState( Map<DateTime, List> _events, List _selectedEvents){
    this._events=_events;
    this._selectedEvents=_selectedEvents;
  }


  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(_selectedDay);
    print(formatted);



    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Calender"),
        backgroundColor: Color(0xff1f0063),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList(width)),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text('Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }
  Widget myText(String s){
    var mystyle;
    if (isURL(s)){
      mystyle=TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 20
      );
    }
    else{
      mystyle=TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 20
      );
    }

    return Expanded(child:InkWell(
        child: Text(s,style: mystyle),
        onTap: () async {
          String x=s;

          if (await canLaunch("$x")) {
            print("efrg");
            await launch("$x");
          }
          else{
            if (isURL(x)){
              x="http://"+x;
              await launch("$x");

            }
          }
        }
    ));
  }
  Widget _buildEventList(double width) {
    List<Color> x =[Color(0xffff595e),Color(0xffffca3a),Color(0xff8ac926),Color(0xff1982c4),Color(0xff9300fe),];
    int i=0;
    return  SingleChildScrollView(
      child: Column(
        children: _selectedEvents.map((event) {
          i++;
          return Card(
            margin: EdgeInsets.only(
                left: width * 3 / 100,
                right: width * 3 / 100,
                top: width * 3 / 100),
            color: x[(i - 1) % 4],
            child: FlatButton(
              onPressed: (){print("vvvvvvvv");},
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
                          event['date'].toString(),
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
                          event['title'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 6 / 100),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: width * 2 / 100),
                            child: Text(
                              event['message'].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                  width * 4 / 100),
                            )),
                      ],
                    ),
                  ),
                  // Expanded(child: Text(e['message'].toString(),style: TextStyle(color: Colors.black),),),

                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}