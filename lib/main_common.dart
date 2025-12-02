import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/bootstrap/bootstrap.dart';

Future<void> mainCommon() async {
  await bootstrap(
    builder: () => const YouthRoadApp(),
  );
}
