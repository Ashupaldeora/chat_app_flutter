import 'package:flutter/material.dart';
import 'package:snappable_thanos/snappable_thanos.dart';

class GlobalKeyManager {
  static final Map<String, GlobalKey<SnappableState>> _keys = {};

  static void registerKey(String messageId, GlobalKey<SnappableState> key) {
    _keys[messageId] = key;
  }

  static GlobalKey<SnappableState>? getKey(String messageId) {
    return _keys[messageId];
  }
}
