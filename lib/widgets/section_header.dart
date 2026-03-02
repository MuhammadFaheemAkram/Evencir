import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
