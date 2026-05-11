class AppConstants {
  // Replace with your TMDB API key from https://www.themoviedb.org/settings/api
  static const String apiKey = 'YOUR_TMDB_API_KEY';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w1280';
  static const String profileSize = 'w185';

  static String posterUrl(String path) => '$imageBaseUrl$posterSize$path';
  static String backdropUrl(String path) => '$imageBaseUrl$backdropSize$path';
  static String profileUrl(String path) => '$imageBaseUrl$profileSize$path';
}
