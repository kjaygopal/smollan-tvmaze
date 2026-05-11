class ShowModel {
  final int id;
  final int weight;
  final String name;
  final List<String> genres;
  final double rating;
  final String summary;
  final String image;
  final String premiered;
  final String status;

  ShowModel({
    required this.weight,
    required this.id,
    required this.name,
    required this.genres,
    required this.rating,
    required this.summary,
    required this.image,
    required this.premiered,
    required this.status,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      weight: json['weight'] ?? 0,
      id: json['id'] ?? 0,

      name: json['name'] ?? 'Unknown',

      genres: json['genres'] != null ? List<String>.from(json['genres']) : [],

      rating: json['rating'] != null
          ? (json['rating']['average'] ?? 0).toDouble()
          : 0.0,

      summary: json['summary'] ?? '',

      image: json['image'] != null ? json['image']['medium'] ?? '' : '',

      premiered: json['premiered'] ?? 'Unknown',

      status: json['status'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'genres': genres,
      'rating': rating,
      'summary': summary,
      'image': image,
      'premiered': premiered,
      'status': status,
    };
  }

  factory ShowModel.fromMap(Map map) {
    return ShowModel(
      id: map['id'],
      name: map['name'],
      genres: List<String>.from(map['genres']),
      rating: map['rating'],
      summary: map['summary'],
      image: map['image'] ?? '',
      premiered: map['premiered'],
      status: map['status'],
      weight: map['weight'] ?? 0,
    );
  }

  String get cleanSummary {
    return summary.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
