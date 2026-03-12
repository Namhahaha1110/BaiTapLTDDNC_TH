import 'package:flutter/material.dart';

class CounterStatefulWidget extends StatefulWidget {
  const CounterStatefulWidget({super.key});

  @override
  State<CounterStatefulWidget> createState() => _CounterStatefulWidgetState();
}

class _CounterStatefulWidgetState extends State<CounterStatefulWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'StatefulWidget: $_counter',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        ElevatedButton(onPressed: _increment, child: const Text('Tăng')),
      ],
    );
  }
}
