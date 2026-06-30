import 'package:equatable/equatable.dart';
import '../../domain/entities/project_image_entity.dart';

abstract class ProjectImagesState extends Equatable {
  const ProjectImagesState();

  @override
  List<Object?> get props => [];
}

class ProjectImagesInitial extends ProjectImagesState {}

class ProjectImagesLoading extends ProjectImagesState {}

class ProjectImagesLoaded extends ProjectImagesState {
  final List<ProjectImageEntity> images;

  const ProjectImagesLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class ProjectImagesUploading extends ProjectImagesState {}

class ProjectImagesUploadSuccess extends ProjectImagesState {
  final ProjectImageEntity uploadedImage;

  const ProjectImagesUploadSuccess({required this.uploadedImage});

  @override
  List<Object?> get props => [uploadedImage];
}

class ProjectImagesError extends ProjectImagesState {
  final String message;

  const ProjectImagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
