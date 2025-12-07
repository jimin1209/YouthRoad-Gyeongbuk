import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/values/policy_feed_type.dart';

enum UIReactionPhase {
  idle,
  skeleton,
  success,
  unchanged,
  failure,
  confirmed,
}

@immutable
class UIReactionState {
  final UIReactionPhase phase;
  final String message;
  final String? queryHash;
  final DateTime updatedAt;
  final DateTime? lockUntil;

  UIReactionState({
    this.phase = UIReactionPhase.idle,
    this.message = '',
    this.queryHash,
    DateTime? updatedAt,
    this.lockUntil,
  }) : updatedAt = updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  bool get isActive => phase != UIReactionPhase.idle;

  bool get shouldHoldSkeleton {
    if (lockUntil == null) return false;
    return DateTime.now().isBefore(lockUntil!);
  }

  UIReactionState copyWith({
    UIReactionPhase? phase,
    String? message,
    String? queryHash,
    DateTime? updatedAt,
    DateTime? lockUntil,
  }) {
    return UIReactionState(
      phase: phase ?? this.phase,
      message: message ?? this.message,
      queryHash: queryHash ?? this.queryHash,
      updatedAt: updatedAt ?? this.updatedAt,
      lockUntil: lockUntil ?? this.lockUntil,
    );
  }
}

class UIReactionController extends StateNotifier<UIReactionState> {
  UIReactionController({
    required this.feedType,
  }) : super(UIReactionState());

  final PolicyFeedType feedType;

  static const _debounce = Duration(milliseconds: 320);
  static const _holdSkeleton = Duration(milliseconds: 400);
  static const _toastDuration = Duration(milliseconds: 1500);

  Timer? _clearTimer;
  Timer? _pendingTimer;
  UIReactionPhase? _lastPhase;
  String? _lastMessage;
  DateTime? _lastEventAt;

  void markLoading(String queryHash, {required bool isInitialLoad}) {
    _cancelPending();
    final now = DateTime.now();
    if (_shouldDebounce(UIReactionPhase.skeleton, queryHash)) return;

    state = UIReactionState(
      phase: UIReactionPhase.skeleton,
      message: '결과를 준비하고 있어요...',
      queryHash: queryHash,
      updatedAt: now,
      lockUntil: now.add(_holdSkeleton),
    );
  }

  void markRestored(String queryHash) {
    _showTransient(
      phase: UIReactionPhase.unchanged,
      message: '동일한 조건이에요. 최근 결과를 보여드려요.',
      queryHash: queryHash,
    );
  }

  void markResult({
    required String queryHash,
    required bool changed,
  }) {
    _cancelPending();
    final delay = _remainingSkeletonHold();
    if (delay > Duration.zero) {
      _pendingTimer = Timer(delay, () {
        _pendingTimer = null;
        _setResult(queryHash: queryHash, changed: changed);
      });
    } else {
      _setResult(queryHash: queryHash, changed: changed);
    }
  }

  void markFailure({
    required String queryHash,
    required String message,
  }) {
    _showTransient(
      phase: UIReactionPhase.failure,
      message: message,
      queryHash: queryHash,
    );
  }

  void markFilterConfirmed(String summary) {
    _showTransient(
      phase: UIReactionPhase.confirmed,
      message: summary,
      queryHash: state.queryHash,
    );
  }

  void markSearchConfirmed(String keyword) {
    final summary = keyword.trim().isEmpty
        ? '검색어가 지워졌어요. 전체 결과를 보여드려요.'
        : '"$keyword" 검색을 시작해요.';
    _showTransient(
      phase: UIReactionPhase.confirmed,
      message: summary,
      queryHash: state.queryHash,
    );
  }

  void markUnchanged(String queryHash) {
    _showTransient(
      phase: UIReactionPhase.unchanged,
      message: '변경된 조건이 없어요.',
      queryHash: queryHash,
    );
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    _pendingTimer?.cancel();
    super.dispose();
  }

  bool _shouldDebounce(UIReactionPhase phase, String messageKey) {
    if (_lastPhase != phase || _lastMessage != messageKey) {
      _lastPhase = phase;
      _lastMessage = messageKey;
      _lastEventAt = DateTime.now();
      return false;
    }

    final now = DateTime.now();
    final last = _lastEventAt;
    if (last != null && now.difference(last) < _debounce) {
      return true;
    }

    _lastEventAt = now;
    return false;
  }

  void _setResult({
    required String queryHash,
    required bool changed,
  }) {
    _showTransient(
      phase: changed ? UIReactionPhase.success : UIReactionPhase.unchanged,
      message: changed ? '최신 결과로 업데이트됐어요.' : '결과가 이미 최신입니다.',
      queryHash: queryHash,
    );
  }

  void _showTransient({
    required UIReactionPhase phase,
    required String message,
    required String? queryHash,
  }) {
    if (queryHash != null && _shouldDebounce(phase, queryHash)) return;

    _cancelPending();
    _clearTimer?.cancel();

    state = state.copyWith(
      phase: phase,
      message: message,
      queryHash: queryHash,
      updatedAt: DateTime.now(),
      lockUntil: null,
    );

    _clearTimer = Timer(_toastDuration, () {
      state = state.copyWith(phase: UIReactionPhase.idle, message: '');
    });
  }

  void _cancelPending() {
    _pendingTimer?.cancel();
    _pendingTimer = null;
  }

  Duration _remainingSkeletonHold() {
    final lock = state.lockUntil;
    if (lock == null) return Duration.zero;
    final now = DateTime.now();
    if (now.isAfter(lock)) return Duration.zero;
    return lock.difference(now);
  }
}

final uiReactionControllerProvider =
    StateNotifierProvider.family<UIReactionController, UIReactionState,
        PolicyFeedType>(
  (ref, feedType) {
    return UIReactionController(feedType: feedType);
  },
);
