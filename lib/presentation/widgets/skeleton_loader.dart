import 'package:flutter/material.dart';

/// A simple shimmering placeholder used while content loads.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class SkeletonChatBubble extends StatelessWidget {
  const SkeletonChatBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(width: 32, height: 32, borderRadius: 16),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 80, height: 12),
                SizedBox(height: 8),
                SkeletonLoader(height: 60, borderRadius: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
