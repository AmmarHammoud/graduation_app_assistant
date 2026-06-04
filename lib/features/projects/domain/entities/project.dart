import 'package:equatable/equatable.dart';

enum ProjectStatus { inProgress, completed, upcoming }

class Project extends Equatable {
  final String id;
  final String title;
  final String location;
  final double completionPercentage;
  final ProjectStatus status;
  final String imageUrl;
  final String? statusLabel;
  final String? executionDateText;

  const Project({
    required this.id,
    required this.title,
    required this.location,
    required this.completionPercentage,
    required this.status,
    required this.imageUrl,
    this.statusLabel,
    this.executionDateText,
  });

  @override
  List<Object?> get props => [id, title, location, completionPercentage, status, imageUrl, statusLabel, executionDateText];
}