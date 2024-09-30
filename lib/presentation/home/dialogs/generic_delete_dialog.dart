import 'package:flutter/material.dart';

class GenericDeleteDialog extends StatelessWidget {
  final String itemName; // Name of the item being deleted
  final Future<bool> Function()
      onConfirmTap; // Async callback returning a success status

  const GenericDeleteDialog({
    super.key,
    required this.itemName,
    required this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirm Deletion',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "$itemName"?'),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Flexible(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No, cancel'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Store the current context
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      // Show loading dialog
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      // Call the provided callback and await the result
                      bool success = await onConfirmTap();

                      // Close the loading dialog (don't await since it returns void)
                      if (navigator.mounted) navigator.pop();

                      // Show a success or error message
                      if (success) {
                        // If success, show a success message
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Item deleted successfully.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        // If failure, show an error message
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete the item.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }

                      // Close the confirmation dialog (don't await since it returns void)
                      if (navigator.mounted) navigator.pop();
                    },
                    child: const Text('Yes, Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
