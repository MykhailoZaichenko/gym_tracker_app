import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final FirestoreService _firestore = FirestoreService();

  void initDeepLinks(BuildContext context) {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleIncomingLink(uri, context);
    });

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleIncomingLink(uri, context);
      },
      onError: (err) {
        debugPrint('Помилка перехоплення посилання: $err');
      },
    );
  }

  Future<void> _handleIncomingLink(Uri uri, BuildContext context) async {
    if (uri.path == '/addfriend') {
      final friendUid = uri.queryParameters['uid'];

      if (friendUid != null && friendUid.isNotEmpty) {
        try {
          await _firestore.sendFriendRequest(friendUid);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Запит у друзі через посилання успішно надіслано!',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Помилка додавання: $e'),
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
