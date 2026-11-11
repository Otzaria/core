// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('empty fill ranges are no-ops for empty BoolLists', () {
    final fixed = BoolList(0);
    final growable = BoolList.empty();

    fixed.fillRange(0, 0, true);
    growable.fillRange(0, 0, true);

    expect(fixed, isEmpty);
    expect(growable, isEmpty);
  });

  test('empty fill at a word boundary preserves neighboring bits', () {
    final bits = BoolList(96, fill: true);

    bits.fillRange(32, 32, false);
    bits.fillRange(64, 64, false);
    bits.fillRange(96, 96, true);

    expect(bits, List<bool>.filled(96, true));
  });

  test('empty fill at zero never modifies the first word', () {
    final bits = BoolList(64);

    bits.fillRange(0, 0, true);

    expect(bits, List<bool>.filled(64, false));
  });
}
