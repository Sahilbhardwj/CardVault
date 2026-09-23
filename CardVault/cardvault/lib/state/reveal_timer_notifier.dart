import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RevealTimerNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() {
    // Automatically cancel the timer when the provider is disposed.
    ref.onDispose(() {
      _timer?.cancel();
    });

    return 0;
  }

  void start({int seconds = 30}) {
    _timer?.cancel();

    state = seconds;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state <= 1) {
          timer.cancel();
          state = 0;
        } else {
          state--;
        }
      },
    );
  }

  void reset() {
    _timer?.cancel();
    state = 0;
  }
}