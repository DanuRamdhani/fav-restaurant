import 'package:flutter/material.dart';

void showAddReview(
  BuildContext context,
  TextEditingController nameCtrl,
  TextEditingController reviewCtrl,
  void Function() sendReview,
) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Review',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reviewCtrl,
              decoration: const InputDecoration(
                hintText: 'Your Review',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: sendReview,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onBackground,
            ),
            child: const Text('Send'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onBackground.withOpacity(0.6),
            ),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
