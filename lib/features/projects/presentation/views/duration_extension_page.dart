import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/duration_extension_cubit.dart';
import '../cubit/duration_extension_state.dart';

class DurationExtensionPage extends StatefulWidget {
  final String projectId;
  final String workItemId;
  final String itemName;
  final String itemCode;
  final String currentDeadlineText;
  final DateTime currentDeadlineDate;

  const DurationExtensionPage({
    super.key,
    required this.projectId,
    required this.workItemId,
    required this.itemName,
    this.itemCode = '#STR-204-A',
    this.currentDeadlineText = '24 أكتوبر 2023',
    DateTime? currentDeadlineDate,
  }) : currentDeadlineDate = currentDeadlineDate ?? const _DefaultDate();

  @override
  State<DurationExtensionPage> createState() => _DurationExtensionPageState();
}

class _DefaultDate implements DateTime {
  const _DefaultDate();
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DurationExtensionPageState extends State<DurationExtensionPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  int _calculatedDays = 0;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  DateTime get _effectiveDeadline {
    if (widget.currentDeadlineDate is _DefaultDate) {
      return DateTime.now();
    }
    return widget.currentDeadlineDate;
  }

  void _calculateDaysDifference(DateTime selected) {
    final difference = selected.difference(_effectiveDeadline).inDays;
    setState(() {
      _selectedDate = selected;
      _calculatedDays = difference > 0 ? difference : 1; // Minimum 1 day extension
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? now.add(const Duration(days: 1));
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('ar', 'AE'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF006D5B), // brand green
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF006D5B),
                textStyle: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _calculateDaysDifference(picked);
    }
  }

  String _formatDateArabic(DateTime date) {
    // Basic Arabic month mapping
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى تحديد التاريخ المتوقع الجديد للإنجاز',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<DurationExtensionCubit>().submit(
      projectId: widget.projectId,
      workItemId: widget.workItemId,
      requestedDurationDays: _calculatedDays,
      reason: _reasonController.text.trim(),
    );
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
          toolbarHeight: 70,
          leading: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A), size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: const Text(
            'تطبيق المساعد',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF0F172A)),
              onPressed: () {},
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: Color(0xFF0F172A), size: 18),
            ),
          ],
        ),
        body: BlocConsumer<DurationExtensionCubit, DurationExtensionState>(
          listener: (context, state) {
            if (state is DurationExtensionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تقديم طلب التمديد بنجاح لمدة $_calculatedDays يوماً',
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  backgroundColor: const Color(0xFF006D5B),
                ),
              );
              Navigator.pop(context, true);
            } else if (state is DurationExtensionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage,
                    style: const TextStyle(fontFamily: 'Tajawal'),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            final isSubmitting = state is DurationExtensionSubmitting;

            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    children: [
                      // Page Title Section
                      const Text(
                        'طلب تمديد الوقت',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'يرجى تقديم تفاصيل واضحة لطلب تمديد الموعد النهائي للمهمة الحالية.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            fontFamily: 'Tajawal',
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Task Details Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
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
                                    const Icon(
                                      Icons.access_time_rounded,
                                      color: Color(0xFFC2410C),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'متأخر',
                                      style: TextStyle(
                                        color: const Color(0xFFC2410C),
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'الموعد الحالي',
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 11,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.currentDeadlineText,
                                      style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.itemName,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'رقم البند: ${widget.itemCode}',
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Reason Field
                      const Text(
                        'سبب التأخير',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 5,
                        style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'اشرح الأسباب الفنية أو اللوجستية التي أدت إلى تأخر الإنجاز...',
                          hintStyle: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontFamily: 'Tajawal',
                            height: 1.5,
                          ),
                          fillColor: const Color(0xFFF8FAFC),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF006D5B), width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال سبب التأخير';
                          }
                          if (value.trim().length < 10) {
                            return 'يجب أن يكون السبب أكثر تفصيلاً (10 أحرف على الأقل)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Expected Completion Date Field
                      const Text(
                        'التاريخ المتوقع الجديد للإنجاز',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'mm/dd/yyyy'
                                      : _formatDateArabic(_selectedDate!),
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF0F172A),
                                    fontSize: 14,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                              if (_selectedDate != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7F4),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '+$_calculatedDays يوم',
                                    style: const TextStyle(
                                      color: Color(0xFF006D5B),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Warning Card Notice
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, color: Color(0xFF64748B), size: 20),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'سيتم إرسال هذا الطلب مباشرة إلى المهندس المشرف للمراجعة. يرجى التأكد من دقة المعلومات لتجنب رفض الطلب.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  fontFamily: 'Tajawal',
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Submit Button
                      ElevatedButton(
                        onPressed: isSubmitting ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A), // Navy blue brand color
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'إرسال طلب التمديد للمراجعة',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: 3.14159, // rotated 180 degrees for RTL
                              child: const Icon(Icons.send_rounded, size: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                if (isSubmitting)
                  Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFF006D5B)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
