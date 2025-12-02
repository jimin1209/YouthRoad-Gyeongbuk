import '../values/policy_category.dart';
import '../values/policy_region.dart';

class Policy {
  final String id;
  final String title;
  final String summary;
  final String description;
  final PolicyRegion region;
  final PolicyCategory category;
  final List<String> tags;
  final List<String> keywords;
  final DateTime? applicationStartDate;
  final DateTime? applicationEndDate;
  final DateTime? announceDate;
  final bool isOnline;
  final bool isOffline;
  final int? minAge;
  final int? maxAge;
  final bool isForYouth;
  final String? incomeCondition;
  final String? educationCondition;
  final String? employmentCondition;
  final String applyUrl;
  final String? attachmentUrl;
  final String institution;
  final String department;
  final String? contact;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Policy({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.region,
    required this.category,
    required this.tags,
    required this.keywords,
    required this.applicationStartDate,
    required this.applicationEndDate,
    required this.announceDate,
    required this.isOnline,
    required this.isOffline,
    required this.minAge,
    required this.maxAge,
    required this.isForYouth,
    required this.incomeCondition,
    required this.educationCondition,
    required this.employmentCondition,
    required this.applyUrl,
    required this.attachmentUrl,
    required this.institution,
    required this.department,
    required this.contact,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOngoing {
    final now = DateTime.now();
    if (applicationStartDate == null || applicationEndDate == null) {
      return false;
    }
    return applicationStartDate!.isBefore(now) && applicationEndDate!.isAfter(now);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    if (applicationStartDate == null) return false;
    return applicationStartDate!.isAfter(now);
  }

  bool get isClosed {
    final now = DateTime.now();
    if (applicationEndDate == null) return false;
    return applicationEndDate!.isBefore(now);
  }
}
