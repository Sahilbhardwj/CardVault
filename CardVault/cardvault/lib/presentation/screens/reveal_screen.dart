import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class RevealScreen extends ConsumerWidget {
  const RevealScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reveal = ref.watch(revealCardProvider(cardId));

    return Scaffold(
      appBar: AppBar(title: const Text('Reveal card')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.security_rounded),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demo flow: card credentials are fetched from the development backend. '
                    'Production should use a secure vault/HSM and biometric authorization.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          reveal.when(
            loading: () => const SizedBox(height: 180, child: LoadingView()),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(revealCardProvider(cardId)),
            ),
            data: (data) => Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Card number', data.pan),
                    _row('CVV', data.cvv),
                    _row('Expiry', data.expiry),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          SelectableText(
            value.isEmpty ? 'Not supplied by backend' : value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
