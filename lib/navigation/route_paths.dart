class RoutePaths {
  static const splash = '/splash';
  static const home = '/';
  static const category = '/category';
  static const chatbot = '/ai_chat';
  static const setting = '/setting';
  static const settingV2 = '/settings/v2';
  static const unity = '/map';
  static const googleMap = '/google_map';
  static const mapWithList = '/map_with_list';
  static const regionSelect = '/region/select';
  static const policyListV2 = '/policy/list/v2';
  static const policyLegacyList = '/policy/list';
  static const policyCompare = '/policy/compare';
  static const favorites = '/favorites';
  static const instList = '/inst/list';
  static const deptList = '/inst/:instNo/dept/list';
  static const policyWebview = '/policy/webview';
  static const splashLegacy = '/splash';

  static String policyDetail(String id) => '/policy/$id';
  static String instDept(String instNo) => '/inst/$instNo/dept/list';
}
