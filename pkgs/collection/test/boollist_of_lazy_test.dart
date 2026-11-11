// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('BoolList.of consumes a lazy source once', () {
    final source = _CountingIterable([
      true,
      false,
      true,
      true,
      false,
      false,
      true,
    ]);

    final bits = BoolList.of(source);

    expect(bits, [true, false, true, true, false, false, true]);
    expect(source.iteratorRequests, 1);
    expect(() => bits.add(false), throwsUnsupportedError);
  });

  test('BoolList.of growable consumes the lazy source once', () {
    final source = _CountingIterable([true, false, true]);
    final bits = BoolList.of(source, growable: true);

    bits.add(false);

    expect(bits, [true, false, true, false]);
    expect(source.iteratorRequests, 1);
  });

  test('BoolList.of packs one-pass sources across word boundaries', () {
    for (final count in [0, 31, 32, 33, 63, 64, 65, 97, 130]) {
      final input = List<bool>.generate(
        count,
        (i) => i % 7 < 4 || i % 32 == 31,
      );
      for (final growable in [false, true]) {
        final source = _CountingIterable(input);
        final bits = BoolList.of(source, growable: growable);

        expect(bits, input, reason: 'count=$count, growable=$growable');
        expect(source.iteratorRequests, 1);
        if (growable) {
          bits.length += 4;
          expect(bits, [...input, false, false, false, false]);
        }
      }
    }
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

class _CountingIterable extends IterableBase<bool> {
  final List<bool> _values;
  int iteratorRequests = 0;

  _CountingIterable(this._values);

  @override
  Iterator<bool> get iterator {
    iteratorRequests++;
    return _values.iterator;
  }
}
