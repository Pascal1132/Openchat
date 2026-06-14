import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Date/time formatting helpers.
extension DateTimeFormatting on DateTime {
  String toChatTimestamp() {
    final now = DateTime.now();
    final local = toLocal();
    final isToday = local.year == now.year && local.month == now.month && local.day == now.day;
    if (isToday) return DateFormat.Hm().format(local);
    return DateFormat.yMd().add_Hm().format(local);
  }
}

/// String capitalization helpers.
extension StringCasing on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// AsyncValue helpers.
extension AsyncValueUI<T> on AsyncValue<T> {
  String? get errorMessage => when(
        data: (_) => null,
        error: (Object err, _) => err.toString(),
        loading: () => null,
      );
}
