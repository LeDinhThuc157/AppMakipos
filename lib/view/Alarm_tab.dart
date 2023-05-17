
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../widgets/custom_appbar.dart';

class  AlarmPage extends StatefulWidget {
  AlarmPage({Key ? key, required this.list_warning,required this.list_time,}):super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
  var list_warning;
  var list_time;
}

class _AlarmPageState extends State<AlarmPage>{
  @override
  Widget build(BuildContext context) {
    double heightR, widthR;
    heightR = MediaQuery.of(context).size.height / 1080; //v26
    widthR = MediaQuery.of(context).size.width / 2400;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomAppbar(),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white60,
        child: DrawerPage(),
      ),
      body: ListView.builder(
        itemCount: widget.list_warning.length,
        itemBuilder: (context, index) {
          return  Column(
            children: [
              SizedBox(
                height: 10*heightR,
              ),
              Container(
                height: 70*heightR,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(widget.list_time[index],
                      style: TextStyle(
                        fontSize: 18 * heightR,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(
                      width: 250*heightR,
                      child: Container(
                        child: Text(widget.list_warning[index],
                          style: TextStyle(
                            fontSize: 24 * heightR,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

}