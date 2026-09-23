import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/providers.dart';
import '../widgets/card_visual.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_tile.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);
    final credit = ref.watch(creditSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CardVault',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(cardsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cardsProvider);
          ref.invalidate(creditSummaryProvider);
          await Future.wait([
            ref.read(cardsProvider.future),
            ref.read(creditSummaryProvider.future),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            const Text(
              'Your wallet',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage cards, limits and payments from one place.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            cards.when(
              loading: () => const SizedBox(height: 205, child: LoadingView()),
              error: (e, _) => SizedBox(
                height: 180,
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(cardsProvider),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No cards found.'),
                    ),
                  );
                }
                return CardVisual(
                  card: items.first,
                  onTap: () => context.push('/card/${items.first.id}'),
                );
              },
            ),
            const SizedBox(height: 28),
            const SectionTitle(title: 'Quick access'),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.7,
              children: [
                _QuickAction(
                  icon: Icons.credit_card_rounded,
                  label: 'Card detail',
                  onTap: () => cards.maybeWhen(
                    data: (items) {
                      if (items.isNotEmpty) {
                        context.push('/card/${items.first.id}');
                      }
                    },
                    orElse: () {},
                  ),
                ),
                _QuickAction(
                  icon: Icons.tune_rounded,
                  label: 'Limits',
                  onTap: () => cards.maybeWhen(
                    data: (items) {
                      if (items.isNotEmpty) {
                        context.push('/card/${items.first.id}/limits');
                      }
                    },
                    orElse: () {},
                  ),
                ),
                _QuickAction(
                  icon: Icons.receipt_long_rounded,
                  label: 'Statements',
                  onTap: () => context.push('/statements'),
                ),
                _QuickAction(
                  icon: Icons.payments_rounded,
                  label: 'Pay bill',
                  onTap: () => context.push('/bills'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const SectionTitle(title: 'Credit summary'),
            const SizedBox(height: 12),
            credit.when(
              loading: () => const SizedBox(height: 100, child: LoadingView()),
              error: (e, _) => ErrorView(error: e),
              data: (summary) => Column(
                children: [
                  StatTile(
                    label: 'Available credit',
                    value: '₹${summary.availableCredit.toStringAsFixed(0)}',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                  const SizedBox(height: 10),
                  StatTile(
                    label: 'Used credit',
                    value: '₹${summary.usedCredit.toStringAsFixed(0)}',
                    icon: Icons.pie_chart_outline_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
