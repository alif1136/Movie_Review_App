import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:cinephiler/models/movie.dart';
import 'package:cinephiler/models/cast.dart';
import 'package:cinephiler/providers/movie_provider.dart';
import 'package:cinephiler/providers/watchlist_provider.dart';
import 'package:cinephiler/utils/app_theme.dart';
import 'package:cinephiler/utils/constants.dart';
import 'package:cinephiler/widgets/review_card.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovieDetail(widget.movie.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer2<MovieProvider, WatchlistProvider>(
        builder: (context, movieProvider, watchlistProvider, _) {
          final detail = movieProvider.selectedMovieDetail;
          final isInWatchlist = watchlistProvider.isInWatchlist(widget.movie.id);
          final isWatched = watchlistProvider.isWatched(widget.movie.id);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppTheme.background,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => watchlistProvider.toggleWatchlist(widget.movie),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isInWatchlist
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isInWatchlist ? AppTheme.primary : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.movie.backdropPath != null
                          ? CachedNetworkImage(
                        imageUrl: AppConstants.backdropUrl(
                            widget.movie.backdropPath!),
                        fit: BoxFit.cover,
                      )
                          : Container(color: AppTheme.surface),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppTheme.background.withOpacity(0.8),
                              AppTheme.background,
                            ],
                            stops: const [0.4, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.movie.posterPath != null
                                ? CachedNetworkImage(
                              imageUrl: AppConstants.posterUrl(
                                  widget.movie.posterPath!),
                              width: 110,
                              height: 165,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 110,
                              height: 165,
                              color: AppTheme.surface,
                              child: const Icon(Icons.movie,
                                  color: AppTheme.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.movie.title,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (detail?.tagline != null &&
                                    detail!.tagline!.isNotEmpty)
                                  Text(
                                    '"${detail.tagline}"',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: AppTheme.accent, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.movie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${widget.movie.voteCount})',
                                      style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.movie.year,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary, fontSize: 14),
                                ),
                                if (detail != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    detail.runtimeFormatted,
                                    style: const TextStyle(
                                        color: AppTheme.textSecondary, fontSize: 14),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                if (detail != null && detail.genres.isNotEmpty)
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: detail.genres.take(3).map((g) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primary.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                              color: AppTheme.primary.withOpacity(0.4)),
                                        ),
                                        child: Text(
                                          g.name,
                                          style: const TextStyle(
                                            color: AppTheme.primary,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  watchlistProvider.markAsWatched(widget.movie),
                              icon: Icon(isWatched
                                  ? Icons.check_circle_rounded
                                  : Icons.check_circle_outline_rounded),
                              label: Text(isWatched ? 'Watched' : 'Mark Watched'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isWatched
                                    ? AppTheme.surface
                                    : AppTheme.primary,
                                foregroundColor: AppTheme.textPrimary,
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  watchlistProvider.toggleWatchlist(widget.movie),
                              icon: Icon(isInWatchlist
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded),
                              label: Text(
                                  isInWatchlist ? 'In Watchlist' : 'Add to List'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isInWatchlist
                                    ? AppTheme.primary
                                    : AppTheme.textPrimary,
                                side: BorderSide(
                                    color: isInWatchlist
                                        ? AppTheme.primary
                                        : AppTheme.dividerColor),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.movie.overview,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      if (movieProvider.isDetailLoading) ...[
                        const SizedBox(height: 40),
                        const Center(
                          child: CircularProgressIndicator(
                              color: AppTheme.primary),
                        ),
                      ],
                      if (detail != null && detail.cast.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Cast',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 130,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: detail.cast.take(10).length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return CastCard(cast: detail.cast[index]);
                            },
                          ),
                        ),
                      ],
                      if (detail != null && detail.reviews.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Reviews (${detail.reviews.length})',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...detail.reviews.take(3).map((r) => ReviewCard(review: r)),
                      ],
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
