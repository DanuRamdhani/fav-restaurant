import 'package:flutter/material.dart';

customCircularProgressIndicator(BuildContext context) {
  final theme = Theme.of(context);

  return CircularProgressIndicator(
    color: theme.colorScheme.onBackground,
  );
}
