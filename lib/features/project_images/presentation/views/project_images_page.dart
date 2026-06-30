import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/utils/backend_endpoints.dart';
import '../../domain/entities/project_image_entity.dart';
import '../cubits/project_images_cubit.dart';
import '../cubits/project_images_state.dart';

class ProjectImagesPage extends StatefulWidget {
  final String projectId;
  final String projectName;

  const ProjectImagesPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<ProjectImagesPage> createState() => _ProjectImagesPageState();
}

class _ProjectImagesPageState extends State<ProjectImagesPage> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  bool _isFormVisible = false;
  bool _isGridView = false; // Toggles between Grid and List layouts
  String? _selectedImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Completes the relative storage path to target the host directly
  String _getFullImageUrl(String path) {
    if (path.isEmpty) return '';
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

  // Opens camera or gallery dialog to select an image
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF0F172A)),
                  title: const Text('التقاط صورة بالكاميرا', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                    if (photo != null) {
                      setState(() {
                        _selectedImagePath = photo.path;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF0F172A)),
                  title: const Text('اختيار من معرض الصور', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (image != null) {
                      setState(() {
                        _selectedImagePath = image.path;
                      });
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

  // Submits the upload payload
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار ملف الصورة أولاً', textDirection: TextDirection.rtl),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      context.read<ProjectImagesCubit>().uploadImage(
            projectId: widget.projectId,
            name: _nameController.text.trim(),
            imagePath: _selectedImagePath!,
          );
    }
  }

  // Triggers deletion verification popup
  void _confirmDeletion(int imageId) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('حذف الصورة', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('هل أنت متأكد من رغبتك في حذف هذه الصورة نهائياً؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ProjectImagesCubit>().deleteImage(
                      imageId: imageId,
                      projectId: widget.projectId,
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
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
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: Text(
            widget.projectName,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<ProjectImagesCubit, ProjectImagesState>(
          listener: (context, state) {
            if (state is ProjectImagesUploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم رفع الصورة بنجاح', textDirection: TextDirection.rtl),
                  backgroundColor: Color(0xFF006D5B),
                ),
              );
              setState(() {
                _nameController.clear();
                _selectedImagePath = null;
                _isFormVisible = false;
              });
            } else if (state is ProjectImagesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, textDirection: TextDirection.rtl),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            List<ProjectImageEntity> images = [];
            bool isLoading = false;
            bool isUploading = false;

            if (state is ProjectImagesLoading) {
              isLoading = true;
            } else if (state is ProjectImagesUploading) {
              isUploading = true;
              // Retain currently loaded images to avoid empty page flashing during upload
              final previousState = context.read<ProjectImagesCubit>().state;
              if (previousState is ProjectImagesLoaded) {
                images = previousState.images;
              }
            } else if (state is ProjectImagesLoaded) {
              images = state.images;
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => context.read<ProjectImagesCubit>().loadImages(widget.projectId),
                  color: const Color(0xFF006D5B),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    children: [
                      // Page Title & Subtitle block
                      const Text(
                        'صور الشقة قبل الإكساء',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'وثق حالة الوحدة العقارية قبل البدء بأعمال التشطيبات النهائية',
                        style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 20),

                      // Trigger Action Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isFormVisible = !_isFormVisible;
                            });
                          },
                          icon: Icon(
                            _isFormVisible ? Icons.close : Icons.add_a_photo_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            _isFormVisible ? 'إغلاق النموذج' : 'رفع صورة جديدة',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Expandable Add Photo card form (Renders dynamically)
                      if (_isFormVisible) ...[
                        _buildUploadForm(isUploading),
                        const SizedBox(height: 24),
                      ],

                      // Uploaded pictures Catalog section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الصور المرفوعة (${images.length})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.grid_view_outlined,
                                  color: _isGridView ? const Color(0xFF006D5B) : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isGridView = true;
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.view_list_outlined,
                                  color: !_isGridView ? const Color(0xFF006D5B) : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isGridView = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Loading feedback or listing grid/list
                      if (isLoading && images.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 60.0),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [Color(0xFF006D5B)],
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                      else if (images.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 60.0),
                            child: Column(
                              children: [
                                Icon(Icons.image_not_supported_outlined, size: 64, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'لا يوجد صور مرفوعة حالياً في هذا المشروع',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        _isGridView ? _buildGridCatalog(images) : _buildListCatalog(images),

                      const SizedBox(height: 80), // Padding to clear bottom navigation
                    ],
                  ),
                ),

                // Upload block overlay
                if (isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: LoadingIndicator(
                              indicatorType: Indicator.lineScaleParty,
                              colors: [Colors.white],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'جاري رفع وحفظ الصورة...',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Upload Form Card Builder
  Widget _buildUploadForm(bool isUploading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.note_add_outlined, color: Color(0xFF006D5B), size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'إضافة صورة للوحدة',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Name of photo
            const Text(
              'اسم الصورة',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'مثال: صالون، مطبخ، غرفة نوم',
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'الرجاء إدخال اسم للصورة';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Select Photo picker
            const Text(
              'اختيار الصورة',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: isUploading ? null : _pickImage,
              child: _selectedImagePath != null
                  ? Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(_selectedImagePath!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedImagePath = null;
                            });
                          },
                        ),
                      ),
                    )
                  : Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          style: BorderStyle.solid, // Note: standard dotted custom borders require painter, border is standard
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, color: Color(0xFF64748B), size: 28),
                          SizedBox(height: 8),
                          Text(
                            'اختر ملف الصورة',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isUploading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'حفظ الصورة',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1-Column List Catalog
  Widget _buildListCatalog(List<ProjectImageEntity> images) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final img = images[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  _getFullImageUrl(img.imageUrl),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      color: const Color(0xFFE2E8F0),
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingBuilderDone(loadingProgress)) return child;
                    return Container(
                      height: 220,
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(color: Color(0xFF006D5B), strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Card Details Bottom Row
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            img.name,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 6),
                              Text(
                                _formatArabicDate(img.createdAt),
                                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                      onPressed: () => _confirmDeletion(img.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 2-Column Grid Catalog
  Widget _buildGridCatalog(List<ProjectImageEntity> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final img = images[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    _getFullImageUrl(img.imageUrl),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: Icon(Icons.broken_image_outlined, size: 36, color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingBuilderDone(loadingProgress)) return child;
                      return Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                          child: CircularProgressIndicator(color: Color(0xFF006D5B), strokeWidth: 1.5),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Image Info Row
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      img.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _formatArabicDate(img.createdAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _confirmDeletion(img.id),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool loadingBuilderDone(ImageChunkEvent? loadingProgress) {
    return loadingProgress == null || 
           loadingProgress.expectedTotalBytes == null || 
           loadingProgress.cumulativeBytesLoaded == loadingProgress.expectedTotalBytes;
  }

  // Premium Custom Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home_outlined, 'الرئيسية', false),
              _buildBottomNavItem(Icons.image_outlined, 'الصور', true),
              _buildBottomNavItem(Icons.notifications_none_outlined, 'التنبيهات', false),
              _buildBottomNavItem(Icons.person_outline, 'الشخصي', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFFE6F7F4),
              borderRadius: BorderRadius.circular(16),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF006D5B) : const Color(0xFF64748B),
            size: isActive ? 22 : 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF006D5B) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
