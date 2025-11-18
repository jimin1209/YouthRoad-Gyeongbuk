import '../../policy/data/models/policy.dart';

enum BookmarkFolder { favorite, planning, pending }

enum BookmarkSortOption { recent, region, category }

extension BookmarkFolderLabel on BookmarkFolder {
  String get label {
    switch (this) {
      case BookmarkFolder.favorite:
        return '관심';
      case BookmarkFolder.planning:
        return '지원예정';
      case BookmarkFolder.pending:
        return '보류';
    }
  }
}

class BookmarkEntry {
  final Policy policy;
  final BookmarkFolder folder;
  final DateTime savedAt;

  const BookmarkEntry({
    required this.policy,
    required this.folder,
    required this.savedAt,
  });

  BookmarkEntry copyWith({
    BookmarkFolder? folder,
    DateTime? savedAt,
  }) {
    return BookmarkEntry(
      policy: policy,
      folder: folder ?? this.folder,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policy': policy.toJson(),
      'folder': folder.name,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory BookmarkEntry.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('policy')) {
      return BookmarkEntry(
        policy: Policy.fromJson(
          Map<String, dynamic>.from(json['policy'] as Map<String, dynamic>),
        ),
        folder: BookmarkFolder.values
            .firstWhere((folder) => folder.name == json['folder'], orElse: () => BookmarkFolder.favorite),
        savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime.now(),
      );
    }

    // Legacy format: the entire JSON represents a Policy only.
    return BookmarkEntry(
      policy: Policy.fromJson(json),
      folder: BookmarkFolder.favorite,
      savedAt: DateTime.now(),
    );
  }
}
