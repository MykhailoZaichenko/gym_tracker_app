import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final FirestoreService _firestore = FirestoreService();

  void initDeepLinks(BuildContext context) {
    _appLinks.getInitialLink().then((uri) {
      if (!context.mounted) return;
      if (uri != null) _handleIncomingLink(uri, context);
    });

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        if (!context.mounted) return;
        _handleIncomingLink(uri, context);
      },
      onError: (err) {
        debugPrint('Помилка перехоплення посилання: $err');
      },
    );
  }

  Future<void> _handleIncomingLink(Uri uri, BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    if (uri.path == '/addfriend') {
      final friendUid = uri.queryParameters['uid'];

      if (friendUid != null && friendUid.isNotEmpty) {
        try {
          await _firestore.sendFriendRequest(friendUid);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.friendRequestSent),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.additionError(e.toString())),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
