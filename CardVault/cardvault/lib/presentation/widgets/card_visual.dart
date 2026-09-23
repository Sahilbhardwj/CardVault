import 'package:flutter/material.dart';
import '../../data/models/card.dart';

class CardVisual extends StatelessWidget {
  const CardVisual({
    super.key,
    required this.card,
    this.onTap,
  });

  final CardModel card;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 205,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF153E36),
              Color(0xFF237E69),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              offset: const Offset(0, 10),
              color: Colors.black.withValues(alpha: 0.12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.contactless_rounded, color: Colors.white),
                const Spacer(),
                Text(
                  card.network,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '••••  ••••  ••••  ${card.last4}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    card.cardholderName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  card.expiry,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
