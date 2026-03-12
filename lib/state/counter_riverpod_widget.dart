import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _riverpodCounterProvider = StateProvider<int>((ref) => 0);

class CounterRiverpodWidget extends StatelessWidget {
  const CounterRiverpodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          final count = ref.watch(_riverpodCounterProvider);

          return Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Riverpod: $count',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(_riverpodCounterProvider.notifier).state++;
                },
                child: const Text('Tăng'),
              ),
            ],
          );
        },
      ),
    );
  }
}
