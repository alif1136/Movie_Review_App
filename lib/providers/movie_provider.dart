import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/movie_service.dart';

enum LoadingState { idle, loading, loaded, error }

class MovieProvider extends ChangeNotifier {
  final MovieService _service = MovieService();

  List<Movie> _trendingMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];
  Map<int, String> _genres = {};

  MovieDetail? _selectedMovieDetail;

  LoadingState _homeState = LoadingState.idle;
  LoadingState _searchState = LoadingState.idle;
  LoadingState _detailState = LoadingState.idle;

  String _searchQuery = '';
  String _errorMessage = '';

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;
  Map<int, String> get genres => _genres;
  MovieDetail? get selectedMovieDetail => _selectedMovieDetail;
  LoadingState get homeState => _homeState;
  LoadingState get searchState => _searchState;
  LoadingState get detailState => _detailState;
  String get searchQuery => _searchQuery;
  String get errorMessage => _errorMessage;

  bool get isHomeLoading => _homeState == LoadingState.loading;
  bool get isSearchLoading => _searchState == LoadingState.loading;
  bool get isDetailLoading => _detailState == LoadingState.loading;

  Future<void> loadHomeMovies() async {
    _homeState = LoadingState.loading;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getTrendingMovies(),
        _service.getNowPlayingMovies(),
        _service.getPopularMovies(),
        _service.getTopRatedMovies(),
        _service.getUpcomingMovies(),
        _service.getGenres(),
      ]);

      _trendingMovies = results[0] as List<Movie>;
      _nowPlayingMovies = results[1] as List<Movie>;
      _popularMovies = results[2] as List<Movie>;
      _topRatedMovies = results[3] as List<Movie>;
      _upcomingMovies = results[4] as List<Movie>;
      _genres = results[5] as Map<int, String>;

      _homeState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _homeState = LoadingState.error;
    }

    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _searchResults = [];
      _searchState = LoadingState.idle;
      notifyListeners();
      return;
    }

    _searchState = LoadingState.loading;
    notifyListeners();

    try {
      _searchResults = await _service.searchMovies(query);
      _searchState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _searchState = LoadingState.error;
    }

    notifyListeners();
  }

  Future<void> loadMovieDetail(int movieId) async {
    _detailState = LoadingState.loading;
    _selectedMovieDetail = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getMovieDetail(movieId),
        _service.getMovieCredits(movieId),
        _service.getMovieReviews(movieId),
      ]);

      final detail = results[0] as MovieDetail;
      detail.cast = results[1] as dynamic;
      detail.reviews = results[2] as dynamic;

      _selectedMovieDetail = detail;
      _detailState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _detailState = LoadingState.error;
    }

    notifyListeners();
  }

  String getGenreName(int id) => _genres[id] ?? '';

  List<String> getGenreNames(List<int> ids) {
    return ids.map((id) => getGenreName(id)).where((name) => name.isNotEmpty).toList();
  }

  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    _searchState = LoadingState.idle;
    notifyListeners();
  }
}
