import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';
import 'package:task_manager/providers/cpuProvider.dart';
import 'package:task_manager/providers/diskProvider.dart';
import 'package:task_manager/providers/memoryProvider.dart';
import 'package:task_manager/providers/networkProvider.dart';
import 'package:task_manager/visualDisk.dart';
import 'package:task_manager/widgets/visualCpu.dart';
import 'package:task_manager/widgets/visualMemory.dart';
import 'package:task_manager/widgets/visualNetwork.dart';

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
                  : option == "Memory"
                  ? Text("Memory Usage")
                  : option=="Disk"
                  ?Text("Disk Transfer Rate")
                  :Text("Throughput"),
                  Spacer(),
              option == "CPU"
                  ? Text("100%")
                  : option == "Memory"
                  ? Consumer(builder: (context,ref,child){
                    final streams=ref.watch(memoryBuilder);
                    return streams.when(
                      data: (data){
                        return Text("${data["total"]} GB");
                      }, 
                    error: (error, stack)=>Text("ERror"), 
                    loading: ()=>Text(""),
                    );
                  })
                  : option=="Disk"
                  ?Consumer(builder: (context,ref,child){
                    final streams=ref.watch(diskBuilder);
                    return streams.when(
                      data: (data){
                        return Text("${data["max"]} Kbps");
                      }, 
                    error: (error, stack)=>Text("ERror"), 
                    loading: ()=>Text(""),
                    );
                  })
                  :Consumer(builder: (context,ref,child){
                    final streams=ref.watch(networkBuilder);
                    return streams.when(
                      data: (data){
                        double max=data["max"]!;
                        String unit = "Kbps";
                        if(max>=1000){
                          max=max/1000;
                          unit="Mbps";
                        }
                        return Text("$max $unit");
                      }, 
                    error: (error, stack)=>Text("ERror"), 
                    loading: ()=>Text(""),
                    );
                  }),
            ],


          ),
          option=="CPU"? 
          Visualcpu(showGrid: true)
          :option=="Network"?
          visualNetwork(showGrid: true)
          :option=="Disk"?
          VisualDisk(showGrid: true)
          :
          VisualMemory(showGrid: true),
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
            }):option=="Network"?Consumer(builder: (Context,ref,child){
              final streams=ref.watch(networkBuilder);
              return streams.when(
                data: (data){
                  return Text(
                    "Send            :  ${data["up"]} Kbps\n\nReceive       :  ${data["down"]} Kbps"
                  );
                }, 
              error: (error,stack)=>Text("error"), 
              loading: ()=>SizedBox.shrink(),
              );
            }):option=="Disk"
            ?Consumer(builder: (context,ref,child){
              final streams=ref.watch(diskBuilder);
              return streams.when(
                data: (data){
                  return Text(
                    "Read Speed${" "*20}:  ${data["read"]} Kbps\n\nWrite Speed${" "*19}:  ${data["write"]} Kbps\n\nSize${" "*35}:  ${data["size"]} GB\n\nUsed${" "*33}:  ${data["used"]} GB\n\nFree${" "*34}:  ${data["avail"]} GB"
                  );
                }, 
              error: (error,stack)=>Text("error"), 
              loading: ()=>SizedBox.shrink(),
              );
            })
            :Consumer(builder: (context,ref,child){
                    final streams=ref.watch(memoryBuilder);
                    return streams.when(
                      data: (data){
                        return Text(
                          "Total Memory${" "*20}: ${data["total"]} GB \n\nIn Use${" "*35}: ${data["used"]} GB \n\nAvailable${" "*29}: ${data["available"]} GB \n\nCache Memory${" "*18}: ${data["cache"]} GB"
                        );
                      }, 
                    error: (error, stack)=>Text("ERror"), 
                    loading: ()=>Text(""),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
