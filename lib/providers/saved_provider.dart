import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/photo.dart';

class SavedProvider extends ChangeNotifier {
  final Map<int, Photo> _savedPhotos = {};

  bool isLoading = true;

  StreamSubscription<User?>? _authSubscription;

  SavedProvider() {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        loadSavedPhotos();
      } else {
        _savedPhotos.clear();

        isLoading = false;
        notifyListeners();
      }
    });
  }

  bool isSaved(int photoId) {
    return _savedPhotos.containsKey(photoId);
  }

  List<Photo> get savedPhotos {
    return _savedPhotos.values.toList();
  }

  Future<void> loadSavedPhotos() async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('SavedProvider user: ${user?.uid}');

    if (user == null) {
      return;
    }

    setStateLoading(true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('savedPhotos')
          .get();
            debugPrint(
      'Firestore saved photos: ${snapshot.docs.length}',
    );


      _savedPhotos.clear();

      for (final document in snapshot.docs) {
        final photo = Photo.fromFirestore(document.data());

        _savedPhotos[photo.id] = photo;
      }
    } catch (e) {
      debugPrint('Failed to load saved photos: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleSave(Photo photo) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final photoDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedPhotos')
        .doc(photo.id.toString());

    if (_savedPhotos.containsKey(photo.id)) {
      await photoDocument.delete();

      _savedPhotos.remove(photo.id);
    } else {
      await photoDocument.set({
        'id': photo.id,
        'photographer': photo.photographer,
        'imageUrl': photo.imageUrl,
        'largeImageUrl': photo.largeImageUrl,
        'width': photo.width,
        'height': photo.height,
      });

      _savedPhotos[photo.id] = photo;
    }

    notifyListeners();
  }

  void setStateLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}