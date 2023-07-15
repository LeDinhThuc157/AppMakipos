
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void save(var data, var name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(name, data);
}
final dio = Dio();
void get(String id_device) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('Token')!;
    var responseGet_Listdevice = await dio.get(
        "http://smarthome.test.makipos.net:3028/devices/$id_device",
        options: Options(
          headers: {"Authorization": token},
        )
    );
    // print(responseGet_Listdevice);
    Map<String, dynamic> userMap = jsonDecode(responseGet_Listdevice.toString());
    var cells_vol = userMap["propertiesValue"]["cells_vol"];
    save(userMap["status"],"status_device");
    save(cells_vol.toString(), "List_Cell");
    // saveList(userMap["propertiesValue"]["cells_vol"], "cells_vol");
    // bat_vol = userMap["propertiesValue"]["bat_vol"].toString();
    save((userMap["propertiesValue"]["bat_vol"]*0.01).toStringAsFixed(2), "bat_vol");
    // bat_cap = userMap["propertiesValue"]["bat_cap"].toString();
    save(userMap["propertiesValue"]["bat_cap"].toString(), "bat_cap");
    // bat_capacity = userMap["propertiesValue"]["bat_capacity"].toString();
    save(userMap["propertiesValue"]["bat_capacity"].toString(),
        "bat_capacity");
    // bat_temp = userMap["propertiesValue"]["bat_temp"].toString();
    save(userMap["propertiesValue"]["bat_temp"].toString(), "bat_temp");
    // bat_percent = userMap["propertiesValue"]["bat_percent"].toString();
    save(userMap["propertiesValue"]["bat_percent"].toString(), "bat_percent");
    // bat_cycles = userMap["propertiesValue"]["bat_cycles"].toString();
    save(userMap["propertiesValue"]["bat_cycles"].toString(), "bat_cycles");
    // box_temp = userMap["propertiesValue"]["box_temp"].toString();
    save(userMap["propertiesValue"]["box_temp"].toString(), "box_temp");
    // system_working_time = userMap["propertiesValue"]["logger_status"].toString();
    save(userMap["propertiesValue"]["logger_status"].toString(),
        "logger_status");
    save(userMap["propertiesValue"]["tube_temp"].toString(), "tube_temp");

    save(userMap["propertiesValue"]["charging_mos_switch"].toString(),
        "charging_mos_switch");
    // print("Du lieu la: ${userMap["propertiesValue"]["charging_mos_switch"].toString()}");
    save(userMap["propertiesValue"]["discharge_mos_switch"].toString(),
        "discharge_mos_switch");
    save(userMap["propertiesValue"]["uptime"].toString(), "uptime");
    save(userMap["propertiesValue"]["active_equalization_switch"].toString(),
        "active_equalization_switch");
    // charge = userMap["propertiesValue"]["charging_mos_switch"].toString();
    // discharge = userMap["propertiesValue"]["discharge_mos_switch"].toString();
    // balance = userMap["propertiesValue"]["active_equalization_switch"].toString();
    // mos_temp = userMap["propertiesValue"]["tube_temp"].toString();
    // bat_current = (int.parse(userMap["propertiesValue"]["bat_current"].toString()) * 0.01).toString();
    save(
        (int.parse(userMap["propertiesValue"]["bat_current"].toString()) *
            0.01)
            .toString(),
        "bat_current");
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
    save(((max - min) * 0.001).toStringAsFixed(4), "cell_diff");
    // ave_cell = (sum / (cells_vol.length)).toStringAsFixed(2);
    save((sum * 0.001 / (cells_vol.length)).toStringAsFixed(3), "ave_cell");

    // Setting data

    // _cellOVP = userMap["propertiesValue"]["single_overvoltage"].toString();
    save(userMap["propertiesValue"]["single_overvoltage"].toString(),
        "single_overvoltage");
    // _cellOVPR = userMap["propertiesValue"]["monomer_overvoltage_recovery"].toString();
    save(
        userMap["propertiesValue"]["monomer_overvoltage_recovery"].toString(),
        "monomer_overvoltage_recovery");
    // _cellUVPR = userMap["propertiesValue"]["discharge_overcurrent_protection_value"].toString();
    save(
        userMap["propertiesValue"]["discharge_overcurrent_protection_value"]
            .toString(),
        "discharge_overcurrent_protection_value");
    // _cellUVP = userMap["propertiesValue"]["differential_voltage_protection_value"].toString();
    save(
        userMap["propertiesValue"]["differential_voltage_protection_value"]
            .toString(),
        "differential_voltage_protection_value");
    // _continuedChargeCurr = userMap["propertiesValue"]["equalizing_opening_differential"].toString();
    save(
        userMap["propertiesValue"]["equalizing_opening_differential"]
            .toString(),
        "equalizing_opening_differential");
    // _continuedDischargeCurr = userMap["propertiesValue"]["charging_overcurrent_delay"].toString();
    save(userMap["propertiesValue"]["charging_overcurrent_delay"].toString(),
        "charging_overcurrent_delay");
    // _dischargeOCPdelay = userMap["propertiesValue"]["equalizing_starting_voltage"].toString();
    save(userMap["propertiesValue"]["equalizing_starting_voltage"].toString(),
        "equalizing_starting_voltage");
    // _chargeOTP = userMap["propertiesValue"]["high_temp_protect_bat_charge"].toString();
    save(
        userMap["propertiesValue"]["high_temp_protect_bat_charge"].toString(),
        "high_temp_protect_bat_charge");
    // _dischargeOTP = userMap["propertiesValue"]["high_temp_protect_bat_discharge"].toString();
    save(
        userMap["propertiesValue"]["high_temp_protect_bat_discharge"]
            .toString(),
        "high_temp_protect_bat_discharge");
    // _chargeUTP = userMap["propertiesValue"]["charge_cryo_protect"].toString();
    save(userMap["propertiesValue"]["charge_cryo_protect"].toString(),
        "charge_cryo_protect");
    // _chargeUTPR =  userMap["propertiesValue"]["recover_val_charge_cryoprotect"].toString();
    save(
        userMap["propertiesValue"]["recover_val_charge_cryoprotect"]
            .toString(),
        "recover_val_charge_cryoprotect");
    // _startBalanceVolt = userMap["propertiesValue"]["tube_temp_protection"].toString();
    save(userMap["propertiesValue"]["tube_temp_protection"].toString(),
        "tube_temp_protection");
    // _cellcount = userMap["propertiesValue"]["strings_settings"].toString();
    save(userMap["propertiesValue"]["strings_settings"].toString(),
        "strings_settings");
    // _batterycapacity = userMap["propertiesValue"]["battery_capacity_settings"].toString();
    save(userMap["propertiesValue"]["battery_capacity_settings"].toString(),
        "battery_capacity_settings");
  } catch (e) {
    print(e);
  }
  // Boolvalue();
}