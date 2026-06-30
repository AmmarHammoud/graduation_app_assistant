import '../../domain/entities/ai_visualization_entity.dart';

class AiVisualizationModel extends AiVisualizationEntity {
  const AiVisualizationModel({
    required super.id,
    required super.generatedImage,
    required super.createdAt,
    required super.title,
    super.description,
    super.isConceptual,
    super.prompt,
    super.projectImageId,
  });

  factory AiVisualizationModel.fromJson(Map<String, dynamic> json, {String? defaultPrompt, int? defaultProjectImageId}) {
    final generatedImg = json['generated_image'] as String? ?? '';
    final promptValue = json['prompt'] as String? ?? defaultPrompt ?? '';
    final recordId = json['id'] as int? ?? 0;
    
    // Generate beautiful titles and descriptions procedurally based on prompt or ID
    String titleValue = 'تصميم تخيلي ذكي';
    String? descValue;
    bool isConceptualValue = false;

    if (promptValue.contains('سيارة') || promptValue.contains('مركبة') || promptValue.toLowerCase().contains('car') || recordId == 4) {
      titleValue = 'نموذج النقل الكهربائي';
      descValue = 'دراسة تصميمية لمركبة كهربائية تكثف الاستدامة والديناميكيات الهوائية المتقدمة مع واجهة مستخدم مدمجة بالكامل.';
      isConceptualValue = true;
    } else if (promptValue.contains('ناطحة') || promptValue.contains('برج') || promptValue.toLowerCase().contains('skyscraper') || recordId == 1) {
      titleValue = 'ناطحة سحاب مستدامة';
    } else if (promptValue.contains('مكتب') || promptValue.contains('عمل') || promptValue.toLowerCase().contains('office') || recordId == 2) {
      titleValue = 'مكتب المستقبل الذكي';
    } else if (promptValue.contains('بيانات') || promptValue.contains('فني') || promptValue.toLowerCase().contains('data') || recordId == 3) {
      titleValue = 'تدفق البيانات الفنية';
    } else if (promptValue.contains('واحة') || promptValue.contains('حديقة') || promptValue.toLowerCase().contains('oasis') || recordId == 5) {
      titleValue = 'واحة المدينة الذكية';
    } else if (promptValue.isNotEmpty) {
      titleValue = promptValue.length > 25 ? '${promptValue.substring(0, 22)}...' : promptValue;
    }

    return AiVisualizationModel(
      id: recordId,
      generatedImage: generatedImg,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      title: titleValue,
      description: descValue,
      isConceptual: isConceptualValue,
      prompt: promptValue,
      projectImageId: json['project_image_id'] as int? ?? defaultProjectImageId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generated_image': generatedImage,
      'created_at': createdAt,
      'title': title,
      'description': description,
      'is_conceptual': isConceptual,
      'prompt': prompt,
      'project_image_id': projectImageId,
    };
  }
}
