import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';
import 'package:task_manager/widgets/visualCpu.dart';

class Visualization extends ConsumerStatefulWidget {
  const Visualization({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisualizationState();
}

class _VisualizationState extends ConsumerState<Visualization> {
  @override
  Widget build(BuildContext context) {
    final option = ref.watch(selectProvider);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Consumer(
            builder: (context, ref, child) {
              final cpuInfo = ref.watch(cpuInfoProvider);
              return cpuInfo.when(
                data: (data) {
                  return Row(
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (option == "CPU") Text(data["model name"]!),
                    ],
                  );
                },

                error: (error, stack) => Text("error"),
                loading: () => Text(""),
              );
            },
          ),

          SizedBox(height: 10),
          Row(
            children: [
              option == "CPU"
                  ? Text("Utilization")
                  : option == "MEMORY"
                  ? Text("Memory Usage")
                  : Text("Throughput"),
                  Spacer(),
              option == "CPU"
                  ? Text("100%")
                  : option == "MEMORY"
                  ? Text("10 GB")
                  : Text("100 kbps"),
            ],


          ),
          Visualcpu(showGrid: true),
           Row(
            children: [
              Text("0 sec"),
              Spacer(),
              Text("60 sec"),
            ],


          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFF1D1B20),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                option=="CPU"? Consumer(builder: (context,ref,child){
              final streams= ref.watch(cpuBuilder);
              return streams.when(
                data: (data){
                  return Text(
                    "Utilization${' '*21}: ${(100-data["id"]!).toStringAsFixed(2)}%"
                  );
                }, 
                error: (error,stack)=>Text("error"), 
                loading: ()=>SizedBox.shrink(),
                );
            }):SizedBox.shrink(),

          option=="CPU"? Consumer(builder: (context,ref,child){
              final streams= ref.watch(cpuInfoProvider);
              return streams.when(
                data: (data){
                  return Text(
                    "\nCores${' '*30}: ${(data["cpu cores"]!)} \n\nBase Speed${' '*19}: ${(data["cpu MHz"]!)} \n\nCache Size${' '*21}: ${(data["cache size"]!)}",
                  );
                }, 
                error: (error,stack)=>Text("error"), 
                loading: ()=>SizedBox.shrink(),
                );
            }):SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
