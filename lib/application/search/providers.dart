// FILE: lib/application/search/providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/env.dart';
import '../../data/local/isar/isar_service.dart';
import '../../data/search/repositories/search_history_repository_impl.dart';
import '../../data/search/repositories/search_repository_impl.dart';
import '../../data/search/repositories/search_suggestion_repository_impl.dart';
import '../../data/search/sources/local/search_history_local_source.dart';
import '../../data/search/sources/remote/search_remote_source.dart';
import '../../data/sources/remote/inst_remote_source.dart';
import '../../data/sources/remote/policy_remote_source.dart';
import '../../domain/search/entities/search_suggestion.dart';
import '../../domain/search/repositories/search_history_repository.dart';
import '../../domain/search/repositories/search_repository.dart';
import '../../domain/search/repositories/search_suggestion_repository.dart';
import '../../domain/search/usecases/clear_search_history.dart';
import '../../domain/search/usecases/execute_search.dart';
import '../../domain/search/usecases/get_search_history.dart';
import '../../domain/search/usecases/get_search_suggestions.dart';
import '../../domain/search/usecases/remove_search_history_entry.dart';
import '../../domain/search/usecases/save_search_history_entry.dart';
import '../di.dart';
import 'controllers/search_controller.dart';
import 'controllers/search_history_controller.dart';
import 'controllers/search_suggestion_controller.dart';

// Sources
final instSearchRemoteSourceProvider = Provider<InstRemoteSource>((ref) {
  final dio = ref.watch(dioProvider);
  return InstRemoteSource(dio, apiKey: Env.youthApiKey);
});

final searchRemoteSourceProvider = Provider<SearchRemoteSource>((ref) {
  final policyRemote = ref.watch(policyRemoteSourceProvider);
  final instRemote = ref.watch(instSearchRemoteSourceProvider);
  return SearchRemoteSource(policyRemote, instRemote);
});

final searchHistoryLocalSourceProvider =
    Provider<SearchHistoryLocalSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SearchHistoryLocalSource(prefs);
});

// Repositories
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteSource = ref.watch(searchRemoteSourceProvider);
  final isar = ref.watch(isarServiceProvider);
  return SearchRepositoryImpl(remoteSource, isar);
});

final searchSuggestionRepositoryProvider =
    Provider<SearchSuggestionRepository>((ref) {
  final historyLocal = ref.watch(searchHistoryLocalSourceProvider);
  return SearchSuggestionRepositoryImpl(historyLocal);
});

final searchHistoryRepositoryProvider =
    Provider<SearchHistoryRepository>((ref) {
  final local = ref.watch(searchHistoryLocalSourceProvider);
  return SearchHistoryRepositoryImpl(local);
});

// Use cases
final executeSearchProvider = Provider<ExecuteSearch>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return ExecuteSearch(repository);
});

final getSearchSuggestionsProvider =
    Provider<GetSearchSuggestions>((ref) {
  final repository = ref.watch(searchSuggestionRepositoryProvider);
  return GetSearchSuggestions(repository);
});

final getSearchHistoryProvider = Provider<GetSearchHistory>((ref) {
  final repository = ref.watch(searchHistoryRepositoryProvider);
  return GetSearchHistory(repository);
});

final saveSearchHistoryProvider = Provider<SaveSearchHistoryEntry>((ref) {
  final repository = ref.watch(searchHistoryRepositoryProvider);
  return SaveSearchHistoryEntry(repository);
});

final removeSearchHistoryProvider =
    Provider<RemoveSearchHistoryEntry>((ref) {
  final repository = ref.watch(searchHistoryRepositoryProvider);
  return RemoveSearchHistoryEntry(repository);
});

final clearSearchHistoryProvider = Provider<ClearSearchHistory>((ref) {
  final repository = ref.watch(searchHistoryRepositoryProvider);
  return ClearSearchHistory(repository);
});

// Controllers
final searchControllerProvider =
    AutoDisposeNotifierProvider<SearchController, SearchState>(
  SearchController.new,
);

final searchSuggestionControllerProvider =
    AutoDisposeAsyncNotifierProvider<SearchSuggestionController,
        List<SearchSuggestion>>(SearchSuggestionController.new);

final searchHistoryControllerProvider =
    AutoDisposeNotifierProvider<SearchHistoryController, SearchHistoryState>(
  SearchHistoryController.new,
);
