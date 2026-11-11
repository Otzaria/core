// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('take does not invent a leading separator for an empty source', () {
    final empty = (<int>[] as Iterable<int>).separated(0, before: true);

    expect(empty.take(1), isEmpty);
    expect(empty.take(5), isEmpty);
  });

  test('take never invents a trailing separator past the source length', () {
    final source = (<int>[1, 2, 3] as Iterable<int>).separated(0);

    expect(source.take(4), [1, 0, 2, 0]);
    expect(source.take(5), [1, 0, 2, 0, 3]);
    expect(source.take(6), [1, 0, 2, 0, 3]);
    expect(source.take(100), [1, 0, 2, 0, 3]);
  });

  test('take retains before and after separators within the limit', () {
    final source = (<int>[1, 2] as Iterable<int>)
        .separated(0, before: true, after: true);

    expect(source.take(1), [0]);
    expect(source.take(3), [0, 1, 0]);
    expect(source.take(20), [0, 1, 0, 2, 0]);
  });

  test('take is lazy and reflects source changes before iteration', () {
    final values = [1, 2];
    final result = (values as Iterable<int>).separated(0).take(10);
    values.add(3);

    expect(result, [1, 0, 2, 0, 3]);
  });
}
