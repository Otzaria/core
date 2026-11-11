// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('ListEquality.hash reads length once for non-constant-time views', () {
    final values = _LengthCountingList([1, 2, 3, 4]);

    final hash = const ListEquality<int>().hash(values);

    expect(hash, const ListEquality<int>().hash([1, 2, 3, 4]));
    expect(values.lengthReads, 1);
  });

  test('ListExtensions.equals reads each list length once', () {
    final left = _LengthCountingList([1, 2, 3, 4]);
    final right = _LengthCountingList([1, 2, 3, 4]);

    expect(left.equals(right), isTrue);
    expect(left.lengthReads, 1);
    expect(right.lengthReads, 1);
  });

  test('ListExtensions.equals rejects unequal lengths', () {
    final left = _LengthCountingList([1, 2, 3]);
    final right = _LengthCountingList([1, 2]);

    expect(left.equals(right), isFalse);
    expect(left.lengthReads, 1);
    expect(right.lengthReads, 1);
  });
}

class _LengthCountingList<E> extends ListBase<E> {
  final List<E> values;
  int lengthReads = 0;

  _LengthCountingList(this.values);

  @override
  int get length {
    lengthReads++;
    return values.length;
  }

  @override
  set length(int length) => throw UnsupportedError('Fixed length');

  @override
  E operator [](int index) => values[index];

  @override
  void operator []=(int index, E value) => values[index] = value;
}
