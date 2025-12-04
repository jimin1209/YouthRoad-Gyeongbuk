import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/regions_gyeongbuk.dart';
import '../di.dart';
import '../../features/policy_new/application/filters/policy_filter_ui_state.dart'
    as filter_ui;

final regionProvider =
    NotifierProvider.autoDispose<RegionNotifier, String?>(RegionNotifier.new);

class RegionNotifier extends AutoDisposeNotifier<String?> {
  static const _cityKey = 'selected_city';
  static const _districtKey = 'selected_district';
  SharedPreferences? _prefs;

  String get selectedProvince => GyeongbukRegions.province;
  String? _selectedCity;
  String? _selectedDistrict;

  List<String> get availableCities => GyeongbukRegions.cities;

  List<String> get availableDistricts {
    // 현재는 전체만 제공, 향후 확장을 위해 구조 유지
    return const ['전체'];
  }

  String? get selectedCity => _selectedCity;
  String? get selectedDistrict => _selectedDistrict;

  String get summary {
    final city = _selectedCity;
    if (city == null || city.isEmpty) {
      return '경북 전체';
    }
    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
      return '경북 $city';
    }
    return '경북 $city ${_selectedDistrict!}';
  }

  @override
  String? build() {
    _prefs ??= ref.read(sharedPreferencesProvider);
    _selectedCity = _prefs?.getString(_cityKey);
    final storedDistrict = _prefs?.getString(_districtKey);
    _selectedDistrict = storedDistrict != null && storedDistrict.isNotEmpty
        ? storedDistrict
        : null;
    // state는 기존 호환성을 위해 city만 저장
    return _selectedCity;
  }

  void selectCity(String city) {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    prefs!.setString(_cityKey, city);
    prefs.remove(_districtKey);
    _selectedCity = city;
    _selectedDistrict = null;
    state = city;
    applyToFilter();
  }

  void resetCity() {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    prefs!.remove(_cityKey);
    prefs.remove(_districtKey);
    _selectedCity = null;
    _selectedDistrict = null;
    state = null;
  }

  void selectDistrict(String? district) {
    final prefs = _prefs ?? ref.read(sharedPreferencesProvider);
    _prefs = prefs;
    if (district == null || district.isEmpty) {
      prefs!.remove(_districtKey);
      _selectedDistrict = null;
      state = _selectedCity;
    } else {
      prefs!.setString(_districtKey, district);
      _selectedDistrict = district;
      state = '${_selectedCity ?? ''}|$district';
    }
    applyToFilter();
  }

  void clear() {
    resetCity();
  }

  /// 현재 지역을 필터 상태에 반영
  void applyToFilter() {
    final notifier =
        ref.read(filter_ui.policyFilterUiStateProvider.notifier);
    notifier.setRegionStrings(
      province: selectedProvince,
      city: _selectedCity,
      district: _selectedDistrict,
    );
  }
}
