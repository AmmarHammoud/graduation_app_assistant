import 'package:flutter/material.dart';

/// Shows a simple error dialog. Uses Flutter's built-in [showDialog] so the
/// app doesn't depend on external dialog packages. This function matches the
/// usage in `sign_in_view.dart` (name: `showerrorDialog`).
void showerrorDialog({
  required BuildContext context,
  required String title,
  required String description,
}) {
  showDialog<void>(
	context: context,
	barrierDismissible: true,
	builder: (BuildContext ctx) {
	  return AlertDialog(
		title: Text(title),
		content: Text(description),
		actions: <Widget>[
		  TextButton(
			onPressed: () => Navigator.of(ctx).pop(),
			child: const Text('حسناً'),
		  ),
		],
	  );
	},
  );
}
