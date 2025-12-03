import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';
import 'package:task_manager/visualDisk.dart';
import 'package:task_manager/widgets/visualCpu.dart';
import 'package:task_manager/widgets/visualMemory.dart';
import 'package:task_manager/widgets/visualNetwork.dart';

class Options extends ConsumerWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer(
          builder: (context, ref, child) {
           ref.watch(selectProvider);
            return Container(
              margin: EdgeInsets.all(15),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: Colors.black12,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    ref.read(selectProvider.notifier).state = "CPU";
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: Visualcpu(showGrid: false),
                      ),
                      SizedBox(width: 20),
                      Text("CPU"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        Consumer(
          builder: (context, ref, child) {
             ref.watch(selectProvider);
            return Container(
              margin: EdgeInsets.all(15),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: Colors.black12,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    ref.read(selectProvider.notifier).state = "Memory";
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: VisualMemory(showGrid: false),
                      ),
                      SizedBox(width: 20),
                      Text("Memory"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        Consumer(
          builder: (context, ref, child) {
             ref.watch(selectProvider);
            return Container(
              margin: EdgeInsets.all(15),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: Colors.black12,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    ref.read(selectProvider.notifier).state = "Network";
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: visualNetwork(showGrid: false),
                      ),
                      SizedBox(width: 20),
                      Text("Network"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      
         Consumer(
          builder: (context, ref, child) {
            ref.watch(selectProvider);
            return Container(
              margin: EdgeInsets.all(15),
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shadowColor: Colors.black12,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    ref.read(selectProvider.notifier).state = "Disk";
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: 80,
                        child: VisualDisk(showGrid: false),
                      ),
                      SizedBox(width: 20),
                      Text("Disk"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      
      ],
    );
  }
}
