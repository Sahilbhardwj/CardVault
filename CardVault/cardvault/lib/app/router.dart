import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/wallet_screen.dart';
import '../presentation/screens/card_detail_screen.dart';
import '../presentation/screens/limits_screen.dart';
import '../presentation/screens/reveal_screen.dart';
import '../presentation/screens/credit_summary_screen.dart';
import '../presentation/screens/statements_screen.dart';
import '../presentation/screens/pay_bill_screen.dart';
import '../presentation/screens/block_card_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const WalletScreen(),
      ),
      GoRoute(
        path: '/card/:cardId',
        builder: (_, state) => CardDetailScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
      GoRoute(
        path: '/card/:cardId/limits',
        builder: (_, state) => LimitsScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
      GoRoute(
        path: '/card/:cardId/reveal',
        builder: (_, state) => RevealScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
      GoRoute(
        path: '/credit',
        builder: (_, __) => const CreditSummaryScreen(),
      ),
      GoRoute(
        path: '/statements',
        builder: (_, __) => const StatementsScreen(),
      ),
      GoRoute(
        path: '/bills',
        builder: (_, __) => const PayBillScreen(),
      ),
      GoRoute(
        path: '/card/:cardId/block',
        builder: (_, state) => BlockCardScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
    ],
  );
});
