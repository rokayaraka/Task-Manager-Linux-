//import 'dart:io';
import 'dart:math';

import 'package:riverpod/legacy.dart';
//import 'package:riverpod/riverpod.dart';


//Button selection (CPU , RAM, Network) provider. returns a string
final selectProvider = StateProvider<String>((ref) => "CPU");


double ceilTo(double value) {
  if (value <= 0) return 100;
  int length = value.ceil().toString().length;
  double ceilValue = pow(10, length).toDouble();
  return ceilValue;
}


