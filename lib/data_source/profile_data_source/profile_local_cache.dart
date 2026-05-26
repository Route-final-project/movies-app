import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract final class ProfileLocalCache {
  static const String _prefix = 'profile_cache_';

  static Future<void> save({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required int avatarId,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      '$_prefix$uid',
      jsonEncode({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'avatarId': avatarId,
      }),
    );
  }

  static Future<Map<String, dynamic>?> read(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final rawValue = preferences.getString('$_prefix$uid');
    if (rawValue == null) return null;
    final decoded = jsonDecode(rawValue);
    if (decoded is! Map) return null;
    return Map<String, dynamic>.from(decoded);
  }
}
