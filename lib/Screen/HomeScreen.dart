import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constant.dart';
import 'package:task_manager/widgets/options.dart';
import 'package:task_manager/widgets/visualization.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          performance,
          Divider(height: 2,thickness: 2,),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 3, child: Center(child: Options(),)),
                Expanded(flex: 10, child: Center(child: Visualization())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}