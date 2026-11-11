// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('QueueList.from handles list lengths around ring capacity boundaries', () {
    for (final count in [0, 1, 6, 7, 8, 15, 16, 31, 32, 63, 64]) {
      final input = List<int>.generate(count, (i) => i);
      final queue = QueueList<int>.from(input);

      expect(queue, input);
      queue.add(count);
      expect(queue, [...input, count]);
    }
  });

  test('QueueList.from keeps correct order after wrapping and growing', () {
    final queue = QueueList<int>.from(List<int>.generate(15, (i) => i));
    for (var i = 0; i < 8; i++) {
      expect(queue.removeFirst(), i);
    }
    queue.addAll(List<int>.generate(20, (i) => i + 15));

    expect(queue, List<int>.generate(27, (i) => i + 8));
  });
}
