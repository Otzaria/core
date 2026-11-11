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

  test('growing through a cast does not narrow the original storage', () {
    final original = QueueList<num>();
    final cast = original.cast<int>();

    cast.addAll(List<int>.generate(40, (i) => i));
    original.add(2.5);

    expect(original.last, 2.5);
    expect(() => cast.last, throwsA(isA<TypeError>()));
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

  test('single-element growth does not cast existing elements', () {
    final original = QueueList<num>()..addAll([1.5, 2, 3, 4, 5, 6, 7]);
    final cast = original.cast<int>();

    cast.addLast(8);

    expect(original, [1.5, 2, 3, 4, 5, 6, 7, 8]);
    expect(cast.last, 8);
    expect(() => cast.first, throwsA(isA<TypeError>()));
  });

  test('bulk growth through chained casts keeps original element types', () {
    final original = QueueList<Object>()..addAll([1.5, 'a']);
    final cast = original.cast<num>().cast<int>();
    final added = List<int>.generate(8, (i) => i);

    cast.addAll(added);
    original.add('b');

    expect(original, [1.5, 'a', ...added, 'b']);
    expect(cast[2], 0);
    expect(() => cast[1], throwsA(isA<TypeError>()));
  });
}
