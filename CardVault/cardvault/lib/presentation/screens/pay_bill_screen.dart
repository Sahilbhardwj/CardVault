import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class PayBillScreen extends ConsumerStatefulWidget {
  const PayBillScreen({super.key});

  @override
  ConsumerState<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends ConsumerState<PayBillScreen> {
  final amount = TextEditingController();

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bills = ref.watch(billsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pay bill')),
      body: bills.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(billsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No bills found.'));
          }

          final bill = items.first;
          if (amount.text.isEmpty) {
            amount.text = bill.amount.toString();
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    bill.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    bill.status + (bill.dueDate.isEmpty ? '' : ' • ${bill.dueDate}'),
                  ),
                  trailing: Text(
                    '₹${bill.amount.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Payment amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () => _pay(bill.id),
                child: const Text('Pay bill'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pay(String billId) async {
    final value = num.tryParse(amount.text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid payment amount')),
      );
      return;
    }

    try {
      await ref.read(billPaymentRepositoryProvider).payBill(
            id: billId,
            amount: value,
            idempotencyKey:
                'flutter-${DateTime.now().microsecondsSinceEpoch}',
          );

      ref.invalidate(billsProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment submitted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }
}
