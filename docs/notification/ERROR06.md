lib/features/map_v2/kakao_map_screen.dart:160:28: Error: The getter '_onCenterCardTap' isn't defined for the class '_KakaoMapScreenState'.
 - '_KakaoMapScreenState' is from 'package:youth_road_app/features/map_v2/kakao_map_screen.dart' ('lib/features/map_v2/kakao_map_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named '_onCenterCardTap'.
              onCenterTap: _onCenterCardTap,
                           ^^^^^^^^^^^^^^^^
lib/features/map_v2/kakao_map_screen.dart:521:9: Error: No named parameter with the name 'lat'.
        lat: center.lat,
        ^^^
lib/features/map_v2/kakao_map_html_builder.dart:65:9: Context: Found this candidate, but the arguments don't match.
  const KakaoMapMarker({
        ^^^^^^^^^^^^^^
lib/features/map_v2/kakao_map_screen.dart:528:8: Error: A value of type 'List<dynamic>' can't be returned from a function with return type 'List<KakaoMapMarker>'.
 - 'List' is from 'dart:core'.
 - 'KakaoMapMarker' is from 'package:youth_road_app/features/map_v2/kakao_map_html_builder.dart' ('lib/features/map_v2/kakao_map_html_builder.dart').
    }).toList();
       ^
lib/features/map_v2/kakao_map_screen.dart:543:9: Error: No named parameter with the name 'strokeWidth'.
        strokeWidth: 2,
        ^^^^^^^^^^^
lib/features/map_v2/kakao_map_html_builder.dart:96:9: Context: Found this candidate, but the arguments don't match.
  const KakaoMapPolyline({
        ^^^^^^^^^^^^^^^^
lib/features/map_v2/kakao_map_screen.dart:534:38: Error: The getter 'lat' isn't defined for the class 'KakaoMapMarker'.
 - 'KakaoMapMarker' is from 'package:youth_road_app/features/map_v2/kakao_map_html_builder.dart' ('lib/features/map_v2/kakao_map_html_builder.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'lat'.
        .map((m) => KakaoMapLatLng(m.lat, m.lng))
                                     ^^^
lib/features/map_v2/kakao_map_screen.dart:534:45: Error: The getter 'lng' isn't defined for the class 'KakaoMapMarker'.
 - 'KakaoMapMarker' is from 'package:youth_road_app/features/map_v2/kakao_map_html_builder.dart' ('lib/features/map_v2/kakao_map_html_builder.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'lng'.
        .map((m) => KakaoMapLatLng(m.lat, m.lng))
                                            ^^^
lib/features/map_v2/kakao_map_screen.dart:553:7: Error: No named parameter with the name 'lat'.
      lat: location.lat,
      ^^^
lib/features/map_v2/kakao_map_html_builder.dart:65:9: Context: Found this candidate, but the arguments don't match.
  const KakaoMapMarker({
        ^^^^^^^^^^^^^^
lib/features/policy_new/application/controllers/base_feed_controller.dart:185:33: Error: The getter 'queryValue' isn't defined for the class 'PolicyStatusFilter'.
 - 'PolicyStatusFilter' is from 'package:youth_road_app/features/policy_new/domain/values/policy_status_filter.dart' ('lib/features/policy_new/domain/values/policy_status_filter.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'queryValue'.
        'status=${filter.status.queryValue}, '
                                ^^^^^^^^^^
lib/features/policy_new/application/controllers/base_feed_controller.dart:266:48: Error: The getter 'queryValue' isn't defined for the class 'PolicyStatusFilter'.
 - 'PolicyStatusFilter' is from 'package:youth_road_app/features/policy_new/domain/values/policy_status_filter.dart' ('lib/features/policy_new/domain/values/policy_status_filter.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'queryValue'.
      'status=${queryState.query.filter.status.queryValue}, '
                                               ^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command '/home/ssm-user/flutter/bin/flutter'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.
