import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_user.dart';
import 'home.dart';




void main() async {
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  @override
  Widget build(BuildContext context) {
    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    var curR = widthR;
    Widget example1 = SplashScreenView(
      navigateRoute: SignPage(),
      duration: 5000,
      imageSize: 300,
      imageSrc: "assets/logo_appthuepin.png",
      text: "Loading",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 220*curR,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );

    return MaterialApp(
      home: example1,
      theme: _themeData(Brightness.light),
      darkTheme: _themeData(Brightness.light),
    );
  }
}

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {

  bool showPass = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var id_device = "";
  var name_device = "";

  String? dataname ;
  String? datapass ;
  @override
  void initState(){
    super.initState();
    _GetDataSave();
    // _GetDataSave();
    // _statusCode == null ? 1 : _statusCode;
    // _SaveLogin();
  }
  save(var data, var name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(name, data);
  }
  savebool(var data, var name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, data);
  }
  // Read_() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var counter = prefs.getString('List_Cell');
  //   print('$counter');
  // }

  // Future<String?> _Username() async => dataname = _localStorage['username'];
  // Future<String?> _Password() async => datapass = _localStorage['password'];
  // Future<String?> _Status() async => _statusCode = _localStorage['Status'];



  _GetDataSave() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      dataname = prefs.getString('username');
      datapass = prefs.getString('password');
    setState(() {
      dataname != null ? nameController.text = dataname! : "";
      datapass != null ? passwordController.text = datapass! : "";
    });

  }




  final dio = Dio();
  @override
  Widget build(BuildContext context) {
    double  heightR,widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    var curR = widthR;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding:  EdgeInsets.all(13*curR),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding:  EdgeInsets.only(top: 300*curR,left: 10*curR,right: 10*curR,bottom: 10*curR),
                    // margin: EdgeInsets.only(top: 70 * heightR),
                    child:  Text(
                      'Welcome Back!',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 250 * curR),
                    )),
                Container(
                  // color: Colors.red,
                  height: 400*heightR,
                  padding:  EdgeInsets.all(40*heightR),
                  margin: EdgeInsets.only(bottom: 30*heightR),
                  alignment: Alignment.center,
                  child: Image.asset('assets/logo_appthuepin.png'),
                ),
                Container(
                  padding:  EdgeInsets.fromLTRB(60*widthR, 0, 60*widthR, 10*heightR),
                  child: TextFormField(
                    controller: nameController,
                    decoration:  InputDecoration(
                      labelText: 'Enter your Username',
                    ),
                  ),
                ),
                Container(
                  padding:  EdgeInsets.fromLTRB(60*widthR, 10*heightR, 60*widthR, 0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: "Enter your Password",
                    ),
                    obscureText: !showPass,

                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      //   Navigator.push(context, MaterialPageRoute(
                      //     builder: (context) => LineChartSample1(),
                      //   )
                      //   );
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.leftSlide,
                        headerAnimationLoop: false,
                        dialogType: DialogType.error,
                        showCloseIcon: true,
                        title: 'Notification',
                        desc:
                        'Vui lòng liên hệ với quản trị viên để lấy lại mật khẩu!',
                        btnOkOnPress: () {
                        },
                        btnOkIcon: Icons.cancel,
                        onDismissCallback: (type) {
                        },
                      ).show();
                    },
                    child:  Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 120*curR,
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 100*heightR,
                    margin: EdgeInsets.only(top: 20*heightR),
                    padding:  EdgeInsets.fromLTRB(60*widthR, 0, 60*widthR, 0),
                    child: ElevatedButton(
                      child:  Text(
                        'Login',
                        style: TextStyle(fontSize: 180*curR),
                      ),
                      onPressed: () {
                        setState(() {
                          _SaveLogin();
                        }
                        );

                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 200*widthR),
                      child: Text('Do not have an account?',
                        style: TextStyle(
                          fontSize: 120*curR,
                        ),),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 170*widthR),
                        child: TextButton(
                          child:  Text(
                            'Sign up',
                            style: TextStyle(fontSize: 120*curR),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CreateUser(),
                            ));
                          },
                        )
                    ),
                  ],
                ),
              ],
            ))
    );
  }
  _SaveLogin() async {
    try{
      print("name: ${nameController.text} \n");
      print("pass: ${passwordController.text}\n");
      var response_user_login = await dio.post(
              "http://smarthome.test.makipos.net:3028/users-service/users/authentication?_v=1",
          options: Options(
            headers: {
              "Content-type": "application/json; charset=utf-8",
            },
          ),
          data: jsonEncode({
            "authCode": false,
            "strategy": "local",
            "username": "${nameController.text}",
            "password": "${passwordController.text}"
          })
      );
      Map<String, dynamic> userMap = jsonDecode(response_user_login.toString());
      var token = userMap["accessToken"];
      var roles = userMap['roles'];
      var bool_admin = false;
      for(int i =0; i <roles.length;i++){
        print(roles[i]);
        if(roles[i] == 'adminPartner'){
          bool_admin = true;
          break;
        }
      }
      print("Status: ${roles.runtimeType} \n ${bool_admin}");

      if(response_user_login.statusCode == 201){
        savebool(bool_admin,'bool_admin');
        save(nameController.text,'username');
        save(passwordController.text,'password');
        save(token, "Token");
        print("$token");
        get_device(token);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Home(),
        ));
        print("Status: ${response_user_login.statusCode}");
      }
    } catch (e) {
      var x = e.toString();
      print("Error ${x.substring(x.length-4,x.length-1)}");
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        showCloseIcon: true,
        title: 'Đang nhập thất bại',
        desc:
        'Error: ${x.substring(x.length-4,x.length-1)}\nKiểm tra lại thông tin đăng nhập của bạn!',
        btnOkOnPress: () {
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
        },
      ).show();
    }
  }
  get_device(var token) async {
    print("get_device");
    try{
      var Get_Listdevice = await dio.get("http://smarthome.test.makipos.net:3028/devices",
        options: Options(
          headers: {"Authorization": token},
        ),
      );
      Map<String, dynamic> userMap = jsonDecode(Get_Listdevice.toString());
      id_device = userMap["data"][0]["_id"].toString();
      save(id_device,"Id_device");
      name_device = userMap["data"][0]["productId"].toString();
      save(name_device, "Name_device");
      getData(token);
      print("end_device");
    }catch(e){
      print(e);
    }
  }
  getData(var token) async {
    try {
      print("Get_data");
      var responseGet_Listdevice = await dio.get(
        "http://smarthome.test.makipos.net:3028/devices/$id_device",
        options: Options(
          headers: {"Authorization": token},
        )
      );
      Map<String, dynamic> userMap = jsonDecode(responseGet_Listdevice.toString());
      save(userMap["status"],"status_device");
      var cells_vol = userMap["propertiesValue"]["cells_vol"];
      save(cells_vol.toString(), "List_Cell");
      // saveList(userMap["propertiesValue"]["cells_vol"], "cells_vol");
      // bat_vol = userMap["propertiesValue"]["bat_vol"].toString();
      save((userMap["propertiesValue"]["bat_vol"]*0.01).toStringAsFixed(2), "bat_vol");
      // bat_cap = userMap["propertiesValue"]["bat_cap"].toString();
      save(userMap["propertiesValue"]["bat_cap"].toString(), "bat_cap");
      // bat_capacity = userMap["propertiesValue"]["bat_capacity"].toString();
      save(userMap["propertiesValue"]["bat_capacity"].toString(), "bat_capacity");
      // bat_temp = userMap["propertiesValue"]["bat_temp"].toString();
      save(userMap["propertiesValue"]["bat_temp"].toString(), "bat_temp");
      // bat_percent = userMap["propertiesValue"]["bat_percent"].toString();
      save(userMap["propertiesValue"]["bat_percent"].toString(), "bat_percent");
      // bat_cycles = userMap["propertiesValue"]["bat_cycles"].toString();
      save(userMap["propertiesValue"]["bat_cycles"].toString(), "bat_cycles");
      // box_temp = userMap["propertiesValue"]["box_temp"].toString();
      save(userMap["propertiesValue"]["box_temp"].toString(), "box_temp");
      // system_working_time = userMap["propertiesValue"]["logger_status"].toString();
      save(userMap["propertiesValue"]["logger_status"].toString(), "logger_status");
      save(userMap["propertiesValue"]["tube_temp"].toString(), "tube_temp");
      save(userMap["propertiesValue"]["uptime"].toString(), "uptime");
      save(userMap["propertiesValue"]["charging_mos_switch"].toString(), "charging_mos_switch");
      save(userMap["propertiesValue"]["discharge_mos_switch"].toString(), "discharge_mos_switch");
      save(userMap["propertiesValue"]["active_equalization_switch"].toString(), "active_equalization_switch");
      // charge = userMap["propertiesValue"]["charging_mos_switch"].toString();
      // discharge = userMap["propertiesValue"]["discharge_mos_switch"].toString();
      // balance = userMap["propertiesValue"]["active_equalization_switch"].toString();
      // mos_temp = userMap["propertiesValue"]["tube_temp"].toString();
      // bat_current = (int.parse(userMap["propertiesValue"]["bat_current"].toString()) * 0.01).toString();
      save((int.parse(userMap["propertiesValue"]["bat_current"].toString()) * 0.01).toString(), "bat_current");
      var min = cells_vol[0];
      var max = cells_vol[0];
      var sum = cells_vol.reduce((value, current) => value + current);
      for (var i = 0; i < cells_vol.length; i++) {
        // Calculate sum
        // sum += cells_vol[i];
        // Checking for largest value in the list
        if (cells_vol[i] > max) {
          max = cells_vol[i];
        }
        // Checking for smallest value in the list
        if (cells_vol[i] < min) {
          min = cells_vol[i];
        }
      }
      // cell_diff = ((max - min)*0.001).toStringAsFixed(4);
      save(((max - min)*0.001).toStringAsFixed(4), "cell_diff");
      // ave_cell = (sum / (cells_vol.length)).toStringAsFixed(2);
      save((sum * 0.001 / (cells_vol.length)).toStringAsFixed(3), "ave_cell");

      // Setting data

      // _cellOVP = userMap["propertiesValue"]["single_overvoltage"].toString();
      save(userMap["propertiesValue"]["single_overvoltage"].toString(), "single_overvoltage");
      // _cellOVPR = userMap["propertiesValue"]["monomer_overvoltage_recovery"].toString();
      save(userMap["propertiesValue"]["monomer_overvoltage_recovery"].toString(), "monomer_overvoltage_recovery");
      // _cellUVPR = userMap["propertiesValue"]["discharge_overcurrent_protection_value"].toString();
      save(userMap["propertiesValue"]["discharge_overcurrent_protection_value"].toString(), "discharge_overcurrent_protection_value");
      // _cellUVP = userMap["propertiesValue"]["differential_voltage_protection_value"].toString();
      save(userMap["propertiesValue"]["differential_voltage_protection_value"].toString(), "differential_voltage_protection_value");
      // _continuedChargeCurr = userMap["propertiesValue"]["equalizing_opening_differential"].toString();
      save(userMap["propertiesValue"]["equalizing_opening_differential"].toString(), "equalizing_opening_differential");
      // _continuedDischargeCurr = userMap["propertiesValue"]["charging_overcurrent_delay"].toString();
      save(userMap["propertiesValue"]["charging_overcurrent_delay"].toString(), "charging_overcurrent_delay");
      // _dischargeOCPdelay = userMap["propertiesValue"]["equalizing_starting_voltage"].toString();
      save(userMap["propertiesValue"]["equalizing_starting_voltage"].toString(), "equalizing_starting_voltage");
      // _chargeOTP = userMap["propertiesValue"]["high_temp_protect_bat_charge"].toString();
      save(userMap["propertiesValue"]["high_temp_protect_bat_charge"].toString(), "high_temp_protect_bat_charge");
      // _dischargeOTP = userMap["propertiesValue"]["high_temp_protect_bat_discharge"].toString();
      save(userMap["propertiesValue"]["high_temp_protect_bat_discharge"].toString(), "high_temp_protect_bat_discharge");
      // _chargeUTP = userMap["propertiesValue"]["charge_cryo_protect"].toString();
      save(userMap["propertiesValue"]["charge_cryo_protect"].toString(), "charge_cryo_protect");
      // _chargeUTPR =  userMap["propertiesValue"]["recover_val_charge_cryoprotect"].toString();
      save(userMap["propertiesValue"]["recover_val_charge_cryoprotect"].toString(), "recover_val_charge_cryoprotect");
      // _startBalanceVolt = userMap["propertiesValue"]["tube_temp_protection"].toString();
      save(userMap["propertiesValue"]["tube_temp_protection"].toString(), "tube_temp_protection");
      // _cellcount = userMap["propertiesValue"]["strings_settings"].toString();
      save(userMap["propertiesValue"]["strings_settings"].toString(), "strings_settings");
      // _batterycapacity = userMap["propertiesValue"]["battery_capacity_settings"].toString();
      save(userMap["propertiesValue"]["battery_capacity_settings"].toString(), "battery_capacity_settings");
      print("end_data");
    } catch (e) {
      print(e);
    }
    // Boolvalue();

  }

}
ThemeData _themeData(Brightness brightness) {
  return ThemeData(
    fontFamily: "Poppins",
    brightness: brightness,
    // Matches app icon color.
    primarySwatch:  MaterialColor(0xFF4D8CFE, <int, Color>{
      50: Color(0xFFEAF1FF),
      100: Color(0xFFCADDFF),
      200: Color(0xFFA6C6FF),
      300: Color(0xFF82AFFE),
      400: Color(0xFF689DFE),
      500: Color(0xFF4D8CFE),
      600: Color(0xFF4684FE),
      700: Color(0xFF3D79FE),
      800: Color(0xFF346FFE),
      900: Color(0xFF255CFD),
    }),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      errorStyle: TextStyle(height: 0.75),
      helperStyle: TextStyle(height: 0.75),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(40),
    )),
    scaffoldBackgroundColor: brightness == Brightness.dark
        ? Colors.black
        : null,
    cardColor: brightness == Brightness.dark
        ? Color.fromARGB(255, 28, 28, 30)
        : null,
    dialogTheme: DialogTheme(
      backgroundColor: brightness == Brightness.dark
          ? Color.fromARGB(255, 28, 28, 30)
          : null,
    ),
    highlightColor: brightness == Brightness.dark
        ? Color.fromARGB(255, 44, 44, 46)
        : null,
    splashFactory: NoSplash.splashFactory,
  );
}

