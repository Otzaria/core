// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('shuffle rejects invalid ranges without changing elements', () {
    final values = [3, 2, 1];

    expect(() => shuffle(values, -1, 2), throwsRangeError);
    expect(() => shuffle(values, 2, 1), throwsRangeError);
    expect(() => shuffle(values, 0, 4), throwsRangeError);
    expect(() => shuffle(values, 4), throwsRangeError);
    expect(values, [3, 2, 1]);
  });

  test('insertionSort rejects invalid ranges without mutation', () {
    final values = [3, 2, 1];

    expect(() => insertionSort(values, start: -1), throwsRangeError);
    expect(() => insertionSort(values, start: 2, end: 1), throwsRangeError);
    expect(() => insertionSort(values, end: 4), throwsRangeError);
    expect(() => insertionSort(values, start: 4), throwsRangeError);
    expect(values, [3, 2, 1]);
  });

  test('both algorithms still accept valid empty ranges', () {
    final values = [3, 2, 1];

    shuffle(values, 1, 1);
    insertionSort(values, start: 3, end: 3);

    expect(values, [3, 2, 1]);
  });

  test('insertionSort orders only the requested subrange', () {
    final values = [5, 4, 3, 2, 1];

    insertionSort(values, start: 1, end: 4);

    expect(values, [5, 2, 3, 4, 1]);
  });
}
