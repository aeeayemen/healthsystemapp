class AdModel {
  final int id;
  final String? title;
  final String? imageUrl;
  final String? link;
  final String? description;
  final String? phoneNumber;
  final String? type;
  final bool isActive;

  AdModel({
    required this.id,
    this.title,
    this.imageUrl,
    this.link,
    this.description,
    this.phoneNumber,
    this.type,
    this.isActive = true,
  });

  factory AdModel.fromJson(Map<String, dynamic> json, {String? storageBase}) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    String? rawImage = json["image_url"]?.toString() ?? json["image"]?.toString();
    String? imageUrl = rawImage;
    
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (storageBase != null && !imageUrl.startsWith("http")) {
        final base = storageBase.endsWith("/") ? storageBase : "$storageBase/";
        imageUrl = "$base$imageUrl";
      }

      // 1. Force HTTPS to avoid Cleartext issues on Android/iOS
      if (imageUrl.startsWith("http://")) {
        imageUrl = imageUrl.replaceFirst("http://", "https://");
      }

      // 2. Encode non-ASCII characters (like Arabic) to make it a valid URI
      try {
        // We use parse and toString to handle encoding correctly
         imageUrl = Uri.tryParse(imageUrl)?.toString() ?? imageUrl;
      } catch (_) {}
    }

    return AdModel(
      id: _toInt(json["id"]),
      title: json["title"]?.toString(),
      imageUrl: imageUrl,
      link: json["link"]?.toString(),
      description: json["description"]?.toString() ?? json["describtion"]?.toString(),
      phoneNumber: json["phone_number"]?.toString(),
      type: json["type"]?.toString(),
      isActive: json["is_active"] == true,
    );
  }
}
