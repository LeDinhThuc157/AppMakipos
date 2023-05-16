import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Home extends StatefulWidget {
  const Home({Key ? key,});

  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{



  MQTT() async {
    final client = MqttServerClient('ws://smarthome.test.makipos.net:8083/mqtt', 'BMS_admin');
    client.port = 8083;
    client.useWebSocket = true;
    client.logging(on: false);

    // Đăng nhập với tên người dùng và mật khẩu
    client.setProtocolV311();
    client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;

    try {
      await client.connect('BMS_admin','01012023');
      print('EXAMPLE::Subscribing to the test/lol topic');
      client.subscribe('d/bms_device_test_2/p/UP/#', MqttQos.atLeastOnce);
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
      var data_1 = jsonDecode(payload);
      print(data_1);

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
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
      height: 100,
            color: Colors.black26,
            child: TextButton(

              onPressed: () {
    MQTT();
    },
              child: Container(

                  child: Text("Click"),
    ),
              ),
            )
        ],
      )
    );
  }

}
