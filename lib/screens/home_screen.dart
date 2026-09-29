import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../services/pexels_service.dart';
import '../widgets/photo_tile.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PexelsService pexelsService = PexelsService();

  List<Photo> photos = [];

bool isLoading = true;
bool isLoadingMore = false;

String? errorMessage;

int currentPage = 1;

final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);

    loadPhotos();
  }
  void onScroll() {
  if (!scrollController.hasClients) {
    return;
  }

  if (scrollController.position.pixels >=
      scrollController.position.maxScrollExtent - 500) {
    loadMorePhotos();
  }
}

 Future<void> loadPhotos() async {
  try {
    final result = await pexelsService.getCuratedPhotos(
      page: currentPage,
    );

    setState(() {
      photos = result;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = 'Failed to load photos';
      isLoading = false;
    });
  }
}
Future<void> loadMorePhotos() async {
  if (isLoadingMore) {
    return;
  }

  setState(() {
    isLoadingMore = true;
  });

  try {
    final nextPage = currentPage + 1;

    final result = await pexelsService.getCuratedPhotos(
      page: nextPage,
    );

    setState(() {
      photos.addAll(result);
      currentPage = nextPage;
      isLoadingMore = false;
    });
  } catch (e) {
    setState(() {
      isLoadingMore = false;
    });
  }
}
Future<void> refreshPhotos() async {
  try {
    final result = await pexelsService.getCuratedPhotos(
      page: 1,
    );

    setState(() {
      photos = result;
      currentPage = 1;
      errorMessage = null;
    });
  } catch (e) {
    setState(() {
      errorMessage = 'Failed to refresh photos';
    });
  }
}
@override
void dispose() {
  scrollController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!),
      );
    }

return RefreshIndicator(
  onRefresh: refreshPhotos,
  child: MasonryGridView.builder(
    controller: scrollController,
    padding: const EdgeInsets.all(8),
    gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
    ),
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    itemCount: photos.length,
    itemBuilder: (context, index) {
      return PhotoTile(
        photo: photos[index],
      );
    },
  ),
);
  }
}