import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart' as mobx;

class CounterMobXWidget extends StatefulWidget {
  const CounterMobXWidget({super.key});

  @override
  State<CounterMobXWidget> createState() => _CounterMobXWidgetState();
}

class _CounterMobXWidgetState extends State<CounterMobXWidget> {
  late final mobx.Observable<int> _counter;
  late final mobx.Action _incrementAction;

  @override
  void initState() {
    super.initState();
    _counter = mobx.Observable(0);
    _incrementAction = mobx.Action(() {
      _counter.value++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Observer(
          builder: (context) {
            return Text(
              'MobX: ${_counter.value}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            );
          },
        ),
        ElevatedButton(
          onPressed: () => _incrementAction(),
          child: const Text('Tăng'),
        ),
      ],
    );
  }
}
