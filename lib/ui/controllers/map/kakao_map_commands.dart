import '../../models/map/kakao_map_models.dart';
import '../../models/map/kakao_map_options.dart';

abstract class KakaoMapCommand {
  KakaoMapCommand(this.type, this.payload);

  final String type;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
      };
}

class SetCenterCommand extends KakaoMapCommand {
  SetCenterCommand(KakaoMapLatLng center, {bool animate = false})
      : super('set_center', {
          'lat': center.lat,
          'lng': center.lng,
          'animate': animate,
        });
}

class SetLevelCommand extends KakaoMapCommand {
  SetLevelCommand(int level) : super('set_level', {'level': level});
}

class SetMapTypeCommand extends KakaoMapCommand {
  SetMapTypeCommand(KakaoMapMapType type)
      : super('set_map_type', {'mapType': type.name});
}

class SetMarkersCommand extends KakaoMapCommand {
  SetMarkersCommand(List<KakaoMapMarker> markers)
      : super(
          'set_markers',
          {
            'markers': markers.map((e) => e.toJson()).toList(),
          },
        );
}

class SetPolylinesCommand extends KakaoMapCommand {
  SetPolylinesCommand(List<KakaoMapPolyline> polylines)
      : super(
          'set_polylines',
          {
            'polylines': polylines.map((e) => e.toJson()).toList(),
          },
        );
}

class FitToMarkersCommand extends KakaoMapCommand {
  FitToMarkersCommand(List<KakaoMapMarker> markers)
      : super(
          'fit_to_markers',
          {
            'markers': markers.map((e) => e.toJson()).toList(),
          },
        );
}

class ReloadCommand extends KakaoMapCommand {
  ReloadCommand(KakaoMapOptions options)
      : super('reload', {
          'options': options.toJson(),
        });
}
