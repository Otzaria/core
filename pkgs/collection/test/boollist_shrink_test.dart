// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('shrinking within reserved capacity clears the unused words', () {
    final bits = BoolList.empty(capacity: 4096);
    bits.length = 2048;
    bits.fillRange(0, 2048, true);

    bits.length = 1500;
    bits.length = 4096;

    expect(bits.take(1500), everyElement(isTrue));
    expect(bits.skip(1500), everyElement(isFalse));
  });

  test('shrinking clears partial words without losing kept bits', () {
    final bits = BoolList(128, fill: true, growable: true);

    for (final length in [127, 96, 65, 33, 32, 1, 0]) {
      bits.length = length;
      bits.length = 128;
      expect(bits.take(length), everyElement(isTrue));
      expect(bits.skip(length), everyElement(isFalse));
      bits.fillRange(0, 128, true);
    }
  });

  test('shrink and regrow preserve only the visible prefix', () {
    final bits = BoolList(1000, fill: true, growable: true);
    bits.length = 31;
    bits.length = 1024;

    expect(bits.take(31), everyElement(isTrue));
    expect(bits.skip(31), everyElement(isFalse));
  });
}
