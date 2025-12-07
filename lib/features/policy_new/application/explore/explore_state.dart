enum ExploreSubMode { all, region, search }

enum PolicyStatusFilter {
  inProgressOnly,
  includeClosed,
  closedOnly,
}

enum PolicySortKind {
  recommended,
  newest,
  deadline,
  amount,
}

class ExploreState {
  const ExploreState({
    this.mode = ExploreSubMode.all,
    this.keyword = '',
  });

  final ExploreSubMode mode;
  final String keyword;

  ExploreState copyWith({
    ExploreSubMode? mode,
    String? keyword,
  }) {
    return ExploreState(
      mode: mode ?? this.mode,
      keyword: keyword ?? this.keyword,
    );
  }
}
