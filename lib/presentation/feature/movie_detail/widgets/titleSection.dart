import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(title, style: Theme
          .of(context)
          .textTheme
          .titleMedium),
    );
  }
}
