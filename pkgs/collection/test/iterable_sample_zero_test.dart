// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('sample(0) does not iterate the input', () {
    final source = _ThrowingIterable<int>();

    expect(source.sample(0), isEmpty);
  });

  test('sample(0) is independent of input length', () {
    final source = [1, 2, 3, 4];

    final result = (source as Iterable<int>).sample(0);

    expect(result, isEmpty);
    expect(source, [1, 2, 3, 4]);
  });

  test('sample rejects negative count before reading the iterable', () {
    final source = _ThrowingIterable<int>();

    expect(() => source.sample(-1), throwsRangeError);
  });
}

class _ThrowingIterable<E> extends IterableBase<E> {
  @override
  Iterator<E> get iterator => throw StateError('unexpected iteration');
}
