import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/backend_endpoints.dart';
import '../../../project_images/presentation/cubits/project_images_cubit.dart';
import '../../../project_images/presentation/cubits/project_images_state.dart';
import '../../../project_images/domain/entities/project_image_entity.dart';
import '../../domain/entities/ai_visualization_entity.dart';
import '../cubits/ai_visualization_cubit.dart';
import '../cubits/ai_visualization_state.dart';

class AiVisualizationsPage extends StatefulWidget {
  final String projectId;
  final String projectName;

  const AiVisualizationsPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<AiVisualizationsPage> createState() => _AiVisualizationsPageState();
}

class _AiVisualizationsPageState extends State<AiVisualizationsPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch loading visualizations
    context.read<AiVisualizationCubit>().loadVisualizations(widget.projectId);
  }

  // Completes the relative storage path to target the host directly
  String _getFullImageUrl(String path) {
    if (path.isEmpty) return 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600&auto=format&fit=crop';
    if (path.startsWith('http')) return path;
    // Strip '/api/' from base URL to reference the storage assets directly
    final base = BackendEndPoint.baseUrl.split('/api/').first;
    return '$base$path';
  }

  // Formats date strings to Arabic representation
  String _formatArabicDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (_) {
      return 'حديثاً';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF000000), // Deep premium black as shown in dark mockup
        appBar: AppBar(
          backgroundColor: const Color(0xFF000000),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          title: const Text(
            'تصاميم الذكاء الاصطناعي',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop'),
              ),
            ),
          ],
        ),
        body: BlocConsumer<AiVisualizationCubit, AiVisualizationState>(
          listener: (context, state) {
            if (state is AiVisualizationSubmitSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم توليد التصميم الإبداعي بنجاح! 🎨', textDirection: TextDirection.rtl),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is AiVisualizationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, textDirection: TextDirection.rtl),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            List<AiVisualizationEntity> visualizations = [];
            bool isLoading = false;
            bool isSubmitting = false;

            if (state is AiVisualizationLoading) {
              isLoading = true;
            } else if (state is AiVisualizationLoaded) {
              visualizations = state.visualizations;
            } else if (state is AiVisualizationSubmitting) {
              isSubmitting = true;
              visualizations = state.currentVisualizations;
            } else if (state is AiVisualizationSubmitSuccess) {
              visualizations = state.visualizations;
            } else if (state is AiVisualizationError) {
              visualizations = state.currentVisualizations;
            }

            return Stack(
              children: [
                if (isLoading)
                  const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [AppColors.accentGold, Colors.white],
                      ),
                    ),
                  )
                else
                  RefreshIndicator(
                    onRefresh: () => context.read<AiVisualizationCubit>().loadVisualizations(widget.projectId),
                    color: AppColors.accentGold,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      children: [
                        // Page Banner & Descriptions
                        const Text(
                          'معرض التصاميم الذكية',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'تصفح أحدث الابتكارات البصرية التي تم إنشاؤها بواسطة مساعدك الذكي الذكاء الاصطناعي لتصميم الفراغات بأعلى مستويات من الإبداع والدقة.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Color(0xFF94A3B8), // Slate 400
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Designer Group Row from Mockup
                        Row(
                          children: [
                            // Beautiful Stack of Circular Avatars
                            SizedBox(
                              width: 75,
                              height: 32,
                              child: Stack(
                                children: [
                                  const Positioned(
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=100&auto=format&fit=crop'),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    right: 18,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage('https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=100&auto=format&fit=crop'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 36,
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.black,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1E293B), // Slate 800
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '+81',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Tajawal',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'نخبة المصممين',
                              style: TextStyle(
                                color: Color(0xFFE2E8F0), // Slate 200
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Visualizations Card List
                        if (visualizations.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            alignment: Alignment.center,
                            child: const Text(
                              'لا توجد تصاميم مولدة حالياً، اضغط على زر التوليد في الأسفل للبدء!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          )
                        else
                          ...visualizations.map((visual) => _buildVisualizationCard(visual)),

                        const SizedBox(height: 80), // Padding to avoid FAB overlapping
                      ],
                    ),
                  ),

                // Absolute Glassmorphic Generative Overlay
                if (isSubmitting)
                  _buildGenerativeOverlay(),
              ],
            );
          },
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => _showCreateVisualizationBottomSheet(context),
        //   backgroundColor: AppColors.accentGold,
        //   icon: const Icon(Icons.auto_awesome_outlined, color: Colors.black),
        //   label: const Text(
        //     'توليد تصميم إبداعي',
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold,
        //       fontSize: 14,
        //       fontFamily: 'Tajawal',
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }

  // Renders individual visualization cards according to mockup layouts
  Widget _buildVisualizationCard(AiVisualizationEntity visual) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant generated image display with round corners
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              _getFullImageUrl(visual.generatedImage),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 250,
                  color: const Color(0xFF1E293B),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accentGold),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: const Color(0xFF1E293B),
                  child: const Icon(Icons.image_not_supported_outlined, color: Colors.white30, size: 50),
                );
              },
            ),
          ),

          // Bottom Info Block matching standard or detailed mockup styling
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  visual.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A), // Muted dark blue-grey title text
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                
                // Description (shown for detailed conceptual elements like the vehicle study card)
                if (visual.description != null && visual.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    visual.description!,
                    style: const TextStyle(
                      color: Color(0xFF475569), // Muted secondary body text
                      fontSize: 13,
                      height: 1.5,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),

                // Tags, Dates & Badges row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date display with tiny calendar icon
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Text(
                          _formatArabicDate(visual.createdAt),
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),

                    // Badge if conceptual design
                    if (visual.isConceptual)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED), // Subtle light amber
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: const Color(0xFFFFEDD5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.palette_outlined, size: 12, color: Colors.orange.shade800),
                            const SizedBox(width: 4),
                            Text(
                              'تصميم خيالي',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Action navigation button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Detailed photo overlay popup or click feedback
                      _showImageDetailDialog(context, visual);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: visual.isConceptual
                          ? Colors.transparent
                          : const Color(0xFF0F172A), // Dark slate fill or transparent border
                      foregroundColor: visual.isConceptual ? const Color(0xFF0F172A) : Colors.white,
                      elevation: 0,
                      side: visual.isConceptual
                          ? const BorderSide(color: Color(0xFFCBD5E1), width: 1.5)
                          : BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض التفاصيل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Tajawal',
                            color: visual.isConceptual ? const Color(0xFF0F172A) : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: visual.isConceptual ? const Color(0xFF0F172A) : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Elegant full-screen overlay while AI generation is in progress
  Widget _buildGenerativeOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulse loading animation
              SizedBox(
                width: 100,
                height: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballScaleRippleMultiple,
                  colors: [AppColors.accentGold, Colors.orangeAccent.shade200, Colors.white],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'توليد بالذكاء الاصطناعي 🎨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'جاري الرسم وتخيل الفراغات بالذكاء الاصطناعي بدقة متناهية... يرجى الانتظار لحظة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Opens interactive Bottom Sheet where the user triggers the creation API
  void _showCreateVisualizationBottomSheet(BuildContext context) {
    final TextEditingController promptController = TextEditingController();
    ProjectImageEntity? selectedImage;
    final List<String> selectedLocalReferencePaths = [];
    final formKey = GlobalKey<FormState>();

    final aiCubit = context.read<AiVisualizationCubit>();

    // Grab available unit images
    List<ProjectImageEntity> availableImages = [];
    final projectImagesState = context.read<ProjectImagesCubit>().state;
    if (projectImagesState is ProjectImagesLoaded) {
      availableImages = projectImagesState.images;
    }

    Future<void> pickReferenceImages(StateSetter setSheetState) async {
      final ImagePicker picker = ImagePicker();
      try {
        final List<XFile> images = await picker.pickMultiImage();
        if (images.isNotEmpty) {
          setSheetState(() {
            selectedLocalReferencePaths.addAll(images.map((img) => img.path));
          });
        }
      } catch (e) {
        // Handle error gracefully
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A), // Matching deep dark theme slate
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFF334155),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Title
                        const Row(
                          children: [
                            Icon(Icons.palette_outlined, color: AppColors.accentGold, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'توليد تصميم إبداعي جديد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Step 1: Select Original Apartment Photo
                        const Text(
                          '1. اختر صورة الوحدة العقارية المرجعية:',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 10),

                        if (availableImages.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'لم يتم العثور على صور مرفوعة مسبقاً في الوحدة. يرجى رفع صورة للوحدة أولاً لتتمكن من استخدامها كمرجع!',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                                height: 1.5,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: availableImages.length,
                              itemBuilder: (context, index) {
                                final img = availableImages[index];
                                final isSelected = selectedImage?.id == img.id;
                                return GestureDetector(
                                  onTap: () {
                                    setSheetState(() {
                                      selectedImage = img;
                                    });
                                  },
                                  child: Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected ? AppColors.accentGold : Colors.transparent,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: Image.network(
                                        _getFullImageUrl(img.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Step 2: Describe prompt
                        const Text(
                          '2. اكتب تفاصيل الطراز أو الفراغ الإبداعي:',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          controller: promptController,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال وصف أو فكرة للتصميم';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
                          decoration: InputDecoration(
                            hintText: 'مثال: تصميم مودرن بلمسات خشبية وإضاءة مدمجة هادئة لتصميم الصالة العائلية...',
                            hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 12, fontFamily: 'Tajawal'),
                            fillColor: const Color(0xFF1E293B),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.accentGold, width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Step 3: Local reference images upload (optional)
                        const Text(
                          '3. إضافة صور مرجعية جديدة للرفع (اختياري):',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedLocalReferencePaths.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // Add button card
                                return GestureDetector(
                                  onTap: () => pickReferenceImages(setSheetState),
                                  child: Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF334155),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_photo_alternate_outlined, color: AppColors.accentGold, size: 28),
                                        SizedBox(height: 4),
                                        Text(
                                          'إضافة صور',
                                          style: TextStyle(
                                            color: Color(0xFF94A3B8),
                                            fontSize: 11,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final localPath = selectedLocalReferencePaths[index - 1];
                              return Stack(
                                children: [
                                  Container(
                                    width: 90,
                                    margin: const EdgeInsets.only(left: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF334155),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(11),
                                      child: Image.file(
                                        File(localPath),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 16,
                                    child: GestureDetector(
                                      onTap: () {
                                        setSheetState(() {
                                          selectedLocalReferencePaths.removeAt(index - 1);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.redAccent,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Action submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (selectedImage == null && availableImages.isNotEmpty) {
                                  ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                                    const SnackBar(
                                      content: Text('يرجى اختيار صورة مرجعية أولاً', textDirection: TextDirection.rtl),
                                      backgroundColor: AppColors.warning,
                                    ),
                                  );
                                  return;
                                }

                                final chosenImageId = selectedImage?.id ?? 1; // Fallback helper

                                // Trigger generator with both prompt and picked reference images
                                aiCubit.generateVisualization(
                                      projectId: widget.projectId,
                                      projectImageId: chosenImageId,
                                      prompt: promptController.text.trim(),
                                      referenceImages: selectedLocalReferencePaths,
                                    );
                                
                                // Close bottom sheet to show the beautiful full page overlay
                                Navigator.pop(bottomSheetContext);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.flash_on_rounded, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'توليد بالذكاء الاصطناعي ⚡',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
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
              ),
            );
          },
        );
      },
    );
  }

  // Image detail click viewer popup
  void _showImageDetailDialog(BuildContext context, AiVisualizationEntity visual) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    _getFullImageUrl(visual.generatedImage),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visual.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      if (visual.description != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          visual.description!,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            height: 1.5,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                      if (visual.prompt != null && visual.prompt!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'الوصف المكتوب (الطلب):',
                                style: TextStyle(
                                  color: AppColors.accentGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                visual.prompt!,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  height: 1.4,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'إغلاق الفراغ',
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
