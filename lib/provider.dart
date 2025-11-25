import 'dart:io';

import 'package:riverpod/riverpod.dart';

final cpuInfoCmd = 'top -bn1 | grep "Cpu(s)"';

Map<String,double> cpuInfoList = {};

void assignValueOnCpuInfoList(String values){
  values=values.replaceFirst("%Cpu(s): ","");
  print(values);
  String unitValues = values.replaceAll(RegExp(r"[0-9.\s]"), "");
  print(unitValues);
  values= values.replaceAll(RegExp(r"[a-zA-Z]"), ""); print(values);
  values = values.replaceAll(" ", ""); print(values);

List<String> subList = values.split(",");
List<String> subListUnit = unitValues.split(",");

for(var i =0 ; i<subList.length;i++){
cpuInfoList[subListUnit[i] ]= double.tryParse(subList[i])!;
}
}

final cpuBuilder = StreamProvider<Map<String,double>>((ref)async*{
  while(true){
    ProcessResult result = await Process.run("bash",["-c",cpuInfoCmd]);
    assignValueOnCpuInfoList(result.stdout);
    print(cpuInfoList);
    yield Map<String,double>.from(cpuInfoList);
    await Future.delayed(Duration(seconds: 1));
  }
}

);
