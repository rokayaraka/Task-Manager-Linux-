import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';

final diskCmd = "iostat 1";
final diskCmd1 = "df -h";

Map<String,double> diskInfoList = {};
final diskBuilder = StreamProvider<Map<String, double>>((ref)async*{
final result = await Process.start("bash", ["-c",diskCmd]);
await for(var line in result.stdout.transform(SystemEncoding().decoder)){
  final result1 = await Process.run("bash", ["-c",diskCmd1]);
  assignValueonDiskInfoList( line,result1.stdout);
  //print(diskInfoList);
  yield Map<String,double>.from(diskInfoList);

}
});




void assignValueonDiskInfoList(String value , String value1){
try{
  List<String> subList = value.split("\n");
  for(var line in subList){
    if(line.contains("sda")){
      value = line;
      //print(value);

    }
  }
value = value.replaceFirst("sda", "");
value = value.trim();
 subList = value.split(RegExp(r"\s+"));
  double read = double.tryParse(subList[1])?? 0;
  double write = double.tryParse(subList[2])?? 0;
  double throughput = read + write;

  double checkMax = ceilTo(throughput);
  //checkMax > max ? max = checkMax : max = max;
  diskInfoList={
    "read": read,
    "write": write,
    "throughput": throughput,
    "max": checkMax,
  };

  subList= value1.split("\n");
  value = subList[2];
  value = value.trim();
  subList = value.split(RegExp(r"\s+"));
  String size = subList[1].replaceAll(RegExp(r"[a-zA-Z]"), "");
  String used = subList[2].replaceAll(RegExp(r"[a-zA-Z]"), "");
  String avail = subList[3].replaceAll(RegExp(r"[a-zA-Z]"), "");
  diskInfoList["size"]=double.tryParse(size)?? 0;
  diskInfoList["used"]=double.tryParse(used)?? 0;
  diskInfoList["avail"]=double.tryParse(avail)?? 0;
  

}catch(e){
  print(e);
}}
