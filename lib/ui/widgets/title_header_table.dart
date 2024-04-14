import 'package:flutter/material.dart';

class TitleHeaderTable extends StatelessWidget {
  const TitleHeaderTable({
    super.key,
    required this.titleHeader,
  });

  final String titleHeader;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(titleHeader, textAlign: TextAlign.center),
      ),
    );
  }
}
