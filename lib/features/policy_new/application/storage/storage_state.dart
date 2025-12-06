class StorageCounts {
  const StorageCounts({
    required this.favorites,
    required this.compare,
    this.reminders,
  });

  final int favorites;
  final int compare;
  final int? reminders;
}
