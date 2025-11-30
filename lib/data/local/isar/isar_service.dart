import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'policy_isar_model.dart';

final isarServiceProvider = Provider<IsarService>((_) => IsarService());

class IsarService {
  Isar? _isar;

  Future<Isar> get instance async {
    if (_isar != null) {
      return _isar!;
    }

    _isar = await _openIsar();
    return _isar!;
  }

  Future<Isar> _openIsar() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final dir = await getApplicationDocumentsDirectory();
    if (kDebugMode) {
      debugPrint('[IsarService] Opening Isar at ${dir.path}');
    }

    return Isar.open(
      [PolicyIsarModelSchema],
      directory: dir.path,
      inspector: kDebugMode,
    );
  }
}
