import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum LocationBottomSheetIssue {
  serviceDisabled,
  permissionDenied,
  permissionPermanentlyDenied,
}

Future<void> showLocationPermissionBottomSheet(
  BuildContext context, {
  required LocationBottomSheetIssue issue,
}) async {
  final title = _issueTitle(issue);
  final description = _issueDescription(issue);
  final actionLabel = issue == LocationBottomSheetIssue.serviceDisabled
      ? 'Open GPS settings'
      : 'Open app settings';

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(ctx).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: Theme.of(ctx)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _openSettings(issue);
            },
            child: Text(actionLabel),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}

String _issueTitle(LocationBottomSheetIssue issue) {
  switch (issue) {
    case LocationBottomSheetIssue.serviceDisabled:
      return 'Location service is disabled';
    case LocationBottomSheetIssue.permissionDenied:
      return 'Location permission denied';
    case LocationBottomSheetIssue.permissionPermanentlyDenied:
      return 'Location permission permanently denied';
  }
}

String _issueDescription(LocationBottomSheetIssue issue) {
  switch (issue) {
    case LocationBottomSheetIssue.serviceDisabled:
      return 'GPS or location services are turned off. Please enable them to continue.';
    case LocationBottomSheetIssue.permissionDenied:
      return 'You previously declined the location permission. Grant it to use location-based features.';
    case LocationBottomSheetIssue.permissionPermanentlyDenied:
      return 'The app cannot request location permission again. Please allow it from the app settings.';
  }
}

Future<void> _openSettings(LocationBottomSheetIssue issue) async {
  if (Platform.isAndroid) {
    if (issue == LocationBottomSheetIssue.serviceDisabled) {
      await Geolocator.openLocationSettings();
    } else {
      await Geolocator.openAppSettings();
    }
    return;
  }
  await Geolocator.openAppSettings();
}
