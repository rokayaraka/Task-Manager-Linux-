import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/Screen/HomeScreen.dart';
import 'package:task_manager/constant.dart';

class Flushscreen extends ConsumerStatefulWidget {
  const Flushscreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FlushscreenState();
}

class _FlushscreenState extends ConsumerState<Flushscreen> {
 @override
  void initState() {
  
    super.initState();
    Timer(Duration(seconds: 5),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>Home()));
    });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: CircleAvatar(
            radius: 150,
            backgroundColor: logoBg,
            child: Image.asset("assets/icons.png", scale: 1),
          ),
        ),
      ),
    );
  }
}