import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../screens/photo_detail_screen.dart';

class PhotoTile extends StatefulWidget {
  final Photo photo;

  const PhotoTile({
    super.key,
    required this.photo,
  });

  @override
  State<PhotoTile> createState() => _PhotoTileState();
}

class _PhotoTileState extends State<PhotoTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoDetailScreen(
                  photo: widget.photo,
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: widget.photo.width / widget.photo.height,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.photo.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}