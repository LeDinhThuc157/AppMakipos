import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makipos/main.dart';
import 'package:makipos/method/method_http.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../widgets/bottombar_item.dart';
import '../theme/colors.dart';
import 'Alarm_tab.dart';
import 'ControlPage.dart';
import 'SettingsPage.dart';
import 'StatusPage.dart';


class Home extends StatefulWidget {
  const Home({Key ? key,});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activeTab = 0;
  bool bool_admin = false;
  @override
  Widget build(BuildContext context) {
    // print("Home Token: $_token");
    // print("Token user login: ${widget._token.toString()}");
    return Container(
      decoration: BoxDecoration(
        color: appBgColor.withOpacity(.95),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40)
        ),
      ),

      child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: getBottomBar(),
          // Nếu có floatingActionButton thì không các button sẽ bị vo hiệu hóa không hoạt động.
          // floatingActionButton: getHomeButton(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          body: getBarPage()
      ),
    );
  }
  Widget getHomeButton(){
    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    var curR = widthR;
    return Container(
      margin: EdgeInsets.only(top: 28*heightR),
      // padding: EdgeInsets.all(30*heightR),
      child: GestureDetector(
        onTap: () {
          // activeTab = 0;
          setState(() {
            activeTab = 0;
          });
        },
      ),
    );
  }
  call_bool_admin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool_admin = prefs.getBool('bool_admin')!;
    // print('$bool_admin' '\n' 'Check first');
  }
  save(var data, var name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, data);
  }

  @override
  void initState() {
    super.initState();
    call_bool_admin();
    Get_Data();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Khi màn hình hiện tại đã được xây dựng
      // Đăng ký lắng nghe sự kiện chuyển màn hình
      final timerState = Provider.of<TimerState>(context, listen: false);
      timerState.addListener(() {
        if (!timerState.timerActive) {
          print("Dung 2");
          _stopTimer(); // Dừng Timer khi trạng thái thay đổi
        }
      });
    });

  }
  var _timer;
  void Get_Data() {
    _timer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (mounted) { // Kiểm tra nếu widget vẫn còn mounted (không bị hủy)
        // Gọi hàm postDataControl() và save() ở đây
        String id_device = prefs.getString('Id_device')!;
        get(id_device);
        print("Call api \n  ${DateTime.now()}");
      }
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel(); // Hủy Timer
      _timer = null;
      print("Huy Timer khi thoat");
    }
  }

  Widget getBottomBar() {

    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    var curR = widthR;

    return StreamBuilder(
      stream: Stream.periodic(Duration(milliseconds: 100)),
      builder: (context, snapshot) => Container(
        height: 100*heightR,
        width: double.infinity,
        decoration: BoxDecoration(
            color: mainColor,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(25),
            //   topRight: Radius.circular(25)
            // ),
            boxShadow: [
              BoxShadow(
                  color: mainColor.withOpacity(0.1),
                  blurRadius: .5,
                  spreadRadius: .5,
                  offset: Offset(0, 1)
              )
            ]
        ),
        child: Padding(
            padding:  EdgeInsets.only(top:15*heightR,left: 125*widthR, right: 125*widthR),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BottomBarItem(
                    Icons.desktop_mac_outlined,
                    "STATUS",
                    isActive: activeTab == 0,
                    activeColor: secondary,
                    onTap: () {
                      setState(() {
                        activeTab = 0;
                      });
                    },
                  ),
                  bool_admin ? BottomBarItem(
                    Icons.settings,
                    "SETTINGS",
                    isActive: activeTab == 1,
                    activeColor: secondary,
                    onTap: () {
                      setState(() {
                        activeTab = 1;
                      });
                    },
                  ) : Column(
                    children: [

                      new Icon(Icons.settings, size: 54*heightR, color: secondary.withOpacity(.4),),
                      Text("SETTINGS", style: TextStyle(fontSize: 22*heightR, color: red_alarm.withOpacity(.5))),
                    ],
                  ),
                  bool_admin ? BottomBarItem(
                    Icons.swap_horiz,
                    "CONTROL",
                    isActive: activeTab == 2,
                    activeColor: secondary,
                    onTap: () {
                      setState(() {
                        activeTab = 2;
                      });
                    },
                  ) : Column(
                    children: [

                      new Icon(Icons.swap_horiz, size: 54*heightR, color: secondary.withOpacity(.4),),
                      Text("CONTROL", style: TextStyle(fontSize: 22*heightR, color: red_alarm.withOpacity(.5))),
                    ],
                  ),
                  BottomBarItem(
                    Icons.notification_important_outlined,
                    "ALARM",
                    isActive: activeTab == 3,
                    activeColor: secondary,
                    onTap: () {
                      setState(() {
                        activeTab = 3;
                      });
                    },
                  )
                ]
            )
        ),

      ),);
  }


  var getdata;
  var time,limit,skip;


  var list_warning=[];
  var list_time = [];
  var list_warning_1=[];
  var list_time_1 = [] ;

  get_list_warning() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('Token');
    var id_device = prefs.getString('Id_device');
    try {
      list_warning_1 = [];
      list_time_1 = [];
      list_warning = [];
      list_time = [];
      final dio = Dio();
      Map<String, String> qParams = {
        'deviceId': '$id_device',
        '\$sort[time]': '-1',
        '\$limit': '200',
        'eventType': 'UPDATE_PROPERTY',
        '\$skip': '0',
      };
      var responseGet_Listdevice = await dio.get(
          "http://smarthome.test.makipos.net:3028/devices-events",
          options: Options(
            headers: {"Authorization": token},
          ),
          queryParameters: qParams
      );
      Map<String, dynamic> userMap = jsonDecode(responseGet_Listdevice.toString());
      getdata = userMap;
      int i = 0;
      while( i != 200){
        var warning = getdata['data'][i]["eventDescription"]["propertyCode"];
        if(warning == "warning" || warning == "Warning"){
          if(getdata['data'][i]["eventDescription"]["data"] != "NORMAL"){
            var data_pc = getdata['data'][i]["eventDescription"]["data"];
            list_warning_1.add(data_pc);
            var time = getdata['data'][i]['time'];
            var day_sub = time.substring(0, 10);
            var clock_sub = time.substring(11,19);
            list_time_1.add( clock_sub+ "  " + day_sub);
          }
        }
        i++;
      }
      for (int i = 0; i < list_warning_1.length; i++) {
        if (i == list_warning_1.length - 1 || list_warning_1[i] != list_warning_1[i + 1]) {
          list_warning.add(list_warning_1[i]);
          list_time.add(list_time_1[i]);
        }
      }
    } catch (e) {
      print(e);
    }

  }


  Widget getBarPage() {
    return IndexedStack(
      index: activeTab,
      children: <Widget>[
        StatusPage(),
        SettingsPage(),
        ControlPage(),
        activeTab != 3 ? AlarmPage(list_warning: list_warning, list_time: list_time,) :
        StreamBuilder(
            stream: Stream.periodic(Duration(seconds: 1)).asyncMap((event) => get_list_warning()).take(1),
            builder: (context, snapshot) => AlarmPage(list_warning: list_warning, list_time: list_time,)
        ),

      ],
    );
  }
}
