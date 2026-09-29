import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../screens/photo_detail_screen.dart';

class PhotoTile extends StatelessWidget {
  final Photo photo;

  const PhotoTile({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(
          photo: photo,
        ),
      ),
    );
  },
  child: AspectRatio(
    aspectRatio: photo.width / photo.height,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        photo.imageUrl,
        fit: BoxFit.cover,
      ),
    ),
  ),
);
  }
}