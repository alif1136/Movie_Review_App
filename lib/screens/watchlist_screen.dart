import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/movie_search_card.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Lists'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Watchlist'),
            Tab(text: 'Watched'),
          ],
        ),
      ),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildMovieList(
                movies: provider.watchlist,
                emptyIcon: Icons.bookmark_border_rounded,
                emptyMessage: 'Your watchlist is empty',
                emptySubtext: 'Add movies you want to watch',
                onDismiss: (id) => provider.removeFromWatchlist(id),
                dismissLabel: 'Remove',
              ),
              _buildMovieList(
                movies: provider.watched,
                emptyIcon: Icons.check_circle_outline_rounded,
                emptyMessage: 'No watched movies yet',
                emptySubtext: 'Movies you\'ve watched will appear here',
                onDismiss: (id) => provider.removeFromWatched(id),
                dismissLabel: 'Remove',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMovieList({
    required List movies,
    required IconData emptyIcon,
    required String emptyMessage,
    required String emptySubtext,
    required Function(int) onDismiss,
    required String dismissLabel,
  }) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon,
                size: 72, color: AppTheme.textSecondary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtext,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Dismissible(
          key: Key('movie_${movie.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_outline, color: Colors.white),
                const SizedBox(height: 4),
                Text(dismissLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          onDismissed: (_) => onDismiss(movie.id),
          child: MovieSearchCard(movie: movie),
        );
      },
    );
  }
}
