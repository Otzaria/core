// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('MapEquality.hash visits values without index lookups', () {
    final map = _CountingMap<String, int>({'a': 1, 'b': 2, 'c': 3});
    const equality = MapEquality<String, int>();

    expect(equality.hash(map), equality.hash({'a': 1, 'b': 2, 'c': 3}));
    expect(map.indexReads, 0);
    expect(map.forEachCalls, 1);
  });

  test('MapEquality.hash preserves hash for nullable and nested values', () {
    final data = <String, List<int>?>{
      'one': [1, 2, 3],
      'none': null,
    };
    final copied = Map<String, List<int>?>.from(data);
    const equality = MapEquality<String, List<int>?>(
      values: DeepCollectionEquality(),
    );

    expect(equality.equals(data, copied), isTrue);
    expect(equality.hash(data), equality.hash(copied));
  });

  test('MapEquality.equals supports two empty maps', () {
    const equality = MapEquality<String, int>();

    expect(equality.equals(<String, int>{}, <String, int>{}), isTrue);
  });
}

class _CountingMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _backing;
  int indexReads = 0;
  int forEachCalls = 0;

  _CountingMap(this._backing);

  @override
  V? operator [](Object? key) {
    indexReads++;
    return _backing[key];
  }

  @override
  void operator []=(K key, V value) => _backing[key] = value;

  @override
  void clear() => _backing.clear();

  @override
  Iterable<K> get keys => _backing.keys;

  @override
  V? remove(Object? key) => _backing.remove(key);

  @override
  void forEach(void Function(K, V) action) {
    forEachCalls++;
    _backing.forEach(action);
  }
}
