import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecentStorage<T> {
  RecentStorage({required this.key, required this.toJson, required this.fromJson, this.maxItems = 20});

  final String key;
  final Map<String, dynamic> Function(T item) toJson;
  final T Function(Map<String, dynamic> json) fromJson;
  final int maxItems;

  Future<List<T>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? <String>[];
    return list.map((e) => fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
  }

  Future<void> add(T item) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await load();
    final serialized = toJson(item);
    final List<T> next = [item, ...list.where((e) => jsonEncode(toJson(e)) != jsonEncode(serialized))];
    final clipped = next.take(maxItems).toList();
    await prefs.setStringList(
      key,
      clipped.map((e) => jsonEncode(toJson(e))).toList(),
    );
  }
}
