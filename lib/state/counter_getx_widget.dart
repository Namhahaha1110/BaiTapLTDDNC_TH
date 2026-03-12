import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterGetXWidget extends StatelessWidget {
  CounterGetXWidget({super.key});

  final RxInt _counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Obx(
          () => Text(
            'GetX: ${_counter.value}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _counter.value++;
          },
          child: const Text('Tăng'),
        ),
      ],
    );
  }
}
