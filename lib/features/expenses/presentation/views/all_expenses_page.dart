import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../projects/domain/entities/assigned_proejct_details.dart';
import '../cubits/expenses_cubit.dart';
import '../cubits/expenses_state.dart';
import '../../domain/entities/expense_entity.dart';

class AllExpensesPage extends StatefulWidget {
  final String projectId;
  final String projectName;
  final List<AssistantWorkItemEntity> workItems;

  const AllExpensesPage({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.workItems,
  });

  @override
  State<AllExpensesPage> createState() => _AllExpensesPageState();
}

class _AllExpensesPageState extends State<AllExpensesPage> {
  @override
  void initState() {
    super.initState();
    _loadAllExpenses();
  }

  void _loadAllExpenses() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    final fromDateStr = "${thirtyDaysAgo.year}-${thirtyDaysAgo.month.toString().padLeft(2, '0')}-${thirtyDaysAgo.day.toString().padLeft(2, '0')}";
    final toDateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    context.read<ExpensesCubit>().loadAllExpenses(
          projectId: widget.projectId,
          workItems: widget.workItems,
          fromDate: fromDateStr,
          toDate: toDateStr,
        );
  }

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
      if (dateStr.contains('منذ') || dateStr == 'أمس') {
        return dateStr;
      }
      return 'حديثاً';
    }
  }

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

  Color _getExpenseIconBgColor(String itemTitle) {
    final titleLower = itemTitle.toLowerCase();
    if (titleLower.contains('كهرباء') || titleLower.contains('فاتورة')) {
      return const Color(0xFFF1F5F9);
    }
    return const Color(0xFFE6F7F4);
  }

  Color _getExpenseIconColor(String itemTitle) {
    final titleLower = itemTitle.toLowerCase();
    if (titleLower.contains('كهرباء') || titleLower.contains('فاتورة')) {
      return const Color(0xFF0F172A);
    }
    return const Color(0xFF006D5B);
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
            'جميع المصاريف',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              fontSize: 18,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ExpensesCubit, ExpensesState>(
          builder: (context, state) {
            if (state is ExpensesLoading) {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScaleParty,
                    colors: [Color(0xFF006D5B)],
                  ),
                ),
              );
            }

            if (state is ExpensesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 60, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadAllExpenses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Tajawal', color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              );
            }

            List<ExpenseEntity> expensesList = [];
            if (state is ExpensesLoaded) {
              expensesList = state.expenses;
            }

            if (expensesList.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async => _loadAllExpenses(),
                color: const Color(0xFF006D5B),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 64, color: Color(0xFF94A3B8)),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد مصاريف مسجلة لهذا المشروع',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'يرجى تسجيل المصاريف من صفحة إدارة المصاريف.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
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

            // Calculate total amount dynamically
            final totalAmount = expensesList.fold<double>(0.0, (sum, item) => sum + item.amount);

            return RefreshIndicator(
              onRefresh: () async => _loadAllExpenses(),
              color: const Color(0xFF006D5B),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  // Premium Total Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'إجمالي المصاريف المرصودة',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF006D5B).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF006D5B).withOpacity(0.3)),
                              ),
                              child: Text(
                                '${expensesList.length} عمليات',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF2DD4BF),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${totalAmount.toStringAsFixed(2)} ر.س',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'مشروع: ${widget.projectName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFCBD5E1),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section title
                  const Text(
                    'سجل المصاريف المفصل',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // List of items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: expensesList.length,
                    itemBuilder: (context, index) {
                      final exp = expensesList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  decoration: BoxDecoration(
                                    color: _getExpenseIconBgColor(exp.workItemName),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getExpenseIcon(exp.workItemName),
                                    color: _getExpenseIconColor(exp.workItemName),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp.workItemName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F172A),
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDisplayDate(exp.createdAt),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${exp.amount.toStringAsFixed(2)} ر.س',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'بواسطة: ${exp.createdByName}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (exp.description.isNotEmpty) ...[
                              const Divider(height: 16, color: Color(0xFFF1F5F9)),
                              Text(
                                exp.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  height: 1.5,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
