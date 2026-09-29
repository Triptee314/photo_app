import 'package:flutter/material.dart';

class SavedProvider extends ChangeNotifier {
  final Set<int> _savedPhotoIds = {};

  bool isSaved(int photoId) {
    return _savedPhotoIds.contains(photoId);
  }

  void toggleSave(int photoId) {
    if (_savedPhotoIds.contains(photoId)) {
      _savedPhotoIds.remove(photoId);
    } else {
      _savedPhotoIds.add(photoId);
    }

    notifyListeners();
  }
}