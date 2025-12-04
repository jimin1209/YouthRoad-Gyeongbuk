import 'package:flutter/widgets.dart';
import 'app/bootstrap/bootstrap.dart';
import 'app/app.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();

  // bootstrap은 이제 runApp을 직접 호출함
  await bootstrap(builder: () => const YouthRoadApp());
}
