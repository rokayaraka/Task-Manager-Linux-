import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
