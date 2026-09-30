class Photo {
  final int id;
  final String photographer;
  final String imageUrl;
  final String largeImageUrl;
  final int width;
  final int height;
  Photo({
  required this.id,
  required this.photographer,
  required this.imageUrl,
  required this.largeImageUrl,
  required this.width,
  required this.height,
});
 Photo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        photographer = json['photographer'],
        imageUrl = json['src']['medium'],
        largeImageUrl = json['src']['large2x'],
        width = json['width'],
        height = json['height'];
Photo.fromFirestore(Map<String, dynamic> data)
     : id = data['id'],
        photographer = data['photographer'],
        imageUrl = data['imageUrl'],
        largeImageUrl = data['largeImageUrl'],
        width = data['width'],
        height = data['height'];
}