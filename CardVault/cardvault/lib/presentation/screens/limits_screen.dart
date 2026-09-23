import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/limits.dart';
import '../../state/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class LimitsScreen extends ConsumerStatefulWidget {
  const LimitsScreen({
    super.key,
    required this.cardId,
  });

  final String cardId;

  @override
  ConsumerState<LimitsScreen> createState() => _LimitsScreenState();
}

class _LimitsScreenState extends ConsumerState<LimitsScreen> {
  final purchase = TextEditingController();
  final atm = TextEditingController();
  final contactless = TextEditingController();

  bool _seeded = false;

  @override
  void dispose() {
    purchase.dispose();
    atm.dispose();
    contactless.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final limits = ref.watch(
      limitsProvider(widget.cardId),
    );

    final controller = ref.watch(
      limitsControllerProvider(widget.cardId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Limits'),
      ),
      body: limits.when(
        loading: () => const LoadingView(),

        error: (e, _) => ErrorView(
          error: e,
          onRetry: () {
            ref.invalidate(
              limitsProvider(widget.cardId),
            );
          },
        ),

        data: (data) {
          _seed(data);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _field(
                'Daily purchase',
                purchase,
              ),

              const SizedBox(height: 14),

              _field(
                'Daily ATM',
                atm,
              ),

              const SizedBox(height: 14),

              _field(
                'Contactless',
                contactless,
              ),

              const SizedBox(height: 24),

              FilledButton(
                onPressed: controller.isLoading ? null : _save,
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save limits'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _seed(LimitsModel data) {
    if (_seeded) return;

    _seeded = true;

    purchase.text = data.dailyPurchase.toString();
    atm.text = data.dailyAtm.toString();
    contactless.text = data.contactless.toString();
  }

  Future<void> _save() async {
    final values = LimitsModel(
      dailyPurchase: num.tryParse(purchase.text) ?? 0,
      dailyAtm: num.tryParse(atm.text) ?? 0,
      contactless: num.tryParse(contactless.text) ?? 0,
    );

    await ref
        .read(
          limitsControllerProvider(widget.cardId).notifier,
        )
        .updateLimits(values);

    if (!mounted) return;

    final state = ref.read(
      limitsControllerProvider(widget.cardId),
    );

    state.whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Limits updated'),
          ),
        );
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: $e'),
          ),
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixText: '₹ ',
        border: const OutlineInputBorder(),
      ),
    );
  }
}