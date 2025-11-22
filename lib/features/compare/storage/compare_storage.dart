import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CompareStorage<T> {
  CompareStorage({
    required this.key,
    required this.toJson,
    required this.fromJson,
    this.maxItems = 2,
  });

  final String key;
  final Map<String, dynamic> Function(T item) toJson;
  final T Function(Map<String, dynamic> json) fromJson;
  final int maxItems;

  Future<List<T>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? <String>[];
    return list.map((e) => fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
  }

  Future<void> toggle(T item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final serializedItem = jsonEncode(toJson(item));

    final exists = current.any((e) => jsonEncode(toJson(e)) == serializedItem);
    List<T> next;
    if (exists) {
      next = current.where((e) => jsonEncode(toJson(e)) != serializedItem).toList();
    } else {
      next = [item, ...current];
      if (next.length > maxItems) {
        next = next.take(maxItems).toList();
      }
    }
    await prefs.setStringList(
      key,
      next.map((e) => jsonEncode(toJson(e))).toList(),
    );
  }
}
