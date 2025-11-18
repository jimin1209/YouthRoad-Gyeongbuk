class UnityRegionMapper {
  const UnityRegionMapper();

  /// Maps Unity-side composite codes (e.g., `GB-GS`) to YouthRoad numeric
  /// region codes. The numeric codes follow the province/city administrative
  /// codes used by the public API.
  static const Map<String, String> _unityToYouthRoad = {
    'GB-GS': '47', // 경상북도 (경산시 등 세부 지역 포함)
    'GB-DG': '27', // 대구광역시
    'GB-PO': '47', // 포항
    'GB-AN': '47', // 안동
    'GB-GM': '47', // 구미
    'GB-GJ': '47', // 경주
    'GB-YS': '47', // 영주/영천 등 기타 경북 권역
  };

  String? toYouthRoadCode(String unityCode) {
    return _unityToYouthRoad[unityCode];
  }

  bool isSupported(String unityCode) => _unityToYouthRoad.containsKey(unityCode);
}
