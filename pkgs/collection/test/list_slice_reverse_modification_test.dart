// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('reverseRange rejects a resized backing list', () {
    final values = [0, 1, 2, 3, 4];
    final slice = values.slice(1, 4);
    values.add(5);

    expect(
      () => slice.reverseRange(0, 2),
      throwsA(isA<ConcurrentModificationError>()),
    );
    expect(values, [0, 1, 2, 3, 4, 5]);
  });

  test('reverseRange works on a slice of an unchanged list', () {
    final values = [0, 1, 2, 3, 4];
    final slice = values.slice(1, 4);

    slice.reverseRange(0, 2);

    expect(values, [0, 2, 1, 3, 4]);
  });

  test('reverseRange validates slice bounds', () {
    final values = [0, 1, 2, 3, 4];
    final slice = values.slice(1, 4);

    expect(() => slice.reverseRange(0, 4), throwsRangeError);
    expect(values, [0, 1, 2, 3, 4]);
  });
}
