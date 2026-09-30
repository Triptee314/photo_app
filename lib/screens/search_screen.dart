import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/photo.dart';
import '../services/pexels_service.dart';
import '../widgets/photo_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final PexelsService pexelsService = PexelsService();
  final ScrollController scrollController = ScrollController();

int currentPage = 1;
bool isLoadingMore = false;
  Timer? debounceTimer;

  List<Photo> searchResults = [];

  bool isLoading = false;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    searchController.addListener(onSearchChanged);
    scrollController.addListener(onScroll);
  }
  void onScroll() {
  if (scrollController.position.pixels >=
      scrollController.position.maxScrollExtent - 500) {
    if (!isLoadingMore &&
        searchResults.isNotEmpty &&
        searchController.text.trim().isNotEmpty) {
      loadMorePhotos();
    }
  }
}
  void onSearchChanged() {
    debounceTimer?.cancel();

    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        errorMessage = null;
        isLoading = false;
      });
      return;
    }

    debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        searchPhotos(query);
      },
    );
  }

  Future<void> searchPhotos(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
       currentPage = 1;
    searchResults = [];
    });

    try {
      final results = await pexelsService.searchPhotos(
        query: query,
         page: 1,
      );

      if (!mounted) return;

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'Failed to search photos';
      });
    }
  }
  Future<void> loadMorePhotos() async {
  if (isLoadingMore) return;

  setState(() {
    isLoadingMore = true;
  });

  try {
    final nextPage = currentPage + 1;

    final results = await pexelsService.searchPhotos(
      query: searchController.text.trim(),
      page: nextPage,
    );

    if (!mounted) return;

    setState(() {
      searchResults.addAll(results);
      currentPage = nextPage;
      isLoadingMore = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoadingMore = false;
    });
  }
}

  @override
  void dispose() {
    debounceTimer?.cancel();
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search photos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: buildBody(),
            ),
          ],
        ),
      ),
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

    if (searchController.text.trim().isEmpty) {
      return const Center(
        child: Text('Search for beautiful photos'),
      );
    }

    if (searchResults.isEmpty) {
      return const Center(
        child: Text('No photos found'),
      );
    }

    return MasonryGridView.builder(
      controller: scrollController,
      gridDelegate:
          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
     itemCount: searchResults.length + (isLoadingMore ? 1 : 0),
     itemBuilder: (context, index) {
  if (index == searchResults.length) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  return PhotoTile(
    photo: searchResults[index],
  );
},
    );
  }
}