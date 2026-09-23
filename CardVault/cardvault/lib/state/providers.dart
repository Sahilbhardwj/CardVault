import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/services/biometric_service.dart';
import '../data/models/card.dart';
import '../data/models/controls.dart';
import '../data/models/limits.dart';
import '../data/models/statement.dart';
import '../data/models/bill.dart';
import '../data/models/credit_summary.dart';
import '../data/models/reveal_card.dart';
import '../data/repositories/card_repository.dart';
import '../data/repositories/statement_repository.dart';
import '../data/repositories/bill_payment_repository.dart';
import '../data/repositories/credit_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final cardRepositoryProvider = Provider<CardRepository>((ref) {
  return CardRepository(ref.watch(apiClientProvider));
});

final statementRepositoryProvider = Provider<StatementRepository>((ref) {
  return StatementRepository(ref.watch(apiClientProvider));
});

final billPaymentRepositoryProvider =
    Provider<BillPaymentRepository>((ref) {
  return BillPaymentRepository(ref.watch(apiClientProvider));
});

final creditRepositoryProvider = Provider<CreditRepository>((ref) {
  return CreditRepository(ref.watch(apiClientProvider));
});

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});


// ============================================================
// CARDS
// ============================================================

final cardsProvider = FutureProvider.autoDispose<List<CardModel>>((ref) {
  return ref.read(cardRepositoryProvider).getCards();
});

final cardProvider =
    FutureProvider.autoDispose.family<CardModel, String>((ref, cardId) {
  return ref.read(cardRepositoryProvider).getCard(cardId);
});


// ============================================================
// CONTROLS
// ============================================================

final controlsProvider =
    FutureProvider.autoDispose.family<ControlsModel, String>(
  (ref, cardId) {
    return ref.read(cardRepositoryProvider).getControls(cardId);
  },
);

class ControlsController extends AsyncNotifier<ControlsModel> {
  ControlsController(this.cardId);

  final String cardId;

  @override
  Future<ControlsModel> build() {
    return ref.read(cardRepositoryProvider).getControls(cardId);
  }

  Future<void> updateControls(ControlsModel controls) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(cardRepositoryProvider)
          .updateControls(cardId, controls),
    );

    ref.invalidate(controlsProvider(cardId));
  }
}

final controlsControllerProvider =
    AsyncNotifierProvider.autoDispose.family<
        ControlsController,
        ControlsModel,
        String>(
  ControlsController.new,
);


// ============================================================
// LIMITS
// ============================================================

final limitsProvider =
    FutureProvider.autoDispose.family<LimitsModel, String>(
  (ref, cardId) {
    return ref.read(cardRepositoryProvider).getLimits(cardId);
  },
);

class LimitsController extends AsyncNotifier<LimitsModel> {
  LimitsController(this.cardId);

  final String cardId;

  @override
  Future<LimitsModel> build() {
    return ref.read(cardRepositoryProvider).getLimits(cardId);
  }

  Future<void> updateLimits(LimitsModel limits) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(cardRepositoryProvider)
          .updateLimits(cardId, limits),
    );

    ref.invalidate(limitsProvider(cardId));
  }
}

final limitsControllerProvider =
    AsyncNotifierProvider.autoDispose.family<
        LimitsController,
        LimitsModel,
        String>(
  LimitsController.new,
);


// ============================================================
// STATEMENTS
// ============================================================

final statementsProvider =
    FutureProvider.autoDispose<List<StatementModel>>((ref) {
  return ref.read(statementRepositoryProvider).getStatements();
});


// ============================================================
// BILLS
// ============================================================

final billsProvider =
    FutureProvider.autoDispose<List<BillModel>>((ref) {
  return ref.read(billPaymentRepositoryProvider).getBills();
});


// ============================================================
// CREDIT SUMMARY
// ============================================================

final creditSummaryProvider =
    FutureProvider.autoDispose<CreditSummaryModel>((ref) {
  return ref.read(creditRepositoryProvider).getSummary();
});


// ============================================================
// REVEAL CARD
// ============================================================

final revealCardProvider =
    FutureProvider.autoDispose.family<RevealedCardModel, String>(
  (ref, cardId) {
    return ref.read(cardRepositoryProvider).revealCard(cardId);
  },
);