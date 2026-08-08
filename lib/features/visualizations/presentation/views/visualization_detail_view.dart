import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/get_it_service.dart';
import '../../domain/entities/ai_visualization.dart';
import '../../domain/entities/visualization_comment.dart';
import '../cubit/visualization_comments_cubit.dart';
import '../cubit/visualization_comments_state.dart';

class VisualizationDetailView extends StatelessWidget {
  final AIVisualization visualization;
  final String projectName;

  const VisualizationDetailView({
    super.key,
    required this.visualization,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VisualizationCommentsCubit>(
      create: (context) => getIt<VisualizationCommentsCubit>()..loadComments(visualization.id),
      child: VisualizationDetailContent(
        visualization: visualization,
        projectName: projectName,
      ),
    );
  }
}

class VisualizationDetailContent extends StatefulWidget {
  final AIVisualization visualization;
  final String projectName;

  const VisualizationDetailContent({
    super.key,
    required this.visualization,
    required this.projectName,
  });

  @override
  State<VisualizationDetailContent> createState() => _VisualizationDetailContentState();
}

class _VisualizationDetailContentState extends State<VisualizationDetailContent> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    context.read<VisualizationCommentsCubit>().postComment(
      widget.visualization.id,
      text,
    ).then((_) {
      if (mounted) {
        _commentController.clear();
        setState(() {
          _isSubmitting = false;
        });
        FocusScope.of(context).unfocus();
        _showSnackBar(context, 'تم إضافة تعليقك بنجاح.', Theme.of(context), isSuccess: true);
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        _showSnackBar(context, 'تعذر إضافة التعليق حالياً.', Theme.of(context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatArabicDate(widget.visualization.createdAt);
    const Color goldColor = Color(0xFFC99A46);
    const Color stoneColor = Color(0xFF8B8478);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: theme.primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تفاصيل التصميم',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Premium Zoomable Image Container
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCD8CF), width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.01),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // InteractiveViewer for premium pinch-and-zoom controls
                      Positioned.fill(
                        child: InteractiveViewer(
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: Image.network(
                            widget.visualization.generatedImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFEFECE5),
                                child: const Center(
                                  child: Icon(Icons.broken_image_outlined, size: 48, color: stoneColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Zoom Indicator Label overlay
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in_rounded, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'تلميح: استخدم أصابعك للتكبير',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10, 
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Metadata Block
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCD8CF), width: 0.8),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.01),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb label showing parent Project Name in Gold
                    Text(
                      widget.projectName,
                      style: const TextStyle(
                        color: goldColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      widget.visualization.title,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Beautiful Arabic Date
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14, color: stoneColor),
                        const SizedBox(width: 6),
                        Text(
                          'تاريخ الإنشاء: $formattedDate',
                          style: const TextStyle(
                            color: stoneColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0xFFDCD8CF)),
                    ),

                    // Description Header
                    Text(
                      'نبذة عن التصميم',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description text
                    Text(
                      widget.visualization.description,
                      style: const TextStyle(
                        color: stoneColor,
                        fontSize: 13,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              //
              // // 3. Actions Button Column
              // ElevatedButton.icon(
              //   onPressed: () => _showSnackBar(context, 'بدء تنزيل التصميم بدقة عالية...', theme, isSuccess: true),
              //   icon: const Icon(Icons.download_rounded, size: 18),
              //   label: const Text(
              //     'تحميل التصميم بجودة عالية (HD)',
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: theme.primaryColor,
              //     foregroundColor: Colors.white,
              //     minimumSize: const Size.fromHeight(50),
              //     elevation: 0,
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // OutlinedButton.icon(
              //   onPressed: () => _showSnackBar(context, 'جاري الإعداد للمشاركة...', theme),
              //   icon: const Icon(Icons.share_outlined, size: 16),
              //   label: const Text(
              //     'مشاركة التصميم مع فريق العمل',
              //     style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //     foregroundColor: stoneColor,
              //     side: const BorderSide(color: Color(0xFFDCD8CF)),
              //     minimumSize: const Size.fromHeight(50),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              //   ),
              // ),
              const SizedBox(height: 24),

              // 4. Branded Dividers
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFDCD8CF))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'المناقشات والآراء',
                      style: TextStyle(
                        color: goldColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFDCD8CF))),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Comments section body
              BlocBuilder<VisualizationCommentsCubit, VisualizationCommentsState>(
                builder: (context, state) {
                  if (state is VisualizationCommentsLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(color: goldColor),
                      ),
                    );
                  } else if (state is VisualizationCommentsError) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE8E8)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.red, fontSize: 13, fontFamily: 'Tajawal'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context
                                .read<VisualizationCommentsCubit>()
                                .loadComments(widget.visualization.id),
                            child: const Text('إعادة المحاولة', style: TextStyle(color: goldColor, fontFamily: 'Tajawal')),
                          )
                        ],
                      ),
                    );
                  } else if (state is VisualizationCommentsLoaded) {
                    final comments = state.comments;
                    if (comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFECE5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: stoneColor,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'لا توجد تعليقات حتى الآن',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1C2624),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'كن أول من يشارك برأيه حول هذا التصميم!',
                              style: TextStyle(
                                fontSize: 12,
                                color: stoneColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: comments.map((comment) => _buildCommentCard(comment, theme, goldColor, stoneColor)).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16),

              // 6. Comment Submission Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDCD8CF), width: 0.8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        maxLines: null,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                        decoration: InputDecoration(
                          hintText: 'اكتب ملاحظتك أو تعليقك هنا...',
                          hintStyle: const TextStyle(
                            color: stoneColor,
                            fontSize: 13,
                            fontFamily: 'Tajawal',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: goldColor),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFECE5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send_rounded, color: goldColor, size: 20),
                              onPressed: _submitComment,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentCard(
    VisualizationComment comment,
    ThemeData theme,
    Color goldColor,
    Color stoneColor,
  ) {
    final relativeTime = _formatRelativeTime(comment.createdAt);
    final initial = comment.userName.isNotEmpty ? comment.userName.substring(0, 1) : 'م';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFECE5), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Letter Avatar
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFEFECE5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  color: goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Content Block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.userName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      relativeTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: stoneColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  comment.comment,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: theme.primaryColor.withOpacity(0.85),
                    height: 1.5,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'الآن';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      if (hours == 1) return 'منذ ساعة';
      if (hours == 2) return 'منذ ساعتين';
      if (hours <= 10) return 'منذ $hours ساعات';
      return 'منذ $hours ساعة';
    } else {
      final days = difference.inDays;
      if (days == 1) return 'أمس';
      if (days == 2) return 'منذ يومين';
      if (days <= 10) return 'منذ $days أيام';
      return 'منذ $days يوماً';
    }
  }

  String _formatArabicDate(DateTime dateTime) {
    try {
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      final day = dateTime.day;
      final month = months[dateTime.month - 1];
      final year = dateTime.year;
      return '$day $month $year';
    } catch (e) {
      return '12 أكتوبر 2023';
    }
  }

  void _showSnackBar(BuildContext context, String message, ThemeData theme, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? theme.primaryColor : const Color(0xFF1C2624),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }
}
