/// 정책 피드의 종류를 나타내는 enum.
/// 기존 PolicyList V2에서 사용되던 필드를 복구한 버전.
enum PolicyFeedType {
  primary, // 기본 홈 피드
  recommended, // 추천 정책 피드
  bookmarked, // 좋아요/북마크 피드
  latest, // 최신 정책
}
