

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'dart:async';
import 'dart:io';

import '../theme/colors.dart';
import '../theme/textvalue.dart';
import '../widgets/custom_appbar.dart';

class StatusPage extends StatefulWidget {
  const StatusPage();

  @override
  _StatusPageState createState() => _StatusPageState();
}
class _StatusPageState extends State<StatusPage> {

  var charge;
  bool charbool = true;
  var discharge;
  bool dischabool = true;
  var balance;
  bool balancebool = true;

  Boolvalue() {
    if (charge == "1") {
      charbool = true;
    }
    if (charge == "0") {
      charbool = false;
    }
    if (discharge == "1") {
      dischabool = true;
    }
    if (discharge == "0") {
      dischabool = false;
    }
    if (balance == "0") {
      balancebool = false;
    }
    if (balance == "1") {
      balancebool = true;
    }
  }

  var bat_vol;
  var bat_cap;
  var bat_capacity;
  var bat_temp;
  var bat_percent;
  var bat_cycles;
  var box_temp;
  var uptime;
  var bat_current;
  var mos_temp;

  var ave_cell;
  var cell_diff;
  var last_update;
  var cells_vol = [];
  List<String> cells = [];
  @override
  void initState(){
    super.initState();
    // _Read();
  }

  Future<void> _Read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cells = prefs.getString('List_Cell')!.split(",");
    charge = prefs.getString('charging_mos_switch');
    discharge = prefs.getString('discharge_mos_switch');
    balance = prefs.getString('active_equalization_switch');
    bat_vol = prefs.getString('bat_vol');
    bat_cap = prefs.getString('bat_cap');
    bat_capacity = prefs.getString('bat_capacity');
    bat_temp = prefs.getString('bat_temp');
    bat_percent = prefs.getString('bat_percent');
    bat_cycles = prefs.getString('bat_cycles');
    box_temp = prefs.getString('box_temp');
    uptime = prefs.getString('uptime');
    mos_temp = prefs.getString('tube_temp');
    bat_current = prefs.getString('bat_current');
    cell_diff = prefs.getString('cell_diff');
    ave_cell = prefs.getString('ave_cell');
    last_update = prefs.getString('logger_status');

    Boolvalue();
    var cell1 = cells.toString();
    cell1 = cell1.substring(2,cell1.length-2);
    cells_vol = cell1.split(",");
  }

  @override
  Widget build(BuildContext context) {
    double heightR, widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    // _Read();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: CustomAppbar(),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white60,
          child: DrawerPage(),
        ),
        backgroundColor: Colors.black45,
        body: StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 1)).asyncMap((event) => _Read()).take(1),
          builder: (context, snapshot) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5 * heightR,
                ),
                Container(
                  height: 150*heightR,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 5*heightR,),
                      Container(
                        child: charbool
                            ? Text(
                          'Charge: ON',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : Text(
                          'Charge: OFF',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      //SizedBox(height: 5*heightR,),
                      Container(
                        child: dischabool
                            ? Text(
                          'Discharge: ON',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : Text(
                          'Discharge: OFF',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: balancebool
                            ? Text(
                          'Balance: ON',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        )
                            : Text(
                          'Balance: OFF',
                          style: TextStyle(
                            color: secondary,
                            fontSize: 24 * heightR,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5 * heightR,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "$bat_vol mV",
                          style: TextStyle(
                            color: Colors.greenAccent[400],
                            fontSize: 60*heightR,
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.greenAccent,
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Container(
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text_title(data: 'MOS Temp:'),
                                      Text_title(data: 'Battery Capacity:'),
                                      Text_title(data: 'Cycle Capacity:'),
                                      Text_title(data: 'Ave. Cell Volt:'),
                                      Text_title(data: 'Battery T2:'),
                                      Text_title(data: 'Remain Battery:'),
                                      // Text_title(
                                      //     data:'Remain Capacity(Khong co):'
                                      // ),
                                      Text_title(data: 'Cycle Count:'),
                                      Text_title(data: 'Cell Volt.Diff:'),
                                      Text_title(data: 'Battery T1:'),
                                      // Text_title(
                                      //     data:'Battery T3(Khoong co):'
                                      // ),
                                      // Text_title(
                                      //     data:'Heating Status(Khong co):'
                                      // ),
                                      // Text_title(
                                      //     data:'Charg.Plugged(Khong co):'
                                      // ),
                                      Text_title(data: 'Working time:'),
                                      Text_title(data: 'Last Update:'),

                                    ],
                                  ),
                                  SizedBox(
                                    width: 5 * heightR,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text_Value(
                                        data: '$mos_temp°C',
                                      ),
                                      Text_Value(data: '$bat_cap AH'),
                                      Text_Value(data: '$bat_capacity AH'),
                                      Text_Value(data: '$ave_cell V'),
                                      Text_Value(data: '$bat_temp °C'),
                                      Text_Value(
                                        data: '$bat_percent%',
                                      ),
                                      // Text_Value(
                                      //     data:'396.0AH'
                                      // ),
                                      Text_Value(data: '$bat_cycles'),
                                      Text_Value(data: '$cell_diff V'),
                                      Text_Value(data: '$box_temp°C'),
                                      // Text_Value(
                                      //     data:'23.5°C'
                                      // ),
                                      // Text_Value(
                                      //     data:'OFF'
                                      // ),
                                      // Text_Value(
                                      //     data:'Plugged'
                                      // ),
                                      Text_Value(data: '$uptime'),
                                      Text_Value(data: '$last_update'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(),
                            SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          '$bat_current A',
                          style: TextStyle(
                            color: Colors.greenAccent[400],
                            fontSize: 60 *heightR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 20*heightR,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 250 * heightR,
                        alignment: Alignment.center,
                        child: Text(
                          "Cells Voltage",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                            fontSize: 36 * heightR,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20*heightR,
                      ),
                      Container(
                        height: 600 * heightR,
                        width: 1200 * heightR,
                        color: Colors.black54,
                        child: ListView.builder(
                            itemCount: cells_vol.length ~/ 2,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 40 * heightR,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Text(
                                          "${2*index}",
                                          style: TextStyle(
                                              color: secondary,
                                              fontSize: 25*heightR
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: blue,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        width: 60 * heightR,
                                        alignment: Alignment.center,
                                      ),
                                      SizedBox(
                                        width: 10 * heightR,
                                      ),
                                      Text(
                                        "${cells_vol[2*index]} mV",
                                        style: TextStyle(
                                            color: green,
                                            fontSize: 25*heightR
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80 * heightR,
                                      ),
                                      Container(
                                        child: Text(
                                          "${2*index + 1}",
                                          style: TextStyle(
                                              color: secondary,
                                              fontSize: 25*heightR
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: blue,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        width: 60 * heightR,
                                        alignment: Alignment.center,
                                      ),
                                      SizedBox(
                                        width: 10 * heightR,
                                      ),
                                      Text(
                                        "${cells_vol[2*index+1]} mV",
                                        style: TextStyle(
                                            color: green,
                                            fontSize: 25*heightR
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ) //Center
    );


  }
}


