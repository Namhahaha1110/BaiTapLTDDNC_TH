import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

int _counterReducer(int state, dynamic action) {
  if (action == 'INCREMENT') {
    return state + 1;
  }
  return state;
}

class CounterReduxWidget extends StatelessWidget {
  CounterReduxWidget({super.key});

  final Store<int> _store = Store<int>(_counterReducer, initialState: 0);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<int>(
      store: _store,
      child: StoreConnector<int, int>(
        converter: (store) => store.state,
        builder: (context, count) {
          return Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Redux: $count',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              ElevatedButton(
                onPressed: () {
                  StoreProvider.of<int>(context).dispatch('INCREMENT');
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
