import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/providers.dart';

class BlockCardScreen extends ConsumerStatefulWidget {
  const BlockCardScreen({super.key, required this.cardId});

  final String cardId;

  @override
  ConsumerState<BlockCardScreen> createState() => _BlockCardScreenState();
}

class _BlockCardScreenState extends ConsumerState<BlockCardScreen> {
  bool loading = false;

  Future<void> _block() async {
    setState(() => loading = true);

    try {
      final authenticated = await ref
          .read(biometricServiceProvider)
          .authenticate(reason: 'Confirm card blocking');

      if (!authenticated) return;

      await ref.read(cardRepositoryProvider).blockCard(widget.cardId);
      ref.invalidate(cardProvider(widget.cardId));
      ref.invalidate(cardsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card blocked')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to block card: $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block card')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_rounded, size: 72),
            const SizedBox(height: 20),
            const Text(
              'Block this card?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            const Text(
              'New transactions will be declined. You can add an unblock flow later when the backend supports it.',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FilledButton(
              onPressed: loading ? null : _block,
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Confirm block'),
            ),
          ],
        ),
      ),
    );
  }
}
