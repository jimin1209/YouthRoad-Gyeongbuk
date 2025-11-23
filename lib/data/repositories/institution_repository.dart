import '../../domain/entities/institution_summary.dart';

class InstitutionRepository {
  const InstitutionRepository();

  Future<List<InstitutionSummary>> fetchInstitutions({String? keyword}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final list = const [
      InstitutionSummary(instNo: '101', name: '경북청년지원센터'),
      InstitutionSummary(instNo: '102', name: '경북창업진흥원'),
      InstitutionSummary(instNo: '103', name: '경북주거복지센터'),
    ];
    if (keyword == null || keyword.isEmpty) {
      return list;
    }
    return list
        .where((i) => i.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  Future<List<DepartmentSummary>> fetchDepartments(String instNo) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final map = <String, List<DepartmentSummary>>{
      '101': const [
        DepartmentSummary(instNo: '101', deptNo: '201', name: '청년상담팀'),
        DepartmentSummary(instNo: '101', deptNo: '202', name: '정책기획팀'),
      ],
      '102': const [
        DepartmentSummary(instNo: '102', deptNo: '203', name: '창업보육팀'),
      ],
      '103': const [
        DepartmentSummary(instNo: '103', deptNo: '204', name: '주거복지팀'),
      ],
    };
    return map[instNo] ?? const [];
  }
}
