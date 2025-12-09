


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oasisathletic/ui/home_screen/Home/mianwrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/regStudentsServices/getRegStd.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        return;
      }

      final result = await Getregstd.getRegStd(
        token: token,
        deviceId: "1",
        DeviceType: 1,
      );

      if (result.data != null && result.data!.isNotEmpty) {
        final studentsJson =
        result.data!.map((e) => e.toJson()).toList();


        prefs.setString("students", jsonEncode(studentsJson));
        print(studentsJson);
        print("Students saved to SharedPreferences");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainWrapper(
            students: result.data ?? [],
            sideMenuList: result.sideMenu ?? [],
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}