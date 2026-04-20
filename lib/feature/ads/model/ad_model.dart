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

      // 1. We no longer force HTTPS here because we enabled Cleartext in Manifest, 
      // and some local servers or specific CDNs might prefer HTTP.
      
      // 2. Encode non-ASCII characters (like Arabic) and spaces
      try {
        final String nonNullUrl = imageUrl.trim();
        // Use Uri.parse and toString for standard encoding if possible, 
        // fall back to encodeFull for legacy or complex strings.
        final uri = Uri.parse(nonNullUrl);
        imageUrl = uri.toString();
      } catch (_) {
        try {
          imageUrl = Uri.encodeFull(imageUrl!); // imageUrl is not null here
        } catch (__) {}
      }
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
