import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../state/providers.dart';
import '../widgets/card_visual.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class CardDetailScreen extends ConsumerWidget {
  const CardDetailScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(cardProvider(cardId));
    final controls = ref.watch(controlsProvider(cardId));

    return Scaffold(
      appBar: AppBar(title: const Text('Card detail')),
      body: card.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(cardProvider(cardId)),
        ),
        data: (item) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CardVisual(card: item),
            const SizedBox(height: 22),
            _StatusCard(status: item.status),
            const SizedBox(height: 20),
            const Text(
              'Card controls',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            controls.when(
              loading: () => const SizedBox(height: 100, child: LoadingView()),
              error: (e, _) => ErrorView(error: e),
              data: (c) => Column(
                children: [
                  _ControlRow('Online transactions', c.online),
                  _ControlRow('Contactless', c.contactless),
                  _ControlRow('International', c.international),
                  _ControlRow('ATM withdrawals', c.atm),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('/card/$cardId/limits'),
              icon: const Icon(Icons.tune_rounded),
              label: const Text('Manage limits'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.push('/card/$cardId/reveal'),
              icon: const Icon(Icons.visibility_rounded),
              label: const Text('Reveal card'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.push('/card/$cardId/block'),
              icon: const Icon(Icons.lock_outline_rounded),
              label: const Text('Block card'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final blocked = status.toUpperCase() == 'BLOCKED';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: blocked
            ? Theme.of(context).colorScheme.errorContainer
            : Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(blocked ? Icons.lock : Icons.check_circle_outline),
          const SizedBox(width: 12),
          Text(
            blocked ? 'Card blocked' : 'Card active',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ControlRow extends StatelessWidget {
  const _ControlRow(this.label, this.enabled);

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Icon(
        enabled ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
        size: 36,
      ),
    );
  }
}
