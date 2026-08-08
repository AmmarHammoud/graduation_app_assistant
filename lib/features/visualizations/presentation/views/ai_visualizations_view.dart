import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/visualizations_cubit.dart';
import '../cubit/visualizations_state.dart';
import '../widgets/visualization_card.dart';
import 'visualization_detail_view.dart';

class AIVisualizationsView extends StatefulWidget {
  final String projectId;
  final String projectName;

  const AIVisualizationsView({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<AIVisualizationsView> createState() => _AIVisualizationsViewState();
}

class _AIVisualizationsViewState extends State<AIVisualizationsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildMockupAppBar(context),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<VisualizationsCubit>().loadVisualizations(widget.projectId),
            color: theme.primaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Top Header and Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Title
                        Text(
                          'تصاميم الذكاء الاصطناعي',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Visualizations List
                BlocBuilder<VisualizationsCubit, VisualizationsState>(
                  builder: (context, state) {
                    if (state is VisualizationsLoading) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(color: theme.primaryColor),
                        ),
                      );
                    }

                    if (state is VisualizationsLoaded) {
                      final items = state.filteredVisualizations;

                      if (items.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                                const SizedBox(height: 8),
                                Text(
                                  _searchController.text.isEmpty
                                      ? 'لا توجد تصاميم مسجلة للمشروع حالياً'
                                      : 'لا توجد نتائج تطابق بحثك',
                                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final vis = items[index];
                              return VisualizationCard(
                                visualization: vis,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VisualizationDetailView(
                                        visualization: vis,
                                        projectName: widget.projectName,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: items.length,
                          ),
                        ),
                      );
                    }

                    if (state is VisualizationsError) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                                const SizedBox(height: 12),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Color(0xFF8B8478), fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<VisualizationsCubit>().loadVisualizations(widget.projectId);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'جاري تحميل البيانات...',
                          style: TextStyle(color: Color(0xFF8B8478)),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildMockupAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      // 1. Right elements in RTL (Hamburger & Notification)
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: theme.primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      // 2. Left elements in RTL (Project Title)
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Text(
                  widget.projectName,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
