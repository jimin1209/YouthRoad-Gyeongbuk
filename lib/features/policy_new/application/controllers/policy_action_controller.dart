import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/policy.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../providers.dart';
import 'policy_reminder_controller.dart';
import '../models/user_collections.dart';

class PolicyActionState {
  final bool isFavorite;
  final bool isCompared;
  final AsyncValue<PolicyReminderViewState> reminderState;
  final bool isProcessing;
  final String? errorMessage;

  const PolicyActionState({
    required this.isFavorite,
    required this.isCompared,
    required this.reminderState,
    this.isProcessing = false,
    this.errorMessage,
  });

  bool get hasReminder => reminderState.maybeWhen(
        data: (reminders) => reminders.reminders.isNotEmpty,
        orElse: () => false,
      );

  PolicyActionState copyWith({
    bool? isFavorite,
    bool? isCompared,
    AsyncValue<PolicyReminderViewState>? reminderState,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return PolicyActionState(
      isFavorite: isFavorite ?? this.isFavorite,
      isCompared: isCompared ?? this.isCompared,
      reminderState: reminderState ?? this.reminderState,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
    );
  }
}

class PolicyActionController extends StateNotifier<PolicyActionState> {
  PolicyActionController({required this.ref, required this.policyId})
      : super(
          PolicyActionState(
            isFavorite: ref.read(favoriteIdsProvider).contains(policyId),
            isCompared: ref.read(compareRepositoryProvider).ids.contains(policyId),
            reminderState: ref.read(policyReminderControllerProvider(policyId)),
          ),
        ) {
    _listenToCollections();
  }

  final Ref ref;
  final String policyId;

  void _listenToCollections() {
    ref.listen<Set<String>>(favoriteIdsProvider, (prev, next) {
      state = state.copyWith(
        isFavorite: next.contains(policyId),
        errorMessage: state.errorMessage,
      );
    });

    ref.listen<CompareRepository>(compareRepositoryProvider, (prev, next) {
      state = state.copyWith(
        isCompared: next.ids.contains(policyId),
        errorMessage: state.errorMessage,
      );
    });

    ref.listen<AsyncValue<PolicyReminderViewState>> (
      policyReminderControllerProvider(policyId),
      (previous, next) {
        state = state.copyWith(reminderState: next, errorMessage: state.errorMessage);
      },
    );
  }

  void _setProcessing(bool value) {
    state = state.copyWith(isProcessing: value, errorMessage: state.errorMessage);
  }

  void _setError(String? message) {
    state = state.copyWith(errorMessage: message);
  }

  Future<void> toggleFavorite(Policy policy) async {
    if (state.isProcessing) return;
    _setProcessing(true);
    _setError(null);
    await ref.read(policyFavoriteServiceProvider).toggleFavorite(policy);
    _setProcessing(false);
  }

  Future<void> toggleCompare(Policy policy) async {
    if (state.isProcessing) return;
    _setProcessing(true);
    _setError(null);
    ref.read(compareRepositoryProvider.notifier).toggleCompare(policy);
    _setProcessing(false);
  }

  Future<void> setReminderOptions(
    Policy policy,
    List<ReminderTimeKind> options,
  ) async {
    if (state.isProcessing) return;
    _setProcessing(true);
    _setError(null);
    final controller = ref.read(policyReminderControllerProvider(policy.id).notifier);
    try {
      await controller.setReminders(policy, options);
    } catch (e) {
      _setError('알림을 설정하지 못했습니다: $e');
    } finally {
      _setProcessing(false);
    }
  }

  Future<void> setReminder(Policy policy, ReminderTimeKind option) async {
    await setReminderOptions(policy, [option]);
  }

  Future<void> cancelReminder() async {
    if (state.isProcessing) return;
    _setProcessing(true);
    _setError(null);
    final controller = ref.read(policyReminderControllerProvider(policyId).notifier);
    try {
      await controller.cancelAll();
    } catch (e) {
      _setError('알림을 취소하지 못했습니다: $e');
    } finally {
      _setProcessing(false);
    }
  }

  Future<bool> openPolicyLink(Policy policy) async {
    if (state.isProcessing) return false;
    final url = _resolveUrl(policy);
    if (url == null) {
      _setError('신청 링크가 제공되지 않았습니다.');
      return false;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      _setError('잘못된 링크 형식입니다.');
      return false;
    }

    if (!await canLaunchUrl(uri)) {
      _setError('이 링크를 열 수 없습니다.');
      return false;
    }

    _setProcessing(true);
    _setError(null);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      _setError('링크를 여는 중 오류가 발생했습니다: $e');
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  String? _resolveUrl(Policy policy) {
    if (policy.applyUrl.isNotEmpty) return policy.applyUrl;
    if (policy.detailUrl != null && policy.detailUrl!.isNotEmpty) return policy.detailUrl;
    return null;
  }
}
