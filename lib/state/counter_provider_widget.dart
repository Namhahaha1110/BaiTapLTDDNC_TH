import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class CounterProviderWidget extends StatelessWidget {
  const CounterProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterModel(),
      child: Consumer<CounterModel>(
        builder: (context, counter, child) {
          return Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Provider: ${counter.count}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: counter.increment,
                child: const Text('Tăng'),
              ),
            ],
          );
        },
      ),
    );
  }
}
