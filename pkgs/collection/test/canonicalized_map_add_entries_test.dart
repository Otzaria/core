// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('addEntries applies the same key validation as []=', () {
    final map = CanonicalizedMap<int, String, String>(
      int.parse,
      isValidKey: (key) => RegExp(r'^\\d+$').hasMatch(key),
    );

    map.addEntries([
      const MapEntry('1', 'first'),
      const MapEntry('not-a-number', 'invalid'),
      const MapEntry('01', 'last'),
    ]);

    expect(map, hasLength(1));
    expect(map['001'], 'last');
    expect(map.containsKey('not-a-number'), isFalse);
  });

  test('addEntries leaves the map unchanged for invalid entries', () {
    final map = CanonicalizedMap<int, String, int>(
      int.parse,
      isValidKey: (key) => key == '12',
    );

    map.addEntries([const MapEntry('invalid', 5)]);

    expect(map, isEmpty);
  });
}
