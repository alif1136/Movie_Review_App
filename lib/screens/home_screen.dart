import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/featured_movie_banner.dart';
import '../widgets/movie_horizontal_list.dart';
import '../widgets/section_header.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Consumer<MovieProvider>(
        builder: (context, provider, _) {
          if (provider.isHomeLoading) {
            return const ShimmerHomeLoading();
          }

          if (provider.homeState == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppTheme.primary, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load movies',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadHomeMovies(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppTheme.background,
                floating: true,
                snap: true,
                title: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.movie_filter_rounded,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Cinephiler',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: AppTheme.textPrimary),
                    onPressed: () {},
                  ),
                ],
              ),
              if (provider.trendingMovies.isNotEmpty)
                SliverToBoxAdapter(
                  child: FeaturedMovieBanner(
                    movies: provider.trendingMovies.take(5).toList(),
                    genreNames: provider.genres,
                  ),
                ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Now Playing'),
                    MovieHorizontalList(movies: provider.nowPlayingMovies),
                    const SectionHeader(title: 'Trending This Week'),
                    MovieHorizontalList(movies: provider.trendingMovies),
                    const SectionHeader(title: 'Popular'),
                    MovieHorizontalList(movies: provider.popularMovies),
                    const SectionHeader(title: 'Top Rated'),
                    MovieHorizontalList(movies: provider.topRatedMovies),
                    const SectionHeader(title: 'Coming Soon'),
                    MovieHorizontalList(movies: provider.upcomingMovies),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
