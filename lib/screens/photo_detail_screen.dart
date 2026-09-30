import 'package:flutter/material.dart';

import '../models/photo.dart';
import 'package:provider/provider.dart';
import '../providers/saved_provider.dart';

class PhotoDetailScreen extends StatelessWidget {
  final Photo photo;

  const PhotoDetailScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedProvider>();
final isSaved = savedProvider.isSaved(photo.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo'),
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         AspectRatio(
  aspectRatio: photo.width / photo.height,
  child: Image.network(
    photo.largeImageUrl,
    width: double.infinity,
    fit: BoxFit.contain,
  ),
),
const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Photographer: ${photo.photographer}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
  child: ElevatedButton.icon(
  onPressed: () async {
    await context.read<SavedProvider>().toggleSave(photo);
  },
  icon: AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    transitionBuilder: (child, animation) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
    child: Icon(
      isSaved ? Icons.bookmark : Icons.bookmark_border,
      key: ValueKey(isSaved),
    ),
  ),
  label: AnimatedSwitcher(
    duration: const Duration(milliseconds: 200),
    child: Text(
      isSaved ? 'Saved' : 'Save',
      key: ValueKey(isSaved),
    ),
  ),
)
          ),
        ],
        ),
      ),
    );
  }
}