// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('BoolList.of consumes a lazy source once', () {
    final source = _SingleUseIterable([
      true, false, true, true, false, false, true,
    ]);

    final bits = BoolList.of(source);

    expect(bits, [true, false, true, true, false, false, true]);
    expect(source.iteratorRequests, 1);
    expect(() => bits.add(false), throwsUnsupportedError);
  });

  test('BoolList.of growable consumes the lazy source once', () {
    final source = _SingleUseIterable([true, false, true]);
    final bits = BoolList.of(source, growable: true);

    bits.add(false);

    expect(bits, [true, false, true, false]);
    expect(source.iteratorRequests, 1);
  });

  test('BoolList.of preserves a fixed-length list copy', () {
    final source = List<bool>.generate(65, (i) => i.isEven);
    final bits = BoolList.of(source);
    source[0] = false;

    expect(bits[0], isTrue);
    expect(bits.length, 65);
    expect(() => bits.length = 66, throwsUnsupportedError);
  });
}

class _SingleUseIterable extends IterableBase<bool> {
  final List<bool> _values;
  int iteratorRequests = 0;

  _SingleUseIterable(this._values);

  @override
  Iterator<bool> get iterator {
    iteratorRequests++;
    if (iteratorRequests != 1) {
      throw StateError('single-use source was iterated twice');
    }
    return _values.iterator;
  }
}
