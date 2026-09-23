import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';

class StatementsScreen extends ConsumerWidget {
  const StatementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statements = ref.watch(statementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statements')),
      body: statements.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(statementsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No statements found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.receipt_long_rounded),
                  ),
                  title: Text(
                    item.month.isEmpty ? 'Statement' : item.month,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: item.status.isEmpty ? null : Text(item.status),
                  trailing: Text(
                    '₹${item.amount.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
