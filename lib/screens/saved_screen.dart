import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/saved_provider.dart';
import '../widgets/photo_tile.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedProvider>();
    final savedPhotos = savedProvider.savedPhotos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
     body: savedProvider.isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : savedPhotos.isEmpty
        ? const Center(
            child: Text('No saved photos yet'),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: savedPhotos.length,
            itemBuilder: (context, index) {
              return PhotoTile(
                photo: savedPhotos[index],
              );
            },
          ),
    );
  }
}