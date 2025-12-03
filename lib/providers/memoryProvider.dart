import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoryInfoCmd='''
free -h | awk '/Mem:/ {
  for(i=2;i<=NF;i++) {
    if(\$i ~ /Gi\$/) {
      val = substr(\$i, 1, length(\$i)-2);
      printf "%s ", val;
    } else if(\$i ~ /Mi\$/) {
      val = substr(\$i, 1, length(\$i)-2);
      printf "%.2f ", val/1024;
    }
  }
  print "";
}'
''';

 Map<String,double> memoryInfoList = {};
final memoryBuilder = StreamProvider<Map<String, double>>((ref) async* {
  
  while (true) {
    //print("11");
    final result = await Process.run("bash", ["-c",memoryInfoCmd]);
    //print(result.stdout);
    assignValueOnMemoryInfoList(result.stdout);
    //print("1e3");
    yield Map<String,double>.from(memoryInfoList);
    await Future.delayed(Duration(seconds: 1));
  }
});


void assignValueOnMemoryInfoList(String value){
  List<String> subList = value.split(" ");
  memoryInfoList={
    "total": double.tryParse(subList[0])?? 0,
    "used":double.tryParse(subList[1])?? 0,
    "free":double.tryParse(subList[2])?? 0,
    "shared":double.tryParse(subList[3])?? 0,
    "cache":double.tryParse(subList[4])?? 0,
    "available":double.tryParse(subList[5])?? 0,

  };
}

