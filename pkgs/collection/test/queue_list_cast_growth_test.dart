// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('cast view follows storage growth by the original queue', () {
    final original = QueueList<num>();
    final cast = original.cast<int>();
    final elements = List<int>.generate(40, (i) => i);

    original.addAll(elements);

    expect(cast, elements);
    expect(cast[39], 39);
  });

  test('growing through a cast view updates the original queue', () {
    final original = QueueList<num>();
    final cast = original.cast<int>();
    final elements = List<int>.generate(40, (i) => i);

    cast.addAll(elements);
    original.addLast(40);

    expect(original, [...elements, 40]);
    expect(cast, [...elements, 40]);
  });

  test('both views work after wraparound and growth', () {
    final original = QueueList<num>()..addAll([1, 2, 3, 4, 5, 6]);
    final cast = original.cast<int>();

    for (var i = 0; i < 4; i++) {
      expect(cast.removeFirst(), i + 1);
    }
    cast.addAll(List<int>.generate(32, (i) => i + 7));

    expect(original, cast);
    expect(cast.last, 38);
  });
}
