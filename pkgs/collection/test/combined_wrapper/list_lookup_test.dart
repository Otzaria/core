// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('indexOf and lastIndexOf match a flattened list', () {
    final lists = <List<int>>[
      [],
      [1, 2, 1],
      [],
      [3, 2, 4, 2],
      [],
      [5],
      [],
    ];
    final combined = CombinedListView<int>(lists);
    final expected = lists.expand((list) => list).toList();

    for (final value in [1, 2, 4, 5, 8]) {
      for (final start in [-3, -1, 0, 1, 3, 6, 10, 100]) {
        expect(combined.indexOf(value, start), expected.indexOf(value, start));
        expect(
          combined.lastIndexOf(value, start),
          expected.lastIndexOf(value, start),
        );
      }
      expect(combined.indexOf(value), expected.indexOf(value));
      expect(combined.lastIndexOf(value), expected.lastIndexOf(value));
    }
  });

  test('lookups reflect changes in the backing lists', () {
    final a = [1, 2];
    final b = [3, 2];
    final combined = CombinedListView<int>([a, b]);

    expect(combined.indexOf(3), 2);
    a.add(5);
    expect(combined.indexOf(3), 3);
    expect(combined.lastIndexOf(2), 4);
  });

  test('empty accessors handle empty child lists', () {
    final a = <int>[];
    final b = <int>[];
    final combined = CombinedListView<int>([a, b]);

    expect(combined.isEmpty, isTrue);
    expect(combined.isNotEmpty, isFalse);
    expect(() => combined.first, throwsStateError);
    expect(() => combined.last, throwsStateError);

    b.add(7);
    expect(combined.isEmpty, isFalse);
    expect(combined.isNotEmpty, isTrue);
    expect(combined.first, 7);
    expect(combined.last, 7);
    expect(combined.indexOf(7), 0);
  });

  test('first and last skip empty child lists', () {
    final combined = CombinedListView<int>([
      <int>[],
      [1, 2],
      <int>[],
      [3, 4],
      <int>[],
    ]);

    expect(combined.first, 1);
    expect(combined.last, 4);
  });
}
