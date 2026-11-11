// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('a terminated zip stops advancing longer input iterators', () {
    var visited = 0;
    Iterable<int> source() sync* {
      for (var value = 0; value < 10; value++) {
        visited++;
        yield value;
      }
    }

    final iterator = IterableZip<int>([
      source(),
      [100]
    ]).iterator;

    expect(iterator.moveNext(), isTrue);
    expect(iterator.current, [0, 100]);
    expect(iterator.moveNext(), isFalse);
    final visitsAtEnd = visited;
    expect(iterator.moveNext(), isFalse);
    expect(iterator.moveNext(), isFalse);
    expect(visited, visitsAtEnd);
    expect(() => iterator.current, throwsStateError);
  });

  test('a zip of empty input remains terminated', () {
    final iterator = IterableZip<int>([]).iterator;

    expect(iterator.moveNext(), isFalse);
    expect(iterator.moveNext(), isFalse);
  });
}
