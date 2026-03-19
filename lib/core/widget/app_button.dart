import 'package:flutter/material.dart';
import 'package:ridefi_assessment/core/extension/context.extensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    super.key,
    this.text,
    this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderSide,
  }) : _type = _AppButtonType.primary;

  const AppButton.secondary({
    required this.onPressed,
    super.key,
    this.text,
    this.child,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderSide,
  }) : _type = _AppButtonType.secondary;

  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;

  final _AppButtonType _type;

  @override
  Widget build(BuildContext context) {
    const defaultPrimaryColor = Colors.blue;

    var content = child ?? Text(text ?? '');
    if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Flexible(child: content),
        ],
      );
    }

    ButtonStyle style;
    if (_type == _AppButtonType.primary) {
      style = ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultPrimaryColor,
        foregroundColor: foregroundColor ?? context.theme.colorScheme.onPrimary,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: borderSide ?? BorderSide.none,
        ),
        textStyle: context.semiBold14,
        elevation: 0,
      );
    } else {
      style = OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? defaultPrimaryColor,
        side: borderSide ?? const BorderSide(color: defaultPrimaryColor),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: context.semiBold14,
        elevation: 0,
      );
    }

    Widget button;
    if (_type == _AppButtonType.primary) {
      button = ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: content,
      );
    } else {
      button = OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: content,
      );
    }

    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
}

enum _AppButtonType { primary, secondary }
