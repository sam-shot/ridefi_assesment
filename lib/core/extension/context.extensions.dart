import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';

extension ThemeContextExtension on BuildContext {
  TextStyle? get regular14 => AppTypography.regular14;

  TextStyle? get semiBold14 => AppTypography.semiBold14;

  /// Returns the current [ThemeData] from the context.
  ThemeData get theme => Theme.of(this);
}
