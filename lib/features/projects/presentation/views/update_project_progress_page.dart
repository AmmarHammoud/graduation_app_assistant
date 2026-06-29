import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/work_items_update_details.dart';
import '../cubit/item_update_cubit.dart';
import '../cubit/item_update_state.dart';

class UpdateProjectProgressPage extends StatefulWidget {
  const  UpdateProjectProgressPage({super.key});

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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(BuildContext context) {
    final text = _commentController.text;
    if (text.trim().isNotEmpty) {
      context.read<ItemUpdateCubit>().addComment(text);
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
                  ...state.data.managerComments.map((c) => _buildCommentTile(c)),
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
              onTap: () => context.read<ItemUpdateCubit>().selectImages(['kitchen_final.jpg']),
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

            if (state.chosenImages.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
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
                        'تم اختيار صورة: ${state.chosenImages.last}',
                        style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: state.isSubmitting ? null : () => context.read<ItemUpdateCubit>().sendRequestToAdmin(space.spaceName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF64748B), // Slate grey button as per screenshot
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: state.isSubmitting
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
            )
          ]
        ],
      ),
    );
  }

  Widget _buildCommentTile(UpdateCommentEntity comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
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
              Text(
                comment.authorName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
              ),
              Text(
                comment.relativeTime,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.commentText,
            style: const TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.5),
          ),
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
        GestureDetector(
          onTap: () => _submitComment(context),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF0F172A),
            child: Transform.scale(
              scaleX: -1, // Mirrors the send icon to point to the left in RTL text flow
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          ),
        )
      ],
    );
  }
}