
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/resource/colors_manager.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Browse",style: Theme.of(context).textTheme.titleLarge,)
      ],
    );
  }
}
