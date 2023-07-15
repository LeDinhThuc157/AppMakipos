
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:makipos/main.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_appbar.dart';

class  ControlPage extends StatefulWidget {
  ControlPage({Key? key,}): super(key: key);
  @override
  State<ControlPage> createState() => _ControlPageState();

}

class _ControlPageState extends State<ControlPage> {
  var user,password;
  var name_device;
  var token;
  //
  var id;
  var isOn_charge ;
  var isOn_discharge ;
  var charge;
  var discharge;
  // var checkct = false;
  var data_1;
  var isOn_charge_mqtt = false;
  var isOn_discharge_mqtt = false ;
  var check_1 = false,check_2 = false;

  final dio = Dio();

  _Read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    charge = prefs.getString('charging_mos_switch');
    discharge = prefs.getString('discharge_mos_switch');
    user = prefs.getString('username');
    name_device = prefs.getString('Name_device');
    id = prefs.getString('Id_device');
    token = prefs.getString('Token');
    password = prefs.getString('password');
    // _SoSanh();
    // print("charge: $charge \n discharge: $discharge");
    _Check_value();

  }
  save(var data, var name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, data);
  }
   _SoSanh() async {
    try{
      var responseGet_Listdevice = await dio.get(
        "http://smarthome.test.makipos.net:3028/devices/$id",
        options: Options(
          headers: {"Authorization": token},
        )
      );
      Map<String, dynamic> userMap = jsonDecode(responseGet_Listdevice.toString());
      if(userMap["propertiesValue"]["charging_mos_switch"].toString() != charge){
        save(userMap["propertiesValue"]["charging_mos_switch"].toString(), "charging_mos_switch");
        charge = userMap["propertiesValue"]["charging_mos_switch"].toString();
      }
      if(userMap["propertiesValue"]["discharge_mos_switch"].toString() != discharge){
        save(userMap["propertiesValue"]["discharge_mos_switch"].toString(), "discharge_mos_switch");
        discharge = userMap["propertiesValue"]["discharge_mos_switch"].toString();
      }
    }catch(e){
    }
  }
  void _Check_value(){
    if(charge == "1"){
      check_1 ? isOn_charge_mqtt = true : isOn_charge = true;
    }
    if(charge == "0"){
      check_1 ? isOn_charge_mqtt = false : isOn_charge = false;
    }
    if(discharge == "1"){
      check_2 ? isOn_discharge_mqtt = true : isOn_discharge = true;
    }
    if(discharge == "0"){
      check_2 ? isOn_discharge_mqtt = false : isOn_discharge = false;
    }
  }
  MQTT(String device) async {
    final client = MqttServerClient('ws://smarthome.test.makipos.net:8083/mqtt', '${user}');
    client.port = 8083;
    client.useWebSocket = true;
    client.logging(on: false);

    // Đăng nhập với tên người dùng và mật khẩu
    client.setProtocolV311();
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    try {
      await client.connect(user,password);
      print('EXAMPLE::Subscribing to the test/lol topic');
      client.subscribe('d/$device/p/UP/#', MqttQos.atLeastOnce);
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);
      data_1 = jsonDecode(payload);
      print("Payload: $payload");
      print("Data: $data_1");
      print("$data_1 \n ${data_1["pc"].toString()} \n ${data_1["d"].toString()}");
      if(data_1["pc"].toString() == 'charging_mos_switch' && data_1 != null){
        check_1 = true;
        if(data_1["d"].toString() == '0'){
          isOn_charge_mqtt = false;
          // print("charging_mos_switch: ${isOn_charge_mqtt}");
        }
        if(data_1["d"].toString() == '1'){
          isOn_charge_mqtt = true;
          // print("charging_mos_switch: ${isOn_charge_mqtt}");

        }
        save(data_1['d'].toString(), "charging_mos_switch");
        setState(() {

        });
      }
      if(data_1["pc"].toString() == 'discharge_mos_switch' && data_1!=null){
        check_2 = true;
        if(data_1["d"].toString() == '0'){
          isOn_discharge_mqtt = false;
          // print("discharge_mos_switch: ${isOn_discharge_mqtt}");
        }
        if(data_1["d"].toString() == '1'){
          isOn_discharge_mqtt = true;
          // print("discharge_mos_switch: ${isOn_discharge_mqtt}");
        }
        save(data_1['d'].toString(), "discharge_mos_switch");
        setState(() {

        });
      }

    });
    // client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    //   final recMess = c![0].payload as MqttPublishMessage;
    //   final pt =
    //   MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    //   print(
    //       'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    //   print('');
    // });
  }
   var _timer1;
  var _timer2;

  @override
  void initState() {
    super.initState();
    _Read();
    MQTT("${name_device}");
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Khi màn hình hiện tại đã được xây dựng
      // Đăng ký lắng nghe sự kiện chuyển màn hình
      final timerState = Provider.of<TimerState>(context, listen: false);
      timerState.addListener(() {
        if (!timerState.timerActive) {
          print("Dung");
          _stopTimer(); // Dừng Timer khi trạng thái thay đổi
        }
      });
    });

  }

  @override
  void dispose() {
    _stopTimer(); // Gọi hàm dừng Timer trong hàm dispose()
    super.dispose();
  }

  void startTimer_charge(final id,final propertyCode,bool _check) {
    _timer1 = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (mounted) { // Kiểm tra nếu widget vẫn còn mounted (không bị hủy)
        // Gọi hàm postDataControl() và save() ở đây
        print("Hoat dong đi nha charge");
        postDataControl(id, propertyCode, _check);
        save(!_check ? "0" : "1", propertyCode);
      }
      print("${DateTime.now()} Time1");
    });
  }
  void startTimer_discharge(final id,final propertyCode,bool _check) {
    _timer2 = Timer.periodic(Duration(seconds: 10), (Timer t) {
      if (mounted) { // Kiểm tra nếu widget vẫn còn mounted (không bị hủy)
        // Gọi hàm postDataControl() và save() ở đây
        print("Hoat dong đi nha discharge");
        postDataControl(id, propertyCode, _check);
        save(!_check ? "0" : "1", propertyCode);
      }
      print("${DateTime.now()} Time2");
    });
  }
  void _stopTimer() {
    if (_timer1 != null) {
      _timer1.cancel(); // Hủy Timer
      _timer1 = null;
      print("Huy Timer");
    }
    if (_timer2 != null) {
      _timer2.cancel(); // Hủy Timer
      _timer2 = null;
      print("Huy Timer");
    }

  }


  Widget build(BuildContext context) {

    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomAppbar(),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: Colors.white60,
        child: DrawerPage(),
      ),
      body: StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 5)).asyncMap((event) => _Read()),
          builder: (context, snapshot) => charge == null ? Center(
            child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ),
          ) : Column(
            children: [
          //     Container(
          //       child: Center(
          //         child: Container(
          //           decoration: BoxDecoration(
          //               color: Colors.white,
          //             border: Border.all(
          //               color: Colors.black12,
          //               width: 4*heightR,
          //             ),
          //             boxShadow: [ //BoxShadow
          //               BoxShadow(
          //                 color: Colors.white,
          //                 offset: const Offset(0.0, 0.0),
          //                 blurRadius: 0.0,
          //                 spreadRadius: 0.0,
          //               ), //BoxShadow
          //             ],
          // ),
          //           child: TextButton(
          //             onPressed: (){
          //               setState(() {
          //                 _SoSanh();
          //               });
          //               AwesomeDialog(
          //                 context: context,
          //                 animType: AnimType.leftSlide,
          //                 headerAnimationLoop: false,
          //                 dialogType: DialogType.success,
          //                 showCloseIcon: true,
          //                 title: 'Update Complete',
          //                 btnOkOnPress: () {
          //                 },
          //                 btnOkIcon: Icons.check_circle,
          //               ).show();
          //             },
          //             child: Text("Update",style: TextStyle(
          //               fontSize: 26*heightR
          //             ),),
          //           ),
          //         ),
          //       ),
          //     ),
              Container(
                height: 100*heightR,
                child: check_1 ? Center(
                    child: SwitchListTile(
                        title: Row(
                          children: [
                            SizedBox(
                              width: 15*heightR,
                            ),
                            Icon(Icons.battery_charging_full),
                            SizedBox(
                              width: 35*heightR,
                            ),
                            Text('Charge'),
                          ],
                        ),
                        activeColor: Colors.teal,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.blueGrey,
                        value: isOn_charge_mqtt,
                        onChanged: (bool value) {
                          setState(() {
                            isOn_charge_mqtt = value;
                            startTimer_charge(id,"charging_mos_switch",isOn_charge_mqtt);
                          });
                        }
                    )
                ):Center(
                    child: SwitchListTile(
                        title: Row(
                          children: [
                            SizedBox(
                              width: 15*heightR,
                            ),
                            Icon(Icons.battery_charging_full),
                            SizedBox(
                              width: 35*heightR,
                            ),
                            Text('Charge'),
                          ],
                        ),
                        activeColor: Colors.teal,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.blueGrey,
                        value: isOn_charge,
                        onChanged: (bool value) {
                          setState(() {
                            isOn_charge = value;
                            startTimer_charge(id,"charging_mos_switch",isOn_charge);

                            // postDataControl(id, "charging_mos_switch", isOn_charge);
                            // save(!isOn_charge ? "0" : "1", "charging_mos_switch");
                          });
                        }
                    )
                ),
              ),
              Container(
                height: 100*heightR,
                child: check_2 ? Center(
                    child: SwitchListTile(
                        title: Row(
                          children: [
                            SizedBox(
                                width: 15*heightR
                            ),
                            Icon(Icons.battery_saver),
                            SizedBox(
                                width: 35*heightR
                            ),
                            Text('Discharge'),
                          ],
                        ),
                        activeColor: Colors.teal,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.blueGrey,
                        value: isOn_discharge_mqtt,
                        onChanged: (bool value) {
                          setState(() {
                            isOn_discharge_mqtt = value;
                            startTimer_discharge(id,"discharge_mos_switch",isOn_discharge_mqtt);
                          });
                        }
                    )
                ) : Center(
                    child: SwitchListTile(
                        title: Row(
                          children: [
                            SizedBox(
                                width: 15*heightR
                            ),
                            Icon(Icons.battery_saver),
                            SizedBox(
                                width: 35*heightR
                            ),
                            Text('Discharge'),
                          ],
                        ),
                        activeColor: Colors.teal,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.black,
                        inactiveTrackColor: Colors.blueGrey,
                        value: isOn_discharge,
                        onChanged: (bool value) {
                          setState(() {
                            isOn_discharge = value;
                            startTimer_discharge(id,"discharge_mos_switch",isOn_discharge);
                          });
                        }
                    )
                ),
              ),
              Container(
                height: 100*heightR,
                child: Center(
                  child: Text("Version 1.0.0"),
                )
              ),

            ],
          )
      ),
    );
  }
postDataControl(final id,final propertyCode,bool _check) async{

  try{
    var response_control = await dio.post(
            "http://smarthome.test.makipos.net:3028/users-control-devices",
        options: Options(
          headers: {
            "Content-type": "application/json",
            "Authorization": token
          },
        ),
        data: jsonEncode(
            {
              "deviceId": id,
              "propertyCode": propertyCode,
              "localId": "1",
              "data": !_check ? 0 : 1,
              "waitResponse": false,
              "timeout": 5000
            }
        )
    );

  } catch(e){
    print(e);
  }
}

}





