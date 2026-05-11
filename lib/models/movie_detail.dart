import 'genre.dart';
import 'cast.dart';
import 'review.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final int runtime;
  final List<Genre> genres;
  final String status;
  final String? tagline;
  final int budget;
  final int revenue;
  List<Cast> cast;
  List<Review> reviews;

  MovieDetail({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.runtime,
    required this.genres,
    required this.status,
    this.tagline,
    required this.budget,
    required this.revenue,
    this.cast = const [],
    this.reviews = const [],
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      runtime: json['runtime'] ?? 0,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((g) => Genre.fromJson(g))
          .toList() ??
          [],
      status: json['status'] ?? '',
      tagline: json['tagline'],
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  String get year => releaseDate.isNotEmpty ? releaseDate.substring(0, 4) : 'N/A';

  String get runtimeFormatted {
    if (runtime <= 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes}m';
  }
}
