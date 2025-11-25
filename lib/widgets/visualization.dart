import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/provider.dart';

class Visualization extends ConsumerStatefulWidget {
  const Visualization({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VisualizationState();
}

class _VisualizationState extends ConsumerState<Visualization> {

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context,ref,child){
      final streams = ref.watch(cpuBuilder);
      return streams.when(
        data: (data){
          return Column(
            children: [
              for(var i in data.entries)
              Text("${i.key} -> ${i.value}"),
            ],
          );
        },
       error: (error,stack )=>Text("error"), 
      loading: (){
        return Text("");
      });
    });
  }
}