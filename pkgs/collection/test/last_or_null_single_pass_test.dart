// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('lastOrNull consumes lazy input only once', () {
    final source = _SingleUseIterable([1, 2, 3]);

    expect(IterableExtension<int>(source).lastOrNull, 3);
    expect(source.iteratorRequests, 1);
  });

  test('lastOrNull handles empty lazy input in one pass', () {
    final source = _SingleUseIterable(<int>[]);

    expect(IterableExtension<int>(source).lastOrNull, isNull);
    expect(source.iteratorRequests, 1);
  });

  test('lastOrNull keeps fast paths for lists, sets and queues', () {
    expect(IterableExtension<int>(<int>[1, 2, 3]).lastOrNull, 3);
    expect(IterableExtension<int>({1, 2, 3}).lastOrNull, 3);
    expect(
      IterableExtension<int>(Queue<int>.from([1, 2, 3])).lastOrNull,
      3,
    );
  });

  test('lastOrNull handles separated iterables', () {
    final values = <int>[1, 2, 3].separated(0);

    expect(IterableExtension<int>(values).lastOrNull, 3);
    expect(
      IterableExtension<int>(
        <int>[].separated(0, before: true),
      ).lastOrNull,
      isNull,
    );
  });
}

class _SingleUseIterable extends IterableBase<int> {
  final List<int> _items;
  int iteratorRequests = 0;

  _SingleUseIterable(this._items);

  @override
  Iterator<int> get iterator {
    iteratorRequests++;
    if (iteratorRequests != 1) {
      throw StateError('input iterated more than once');
    }
    return _items.iterator;
  }
}
