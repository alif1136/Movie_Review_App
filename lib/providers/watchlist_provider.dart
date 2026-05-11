import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class WatchlistProvider extends ChangeNotifier {
  final List<Movie> _watchlist = [];
  final List<Movie> _watched = [];

  List<Movie> get watchlist => List.unmodifiable(_watchlist);
  List<Movie> get watched => List.unmodifiable(_watched);

  bool isInWatchlist(int movieId) => _watchlist.any((m) => m.id == movieId);
  bool isWatched(int movieId) => _watched.any((m) => m.id == movieId);

  void addToWatchlist(Movie movie) {
    if (!isInWatchlist(movie.id)) {
      _watchlist.add(movie);
      notifyListeners();
    }
  }

  void removeFromWatchlist(int movieId) {
    _watchlist.removeWhere((m) => m.id == movieId);
    notifyListeners();
  }

  void toggleWatchlist(Movie movie) {
    if (isInWatchlist(movie.id)) {
      removeFromWatchlist(movie.id);
    } else {
      addToWatchlist(movie);
    }
  }

  void markAsWatched(Movie movie) {
    if (!isWatched(movie.id)) {
      _watched.add(movie);
      removeFromWatchlist(movie.id);
      notifyListeners();
    }
  }

  void removeFromWatched(int movieId) {
    _watched.removeWhere((m) => m.id == movieId);
    notifyListeners();
  }
}
