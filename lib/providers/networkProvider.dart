//Network Data Provider. Returns a map
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';

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
