import 'package:flutter/material.dart';

class CounterInherited extends InheritedWidget {
  final int counter;
  final VoidCallback increment;

  const CounterInherited({
    super.key,
    required this.counter,
    required this.increment,
    required super.child,
  });

  static CounterInherited of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<CounterInherited>();
    return inherited!;
  }

  @override
  bool updateShouldNotify(CounterInherited oldWidget) {
    return counter != oldWidget.counter;
  }
}

class CounterInheritedWidget extends StatefulWidget {
  const CounterInheritedWidget({super.key});

  @override
  State<CounterInheritedWidget> createState() => _CounterInheritedWidgetState();
}

class _CounterInheritedWidgetState extends State<CounterInheritedWidget> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterInherited(
      counter: _counter,
      increment: _increment,
      child: Builder(
        builder: (context) {
          final inherited = CounterInherited.of(context);

          return Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'InheritedWidget: ${inherited.counter}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: inherited.increment,
                child: const Text('Tăng'),
              ),
            ],
          );
        },
      ),
    );
  }
}
