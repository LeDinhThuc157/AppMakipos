import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../theme/textvalue.dart';
import '../widgets/custom_appbar.dart';

class  SettingsPage extends StatefulWidget {
   SettingsPage({Key ? key,}

      ):super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  var bat_vol;
  var bat_cap;
  var bat_capacity;
  var bat_temp;
  var bat_percent;
  var bat_cycles;
  var box_temp;
  var uptime;
  String time_uptime = '';
  var bat_current;
  var mos_temp;
  var ave_cell;
  var cell_diff;
  var last_update;
  var logger_status;




  // Basic setting text
  TextEditingController  cellcount = TextEditingController();
  var _cellcount;
  TextEditingController batterycapacity = TextEditingController();
  var _batterycapacity;


  // Advance Settings
  TextEditingController cellOVP = TextEditingController();
  TextEditingController cellOVPR = TextEditingController();
  TextEditingController cellUVPR = TextEditingController();
  TextEditingController cellUVP = TextEditingController();
  TextEditingController continuedChargeCurr = TextEditingController();
  TextEditingController continuedDischargeCurr = TextEditingController();
  TextEditingController dischargeOCPdelay = TextEditingController();
  TextEditingController chargeOTP = TextEditingController();
  TextEditingController dischargeOTP = TextEditingController();
  TextEditingController chargeUTP = TextEditingController();
  TextEditingController chargeUTPR = TextEditingController();
  TextEditingController startBalanceVolt = TextEditingController();

  var _calibratingVolt;
  var _calibratingCurr;
  var _cellOVP;
  var _cellOVPR;
  var _cellUVPR;
  var _cellUVP;
  var _continuedChargeCurr;
  var _continuedDischargeCurr;
  var _dischargeOCPdelay;
  var _chargeOTP;
  var _dischargeOTP;
  var _chargeUTP;
  var _chargeUTPR;
  var _startBalanceVolt;

  var id;
  var token;
  Future<void> _Read() async {
    // Read status
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('Id_device');
    token = prefs.getString('Token');
    // charge = prefs.getString('charging_mos_switch');
    // discharge = prefs.getString('discharge_mos_switch');
    // balance = prefs.getString('active_equalization_switch');
    bat_vol = prefs.getString('bat_vol');
    bat_cap = prefs.getString('bat_cap');
    bat_capacity = prefs.getString('bat_capacity');
    bat_temp = prefs.getString('bat_temp');
    bat_percent = prefs.getString('bat_percent');
    bat_cycles = prefs.getString('bat_cycles');
    box_temp = prefs.getString('box_temp');
    uptime = prefs.getString('uptime');
    final int years = (int.parse(uptime) / 525600).floor();
    final int remainingMinutes = int.parse(uptime)  % 525600;
    final int months = (remainingMinutes / 43800).floor();
    final int remainingMinutes2 = remainingMinutes % 43800;
    final int days = (remainingMinutes2 / 1440).floor();
    final int remainingMinutes3 = remainingMinutes2 % 1440;
    final int hours = (remainingMinutes3 / 60).floor();
    final int minutesRemaining = remainingMinutes3 % 60;
    time_uptime = '$years''Y:$months''M:$days''D $hours''h:$minutesRemaining''m';
    mos_temp = prefs.getString('tube_temp');
    bat_current = prefs.getString('bat_current');
    cell_diff = prefs.getString('cell_diff');
    ave_cell = prefs.getString('ave_cell');
    last_update = prefs.getString('logger_status');
    // Read setting
    _cellcount = prefs.getString('strings_settings');
    _batterycapacity = prefs.getString('battery_capacity_settings');
    _calibratingVolt = prefs.getString('bat_vol');
    _calibratingCurr = prefs.getString('bat_current');
    _cellOVP = prefs.getString('single_overvoltage');
    _cellOVPR = prefs.getString('monomer_overvoltage_recovery');
    _cellUVPR = prefs.getString('discharge_overcurrent_protection_value');
    _cellUVP = prefs.getString('differential_voltage_protection_value');
    _continuedChargeCurr = prefs.getString('equalizing_opening_differential');
    _continuedDischargeCurr = prefs.getString('charging_overcurrent_delay');
    _dischargeOCPdelay = prefs.getString('equalizing_starting_voltage');
    _chargeOTP = prefs.getString('high_temp_protect_bat_charge');
    _dischargeOTP = prefs.getString('high_temp_protect_bat_discharge');
    _chargeUTP = prefs.getString('charge_cryo_protect');
    _chargeUTPR = prefs.getString('recover_val_charge_cryoprotect');
    _startBalanceVolt = prefs.getString('tube_temp_protection');
  }


  @override
  Widget build(BuildContext context) {
    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    final _height_1 = 40*heightR;
    final _widht_1 = 100*heightR;
    // postDataSetting(id,"single_overvoltage",4200);
    // postDataSetting(id,"single_overvoltage",4200);
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
          stream: Stream.periodic(Duration(seconds: 1)).asyncMap((event) => _Read()),
          builder: (context,snapshot) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5*heightR,),
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
                          "$bat_vol V",
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
                                      Text_Value(data: '$_batterycapacity AH'),
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
                                      Text_Value(data: '$time_uptime'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 250 * heightR,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5*heightR,bottom: 5*heightR),
                        child: Text(
                          "Basic Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                            fontSize: 30*heightR,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20*heightR,
                      ),
                      Container(
                        width: 1200 * heightR,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cell Count:"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Battery Capacity(AH):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Calibrating Volt.(mA):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Calibrating Curr.(A):"),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                            SizedBox(
                              width: 20*heightR,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    obscureText: false,
                                    decoration:  InputDecoration(
                                        labelText: "$_cellcount",
                                        labelStyle: TextStyle(color: Colors.cyanAccent)
                                    ),
                                    controller: cellcount,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    obscureText: false,
                                    decoration:  InputDecoration(
                                        labelText: "$_batterycapacity",
                                        labelStyle: TextStyle(color: Colors.cyanAccent)
                                    ),
                                    controller: batterycapacity,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    autocorrect: false,
                                    obscureText: false,
                                    decoration:  InputDecoration(
                                        labelText: "$_calibratingVolt",
                                        labelStyle: TextStyle(color: Colors.cyanAccent)
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    autocorrect: false,
                                    obscureText: false,
                                    decoration:  InputDecoration(
                                      labelText: "$_calibratingCurr",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                            SizedBox(
                              width: 10*heightR,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                    height: _height_1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black
                                    ),
                                    child: TextButton(
                                      child:  Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Cell Count:${int.parse(cellcount.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"single_overvoltage",int.parse(cellcount.text));
                                          },
                                        ).show();
                                      },
                                    )
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Battery Capacity:${int.parse(batterycapacity.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"battery_capacity_settings",int.parse(batterycapacity.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                    height: _height_1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black
                                    ),
                                    child: TextButton(
                                      child:  Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.leftSlide,
                                          // headerAnimationLoop: false,
                                          // dialogType: DialogType.error,
                                          // showCloseIcon: true,
                                          title: 'Notification',
                                          desc:
                                          'Thông tin này không được thay đổi!',
                                          btnOkOnPress: () {
                                          },
                                          // btnOkIcon: Icons.cancel,
                                          onDismissCallback: (type) {
                                          },
                                        ).show();
                                      },
                                    )
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          animType: AnimType.leftSlide,
                                          // headerAnimationLoop: false,
                                          // dialogType: DialogType.error,
                                          // showCloseIcon: true,
                                          title: 'Notification',
                                          desc:
                                          'Thông tin này không được thay đổi!',
                                          btnOkOnPress: () {
                                          },
                                          // btnOkIcon: Icons.cancel,
                                          onDismissCallback: (type) {
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                          ],
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300 * heightR,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5*heightR,bottom: 5*heightR),
                        child: Text(
                          "Advance Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent,
                            fontSize: 30*heightR,
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 20*heightR,
                      ),
                      Container(
                        width: 1200*heightR,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cell OVP(mV):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cell OVPR(mV):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cell UVPR(mV):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cell UVP(mV):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cont Charge Curr.(A):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Cont Discharge Curr.(A):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Discharge OCP Delay(S):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Charge OTP(°C):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Discharge OTP(°C):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Charge UTP(°C):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Charge UTPR(°C):"),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  child: Text_title(data:"Start Balance Volt. (mV):"),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                            SizedBox(
                              width: 20*heightR,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_cellOVP",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: cellOVP,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_cellOVPR",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: cellOVPR,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_cellUVPR",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: cellUVPR,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_cellUVP",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: cellUVP,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_continuedChargeCurr",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: continuedChargeCurr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_continuedDischargeCurr",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: continuedDischargeCurr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_dischargeOCPdelay",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: dischargeOCPdelay,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_chargeOTP",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: chargeOTP,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_dischargeOTP",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: dischargeOTP,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_chargeUTP",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: chargeUTP,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_chargeUTPR",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: chargeUTPR,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  width: _widht_1,
                                  height: _height_1,
                                  // color: Colors.red,
                                  child: TextField(
                                    decoration:  InputDecoration(
                                      labelText: "$_startBalanceVolt",
                                      labelStyle: TextStyle(
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    controller: startBalanceVolt,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.cyanAccent),
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                            SizedBox(
                              width: 10*heightR,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Cell OVP:${int.parse(cellOVP.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"single_overvoltage",int.parse(cellOVP.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Cell OVPR:${int.parse(cellOVPR.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"monomer_overvoltage_recovery",int.parse(cellOVPR.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Cell UVPR:${int.parse(cellUVPR.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"discharge_overcurrent_protection_value",int.parse(cellUVPR.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Cell UVP:${int.parse(cellUVP.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"differential_voltage_protection_value",int.parse(cellUVP.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Continued Charge Curr:${int.parse(continuedChargeCurr.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"equalizing_opening_differential",int.parse(continuedChargeCurr.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Continued Discharge Curr:${int.parse(continuedDischargeCurr.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"charging_overcurrent_delay",int.parse(continuedDischargeCurr.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Discharge OCP Delay:${int.parse(dischargeOCPdelay.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"equalizing_starting_voltage",int.parse(dischargeOCPdelay.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Charge OTP:${int.parse(chargeOTP.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"high_temp_protect_bat_charge",chargeOTP.text);
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Discharge OTP:${int.parse(dischargeOTP.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"high_temp_protect_bat_discharge",int.parse(dischargeOTP.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Charge UTP:${int.parse(chargeUTP.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"charge_cryo_protect",int.parse(chargeUTP.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Charge UTPR:${int.parse(chargeUTPR.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"recover_val_charge_cryoprotect",int.parse(chargeUTPR.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                                Container(
                                  height: _height_1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black87
                                  ),
                                  child: TextButton(
                                      onPressed: (){
                                        AwesomeDialog(
                                          context: context,
                                          keyboardAware: true,
                                          dismissOnBackKeyPress: false,
                                          dialogType: DialogType.warning,
                                          animType: AnimType.bottomSlide,
                                          btnCancelText: "No, cancel",
                                          btnOkText: "Yes, continue",
                                          title: 'Continue update!',
                                          // padding: const EdgeInsets.all(5.0),
                                          desc:
                                          'Start Balance Volt:${int.parse(startBalanceVolt.text)}',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            postDataSetting(id,"tube_temp_protection",int.parse(startBalanceVolt.text));
                                          },
                                        ).show();
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      )
                                  ),
                                ),
                                SizedBox(height: 20*heightR,),
                              ],
                            ),
                          ],
                        ),
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



  postDataSetting(final id,final propertyCode, final value) async{
    // print(propertyCode);
    // print(value);
    final dio = Dio();
    try{
      var response_setting = await dio.post(
              "http://smarthome.test.makipos.net:3028/users-control-devices",
          options: Options(
            headers: {
              "Content-type": "application/json",
              "Authorization": token,
            },
          ),
          data: jsonEncode(
          {
          "deviceId": id,
          "propertyCode": propertyCode,
          "localId": "1",
          "data": "$value",
          "waitResponse": false,
          "timeout": 1000
          }
      )
      );
      // print("BodySetting $propertyCode : ${response_setting.statusCode}");
    } catch(e){
      print(e);
    }
  }
}
