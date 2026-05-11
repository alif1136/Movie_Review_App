import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../models/cast.dart';
import '../models/review.dart';
import '../utils/constants.dart';

class MovieService {
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/trending/movie/week?api_key=${AppConstants.apiKey}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load trending movies');
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/now_playing?api_key=${AppConstants.apiKey}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load now playing movies');
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/popular?api_key=${AppConstants.apiKey}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load popular movies');
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/top_rated?api_key=${AppConstants.apiKey}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load top rated movies');
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/upcoming?api_key=${AppConstants.apiKey}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load upcoming movies');
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/search/movie?api_key=${AppConstants.apiKey}&query=${Uri.encodeComponent(query)}&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to search movies');
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/$movieId?api_key=${AppConstants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load movie detail');
  }

  Future<List<Cast>> getMovieCredits(int movieId) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/$movieId/credits?api_key=${AppConstants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['cast'] as List).map((e) => Cast.fromJson(e)).toList();
    }
    throw Exception('Failed to load movie credits');
  }

  Future<List<Review>> getMovieReviews(int movieId) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/$movieId/reviews?api_key=${AppConstants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Review.fromJson(e)).toList();
    }
    throw Exception('Failed to load movie reviews');
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/movie/$movieId/similar?api_key=${AppConstants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    }
    throw Exception('Failed to load similar movies');
  }

  Future<Map<int, String>> getGenres() async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}/genre/movie/list?api_key=${AppConstants.apiKey}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genres = <int, String>{};
      for (final genre in data['genres']) {
        genres[genre['id']] = genre['name'];
      }
      return genres;
    }
    throw Exception('Failed to load genres');
  }
}
