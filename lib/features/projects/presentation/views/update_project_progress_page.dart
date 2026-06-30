import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../comments/domain/entities/comment_entity.dart';
import '../../../comments/presentation/cubits/comment_cubit.dart';
import '../../../comments/presentation/cubits/comment_state.dart';
import '../../domain/entities/work_items_update_details.dart';
import '../cubit/item_update_cubit.dart';
import '../cubit/item_update_state.dart';

class UpdateProjectProgressPage extends StatefulWidget {
  final int workItemId;

  const UpdateProjectProgressPage({
    super.key,
    required this.workItemId,
  });

  @override
  State<UpdateProjectProgressPage> createState() => _UpdateProjectProgressPageState();
}

class _UpdateProjectProgressPageState extends State<UpdateProjectProgressPage> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  Future<void> _pickImage(BuildContext context, int spaceId) async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF006D5B)),
                  title: const Text('التقاط صورة بالكاميرا', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final XFile? photo = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                    if (photo != null && context.mounted) {
                      context.read<ItemUpdateCubit>().selectImages(spaceId, [photo.path]);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF006D5B)),
                  title: const Text('اختيار من معرض الصور', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (image != null && context.mounted) {
                      context.read<ItemUpdateCubit>().selectImages(spaceId, [image.path]);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(BuildContext context) {
    final text = _commentController.text;
    if (text.trim().isNotEmpty) {
      context.read<CommentCubit>().addComment(
            workItemId: widget.workItemId,
            comment: text,
          );
      _commentController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تحديث الإنجاز',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Color(0xFF64748B)),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<ItemUpdateCubit, ItemUpdateState>(
          listener: (context, state) {
            if (state is ItemUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب التحديث للمشرف للمراجعة')),
              );
              // Instead of popping right away, reload details to simulate submission cycle, or let pop happen.
              // For better demonstration, we pop to complete the flow.
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is ItemUpdateLoading) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF006D5B)));
            }
            if (state is ItemUpdateLoaded) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (state.data.delayWarningMessage != null) _buildDelayWarningCard(state.data.delayWarningMessage!),
                  const SizedBox(height: 16),
                  _buildHeaderCircularMetricsCard(state.data),
                  const SizedBox(height: 16),
                  _buildReviewNoticeAlert(),
                  const SizedBox(height: 24),
                  const Text(
                    'تفاصيل الإنجاز',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 12),
                  ...state.data.subSpaces.map((space) => _buildSubSpaceRowCard(context, space, state)),
                  const SizedBox(height: 24),
                  Text(
                    'تعليقات البند (Item Comments)',
                    style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  BlocConsumer<CommentCubit, CommentState>(
                    listener: (context, commentState) {
                      if (commentState is CommentError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              commentState.message,
                              style: const TextStyle(fontFamily: 'Tajawal'),
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    builder: (context, commentState) {
                      if (commentState is CommentLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(color: Color(0xFF006D5B)),
                          ),
                        );
                      }

                      List<CommentEntity> comments = [];
                      if (commentState is CommentLoaded) {
                        comments = commentState.comments;
                      } else if (commentState is CommentSending) {
                        comments = commentState.currentComments;
                      }

                      if (comments.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Center(
                            child: Text(
                              'لا توجد تعليقات بعد لهذا البند.',
                              style: TextStyle(fontFamily: 'Tajawal', color: Color(0xFF64748B), fontSize: 13),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: comments.map((c) => _buildRealCommentTile(c)).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNewCommentInputField(context),
                  const SizedBox(height: 32),
                ],
              );
            }
            if (state is ItemUpdateError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('خطأ في تحميل لوحة التحديث'));
          },
        ),
      ),
    );
  }

  Widget _buildDelayWarningCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(right: BorderSide(color: Color(0xFFEF4444), width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تنبيه تأخير',
                      style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      'الآن',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: const TextStyle(color: Color(0xFF334155), fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.timer_outlined, size: 16),
                    label: const Text(
                      'تقديم طلب تمديد',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2), // soft pink/red
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCircularMetricsCard(WorkItemUpdateDetails data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم المشروع #PRJ-832',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  data.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7), // Light amber
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD97706),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'قيد التنفيذ',
                        style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircularProgressIndicator(
                    value: data.currentPercent,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFF1F5F9),
                    color: const Color(0xFFF59E0B),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(data.currentPercent * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0F172A), height: 1.1),
                    ),
                    const Text(
                      'إنجاز',
                      style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewNoticeAlert() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // soft blue
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'سيتم مراجعة التحديثات من قبل المسؤول قبل اعتمادها كـ "مكتملة". يمكنك متابعة حالة المراجعة لكل بند أدناه.',
              style: TextStyle(color: Color(0xFF1E40AF), fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubSpaceRowCard(BuildContext context, SubSpaceItemEntity space, ItemUpdateLoaded state) {
    final isCompleted = space.statusLabel == 'مكتمل';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Checkbox on the right (RTL first child)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF006D5B) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: isCompleted ? null : Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Title and Subtitle in the middle (RTL second child)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.spaceName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isCompleted ? 'تم الإنجاز والتوثيق' : 'قيد المراجعة',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ],
                ),
              ),

              // Status Badge on the left (RTL third child)
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), // Light green
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'مكتمل',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (space.statusLabel == 'قيد المراجعة')
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'قيد',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'المراجعة',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          if (space.uploadedMediaUrl != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  // Icon container on the right
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF006D5B),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          space.uploadedMediaUrl!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تم الرفع في ${space.uploadDate ?? '12/25/2023'}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else ...[
            // Dashed border style representation for file upload
            GestureDetector(
              onTap: () => _pickImage(context, space.id),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400, size: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'رفع صورة لتوضيح المحتوى',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'اختيار ملف',
                      style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            (() {
              final spaceImages = state.chosenImagesBySpace[space.id] ?? [];
              if (spaceImages.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDCFCE7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'تم اختيار صورة: ${spaceImages.last.split('/').last}',
                            style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            })(),

            const SizedBox(height: 16),

            (() {
              final isThisSpaceSubmitting = state.submittingSpaceIds.contains(space.id);
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isThisSpaceSubmitting ? null : () => context.read<ItemUpdateCubit>().sendRequestToAdmin(space),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64748B), // Slate grey button as per screenshot
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: isThisSpaceSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, size: 16),
                            SizedBox(width: 8),
                            Text('إرسال للمراجعة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                ),
              );
            })()
          ]
        ],
      ),
    );
  }

  Widget _buildNewCommentInputField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: TextField(
              controller: _commentController,
              onSubmitted: (_) => _submitComment(context),
              decoration: const InputDecoration(
                hintText: 'اكتب تعليقاً جديداً...',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        BlocBuilder<CommentCubit, CommentState>(
          builder: (context, commentState) {
            final isSending = commentState is CommentSending;
            return GestureDetector(
              onTap: isSending ? null : () => _submitComment(context),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: isSending ? Colors.grey.shade400 : const Color(0xFF0F172A),
                child: isSending
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Transform.scale(
                        scaleX: -1, // Mirrors the send icon to point to the left in RTL text flow
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRealCommentTile(CommentEntity comment) {
    final isMe = comment.user.name.contains('Assistant') || comment.user.internalId.contains('asst');
    final bubbleColor = isMe ? const Color(0xFFE6F7F4) : Colors.white;
    final textColor = isMe ? const Color(0xFF0F172A) : const Color(0xFF1E293B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(16),
        border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    comment.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFFCCF2ED) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      comment.user.internalId,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 9,
                        color: isMe ? const Color(0xFF006D5B) : const Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _formatArabicDate(comment.createdAt),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.comment,
            style: TextStyle(color: textColor, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _formatArabicDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();

      final hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'م' : 'ص';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final timeStr = '$hour:$minute $period';

      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return 'اليوم، $timeStr';
      } else if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day - 1) {
        return 'أمس، $timeStr';
      } else {
        final months = [
          'يناير',
          'فبراير',
          'مارس',
          'أبريل',
          'مايو',
          'يونيو',
          'يوليو',
          'أغسطس',
          'سبتمبر',
          'أكتوبر',
          'نوفمبر',
          'ديسمبر'
        ];
        return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}، $timeStr';
      }
    } catch (e) {
      return dateStr;
    }
  }
}