// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('MapEquality.hash preserves hash for nullable and nested values', () {
    final data = <String, List<int>?>{
      'one': [1, 2, 3],
      'none': null,
    };
    final copied = Map<String, List<int>?>.from(data);
    const equality = MapEquality<String, Object?>(
      values: DeepCollectionEquality(),
    );

    expect(equality.equals(data, copied), isTrue);
    expect(equality.hash(data), equality.hash(copied));
  });

  test('MapEquality.equals supports two empty maps', () {
    const equality = MapEquality<String, int>();

    expect(equality.equals(<String, int>{}, <String, int>{}), isTrue);
  });

  test('MapEquality.hash reflects edits to a wrapped map', () {
    final map = _WrappedMap<String, int?>({'a': 1, 'b': 2});
    const equality = MapEquality<String, int?>();

    expect(equality.hash(map), equality.hash({'a': 1, 'b': 2}));
    map['a'] = null;
    map.remove('b');
    map['c'] = 3;
    expect(equality.hash(map), equality.hash({'a': null, 'c': 3}));
  });
}

class _WrappedMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _backing;

  _WrappedMap(this._backing);

  @override
  V? operator [](Object? key) => _backing[key];

  @override
  void operator []=(K key, V value) => _backing[key] = value;

  @override
  void clear() => _backing.clear();

  @override
  Iterable<K> get keys => _backing.keys;

  @override
  V? remove(Object? key) => _backing.remove(key);
}
