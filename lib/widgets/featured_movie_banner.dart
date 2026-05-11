import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../screens/movie_detail_screen.dart';

class FeaturedMovieBanner extends StatefulWidget {
  final List<Movie> movies;
  final Map<int, String> genreNames;

  const FeaturedMovieBanner({
    super.key,
    required this.movies,
    required this.genreNames,
  });

  @override
  State<FeaturedMovieBanner> createState() => _FeaturedMovieBannerState();
}

class _FeaturedMovieBannerState extends State<FeaturedMovieBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 480,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.movies.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movie: movie),
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    movie.backdropPath != null
                        ? CachedNetworkImage(
                      imageUrl: AppConstants.backdropUrl(movie.backdropPath!),
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
                            AppTheme.background.withOpacity(0.6),
                            AppTheme.background,
                          ],
                          stops: const [0.3, 0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: AppTheme.accent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                movie.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                movie.year,
                                style: const TextStyle(
                                    color: AppTheme.textSecondary, fontSize: 13),
                              ),
                              if (movie.genreIds.isNotEmpty &&
                                  widget.genreNames[movie.genreIds.first] != null) ...[
                                const SizedBox(width: 8),
                                const Text('•',
                                    style:
                                    TextStyle(color: AppTheme.textSecondary)),
                                const SizedBox(width: 8),
                                Text(
                                  widget.genreNames[movie.genreIds.first]!,
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary, fontSize: 13),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MovieDetailScreen(movie: movie),
                                  ),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded,
                                    size: 20),
                                label: const Text('More Info'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppTheme.primary
                    : AppTheme.textSecondary.withOpacity(0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
