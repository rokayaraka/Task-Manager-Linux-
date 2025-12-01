import 'dart:io';
import 'dart:math';

import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final cpuInfoCmd = 'top -bn1 | grep "Cpu(s)"';

Map<String, double> cpuInfoList = {};

void assignValueOnCpuInfoList(String values) {
  values = values.replaceFirst("%Cpu(s): ", "");

  String unitValues = values.replaceAll(RegExp(r"[0-9.\s]"), "");

  values = values.replaceAll(RegExp(r"[a-zA-Z]"), "");
  values = values.replaceAll(" ", "");

  List<String> subList = values.split(",");
  List<String> subListUnit = unitValues.split(",");

  for (var i = 0; i < subList.length; i++) {
    cpuInfoList[subListUnit[i]] = double.tryParse(subList[i])!;
  }
}

final cpuBuilder = StreamProvider<Map<String, double>>((ref) async* {
  while (true) {
    ProcessResult result = await Process.run("bash", ["-c", cpuInfoCmd]);
    assignValueOnCpuInfoList(result.stdout);

    yield Map<String, double>.from(cpuInfoList);
    await Future.delayed(Duration(seconds: 1));
  }
});

final cpuInfoProvider = FutureProvider((ref) async {
  final file = File("/proc/cpuinfo");
  final lines = await file.readAsLines();

  List<Map<String, String>> cpus = [];
  Map<String, String> cpu = {};
  for (var line in lines) {
    if (line.trim().isEmpty) {
      if (cpu.isNotEmpty) {
        cpus.add(Map.from(cpu));
        cpu.clear();
      }
    } else {
      var parts = line.split(":");
      if (parts.length == 2) {
        cpu[parts[0].trim()] = parts[1].trim();
      }
    }
  }

  if (cpu.isNotEmpty) {
    cpus.add(cpu);
  }
  return cpus[0];
});

//Button selection (CPU , RAM, Network) provider. returns a string
final selectProvider = StateProvider<String>((ref) => "CPU");

//Network Data Provider. Returns a map
final networkBuilder = StreamProvider<Map<String, double>>((ref) async* {
  final result = await Process.start("ifstat", ["-i", "enp0s3", "1"]);
  int i = 2;
  double max = 100;

  await for (var line in result.stdout.transform(SystemEncoding().decoder)) {
    if (i > 0) {
      i--;
      continue;
    }
    line = line.trim();
    if (line.isEmpty) {
      continue;
    }
    final values = line.split(RegExp(r"\s+"));
    if (values.length >= 2) {
      double downSpeed = double.tryParse(values[0]) ?? 0;
      double upSpeed = double.tryParse(values[1]) ?? 0;
      final throughput = downSpeed + upSpeed;
      //print("$downSpeed $upSpeed $throughput");
      double checkMax = ceilTo(throughput);
      checkMax > max ? max = checkMax : max = max;

      yield {
        "down": downSpeed,
        "up": upSpeed,
        "throughput": throughput,
        "max": max,
      };
    }
  }
});
double ceilTo(double value) {
  if (value <= 0) return 100;
  int length = value.ceil().toString().length;
  double ceilValue = pow(10, length).toDouble();
  return ceilValue;
}

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