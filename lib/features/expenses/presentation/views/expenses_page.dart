import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../projects/domain/entities/assigned_proejct_details.dart';
import '../cubits/expenses_cubit.dart';
import '../cubits/expenses_state.dart';
import '../../domain/entities/expense_entity.dart';

class ExpensesPage extends StatefulWidget {
  final String projectId;
  final String projectName;
  final List<AssistantWorkItemEntity> workItems;

  const ExpensesPage({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.workItems,
  });

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AssistantWorkItemEntity? _selectedWorkItem;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Parses absolute dates or relative times for mockup fidelity
  String _formatDisplayDate(String dateStr) {
    if (dateStr.isEmpty) return 'الآن';
    try {
      final dateTime = DateTime.parse(dateStr);
      final difference = DateTime.now().difference(dateTime);

      if (difference.inMinutes < 60) {
        return 'منذ قليل';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else {
        final months = [
          'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
          'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
        ];
        return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
      }
    } catch (_) {
      // Return raw mock values (such as "منذ ساعتين" or "أمس") if already relative
      if (dateStr.contains('منذ') || dateStr == 'أمس') {
        return dateStr;
      }
      return 'حديثاً';
    }
  }

  // Generates specific visual icons based on expense description or category name
  IconData _getExpenseIcon(String itemTitle) {
    final titleLower = itemTitle.toLowerCase();
    if (titleLower.contains('كهرباء') || titleLower.contains('فاتورة') || titleLower.contains('طاقة')) {
      return Icons.flash_on_rounded;
    }
    if (titleLower.contains('ماء') || titleLower.contains('رصف') || titleLower.contains('تأسيس')) {
      return Icons.water_drop_outlined;
    }
    return Icons.construction_rounded;
  }

  // Generates specific color schemes for the expense icons
  Color _getExpenseIconBgColor(String itemTitle) {
    final titleLower = itemTitle.toLowerCase();
    if (titleLower.contains('كهرباء') || titleLower.contains('فاتورة')) {
      return const Color(0xFFF1F5F9); // Slate Grey
    }
    return const Color(0xFFE6F7F4); // Light Cyan
  }

  Color _getExpenseIconColor(String itemTitle) {
    final titleLower = itemTitle.toLowerCase();
    if (titleLower.contains('كهرباء') || titleLower.contains('فاتورة')) {
      return const Color(0xFF0F172A); // Slate Dark
    }
    return const Color(0xFF006D5B); // Emerald Green
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedWorkItem == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار بند العمل أولاً', textDirection: TextDirection.rtl),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final amount = double.tryParse(_amountController.text) ?? 0.0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء إدخال مبلغ صحيح أكبر من الصفر', textDirection: TextDirection.rtl),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      context.read<ExpensesCubit>().addExpense(
            projectId: widget.projectId,
            workItemId: _selectedWorkItem!.id,
            amount: amount,
            description: _descriptionController.text.trim(),
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'مصاريف الورشة',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              fontSize: 18,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<ExpensesCubit, ExpensesState>(
          listener: (context, state) {
            if (state is ExpenseAddSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إضافة المصروف بنجاح', textDirection: TextDirection.rtl),
                  backgroundColor: Color(0xFF006D5B),
                ),
              );
              _amountController.clear();
              _descriptionController.clear();
              setState(() {
                _selectedWorkItem = null;
              });
            } else if (state is ExpensesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, textDirection: TextDirection.rtl),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            List<ExpenseEntity> expensesList = [];
            bool isAdding = false;

            if (state is ExpensesLoaded) {
              expensesList = state.expenses;
            } else if (state is ExpenseAdding) {
              expensesList = state.currentExpenses;
              isAdding = true;
            }

            return Stack(
              children: [
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    children: [
                      // Form Header
                      const Text(
                        'إضافة مصروف جديد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'يرجى ملء البيانات أدناه لتسجيل المصاريف اليومية للورشة.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.5,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Form Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. Work Item Dropdown Label
                              const Text(
                                'بند العمل',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Work Item Dropdown input field
                              DropdownButtonFormField<AssistantWorkItemEntity>(
                                value: _selectedWorkItem,
                                hint: const Text(
                                  'اختر البند...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF94A3B8),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1),
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                items: widget.workItems.map((item) {
                                  return DropdownMenuItem<AssistantWorkItemEntity>(
                                    value: item,
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWorkItem = value;
                                  });
                                },
                                validator: (value) => value == null ? 'يرجى اختيار بند العمل' : null,
                              ),
                              const SizedBox(height: 20),

                              // 2. Amount Input Label
                              const Text(
                                'المبلغ (ر.س)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Amount Input Field
                              TextFormField(
                                controller: _amountController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                ],
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF94A3B8),
                                    fontFamily: 'Tajawal',
                                  ),
                                  prefixIcon: const Icon(Icons.wallet_outlined, color: Color(0xFF94A3B8), size: 20),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى إدخال قيمة المبلغ';
                                  }
                                  final numVal = double.tryParse(value);
                                  if (numVal == null || numVal <= 0) {
                                    return 'الرجاء إدخال مبلغ صحيح';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // 3. Description Label
                              const Text(
                                'الوصف',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Description multi-line field
                              TextFormField(
                                controller: _descriptionController,
                                maxLines: 4,
                                minLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'اكتب تفاصيل إضافية عن هذا المصروف...',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF94A3B8),
                                    height: 1.5,
                                    fontFamily: 'Tajawal',
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF8FAFC),
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
                                    borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى كتابة وصف مختصر للمصروف';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // 4. Save/Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: isAdding ? null : _submitExpense,
                                  icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 18),
                                  label: const Text(
                                    'إضافة المصروف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F172A),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Section Title: "آخر المصاريف"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'آخر المصاريف',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'عرض الكل 〉',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF006D5B),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Listing expenses
                      if (expensesList.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0),
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'لا توجد مصاريف مسجلة حالياً',
                                  style: TextStyle(color: Colors.grey, fontFamily: 'Tajawal'),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: expensesList.length,
                          itemBuilder: (context, index) {
                            final exp = expensesList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.015),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Category Avatar Icon
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color: _getExpenseIconBgColor(exp.workItemName),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      _getExpenseIcon(exp.workItemName),
                                      color: _getExpenseIconColor(exp.workItemName),
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  // Core content (title & date)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exp.workItemName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _formatDisplayDate(exp.createdAt),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Amount Price Tag
                                  Text(
                                    '${exp.amount.toStringAsFixed(0)} ر.س',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                // Upload block overlay
                if (isAdding)
                  Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineScaleParty,
                              colors: [Colors.white],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري تسجيل وحفظ المصروف...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
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
