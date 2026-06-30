import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/comment_entity.dart';
import '../cubits/comment_cubit.dart';
import '../cubits/comment_state.dart';

class WorkItemCommentsPage extends StatefulWidget {
  final int workItemId;
  final String workItemName;

  const WorkItemCommentsPage({
    super.key,
    required this.workItemId,
    required this.workItemName,
  });

  @override
  State<WorkItemCommentsPage> createState() => _WorkItemCommentsPageState();
}

class _WorkItemCommentsPageState extends State<WorkItemCommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onCommentTextChanged);
  }

  @override
  void dispose() {
    _commentController.removeListener(_onCommentTextChanged);
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCommentTextChanged() {
    final isNotEmpty = _commentController.text.trim().isNotEmpty;
    if (isNotEmpty != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
          scrolledUnderElevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'التعليقات والمناقشات',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.workItemName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFE2E8F0),
              height: 1.0,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<CommentCubit, CommentState>(
                listener: (context, state) {
                  if (state is CommentLoaded || state is CommentSendSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                  if (state is CommentError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CommentLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006D5B)),
                      ),
                    );
                  }

                  List<CommentEntity> comments = [];
                  if (state is CommentLoaded) {
                    comments = state.comments;
                  } else if (state is CommentSending) {
                    comments = state.currentComments;
                  }

                  if (comments.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      // Highlight comments from current user role "Assistant" or containing "Assistant" or "asst"
                      final isMe = comment.user.name.contains('Assistant') || 
                                   comment.user.internalId.contains('asst');
                      return _buildCommentBubble(comment, isMe);
                    },
                  );
                },
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7F4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 44,
                  color: Color(0xFF006D5B),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'لا توجد تعليقات بعد',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'كن أول من يعلّق ويشارك التحديثات حول هذا البند مع مهندس الإشراف والفرق المختصة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentBubble(CommentEntity comment, bool isMe) {
    final bubbleColor = isMe ? const Color(0xFFE6F7F4) : Colors.white;
    final textColor = isMe ? const Color(0xFF0F172A) : const Color(0xFF1E293B);
    final borderColor = isMe ? null : Border.all(color: const Color(0xFFE2E8F0));
    final double rightPad = isMe ? 64 : 16;
    final double leftPad = isMe ? 16 : 64;

    return Padding(
      padding: EdgeInsets.only(right: rightPad, left: leftPad, top: 6, bottom: 6),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(comment.user.name, isMe: isMe),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.user.name,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF1E293B),
                          ),
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
                    const SizedBox(height: 2),
                    Text(
                      _formatArabicDate(comment.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 10,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bubbleColor,
              border: borderColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              comment.comment,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: textColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String name, {required bool isMe}) {
    final initials = name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    return CircleAvatar(
      radius: 16,
      backgroundColor: isMe ? const Color(0xFF006D5B) : const Color(0xFF3B82F6),
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'اكتب تعليقاً أو استفساراً...',
                        hintStyle: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocBuilder<CommentCubit, CommentState>(
            builder: (context, state) {
              final isSending = state is CommentSending;
              return InkWell(
                onTap: (_isButtonEnabled && !isSending)
                    ? () {
                        final commentText = _commentController.text.trim();
                        context.read<CommentCubit>().addComment(
                              workItemId: widget.workItemId,
                              comment: commentText,
                            );
                        _commentController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    : null,
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isButtonEnabled && !isSending
                        ? const Color(0xFF006D5B)
                        : const Color(0xFFCBD5E1),
                    shape: BoxShape.circle,
                    boxShadow: _isButtonEnabled && !isSending
                        ? [
                            BoxShadow(
                              color: const Color(0xFF006D5B).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              );
            },
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
