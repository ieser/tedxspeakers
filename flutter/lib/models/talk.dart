class Talk {
  final String slug;
  final String title;
  final String details;
  final String mainSpeaker;
  final String url;
  final String image;

  Talk.fromJSON(Map<String, dynamic> jsonMap) :
    slug = jsonMap['slug'],
    title = jsonMap['title'],
    details = jsonMap['description'],
    mainSpeaker = (jsonMap['speakers'] ?? ""),
    url = (jsonMap['url'] ?? ""),
    image = (jsonMap['url_image'] ?? "");
    
}