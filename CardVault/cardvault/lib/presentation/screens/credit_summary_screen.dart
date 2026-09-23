import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/stat_tile.dart';

class CreditSummaryScreen extends ConsumerWidget {
  const CreditSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(creditSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Credit summary')),
      body: summary.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(creditSummaryProvider),
        ),
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            StatTile(
              label: 'Total credit limit',
              value: '₹${data.totalLimit.toStringAsFixed(0)}',
              icon: Icons.credit_score_rounded,
            ),
            const SizedBox(height: 12),
            StatTile(
              label: 'Available credit',
              value: '₹${data.availableCredit.toStringAsFixed(0)}',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 12),
            StatTile(
              label: 'Used credit',
              value: '₹${data.usedCredit.toStringAsFixed(0)}',
              icon: Icons.pie_chart_outline_rounded,
            ),
            const SizedBox(height: 12),
            StatTile(
              label: 'Amount due',
              value: '₹${data.dueAmount.toStringAsFixed(0)}',
              icon: Icons.event_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
