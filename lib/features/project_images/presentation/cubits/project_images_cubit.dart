import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/project_images_usecases.dart';
import 'project_images_state.dart';

class ProjectImagesCubit extends Cubit<ProjectImagesState> {
  final GetProjectImagesUseCase getProjectImagesUseCase;
  final UploadProjectImageUseCase uploadProjectImageUseCase;
  final DeleteProjectImageUseCase deleteProjectImageUseCase;

  ProjectImagesCubit({
    required this.getProjectImagesUseCase,
    required this.uploadProjectImageUseCase,
    required this.deleteProjectImageUseCase,
  }) : super(ProjectImagesInitial());

  Future<void> loadImages(String projectId) async {
    emit(ProjectImagesLoading());
    final result = await getProjectImagesUseCase(projectId);
    result.fold(
      (failure) => emit(ProjectImagesError(message: failure.errMessage)),
      (images) => emit(ProjectImagesLoaded(images: images)),
    );
  }

  Future<void> uploadImage({
    required String projectId,
    required String name,
    required String imagePath,
  }) async {
    final currentState = state;
    final List<dynamic> previousImages = currentState is ProjectImagesLoaded ? currentState.images : [];

    emit(ProjectImagesUploading());
    final result = await uploadProjectImageUseCase(
      projectId: projectId,
      name: name,
      imagePath: imagePath,
    );

    await result.fold(
      (failure) async {
        emit(ProjectImagesError(message: failure.errMessage));
        if (previousImages.isNotEmpty) {
          emit(ProjectImagesLoaded(images: List.from(previousImages)));
        }
      },
      (newImage) async {
        emit(ProjectImagesUploadSuccess(uploadedImage: newImage));
        await loadImages(projectId);
      },
    );
  }

  Future<void> deleteImage({
    required int imageId,
    required String projectId,
  }) async {
    final result = await deleteProjectImageUseCase(imageId);
    await result.fold(
      (failure) async => emit(ProjectImagesError(message: failure.errMessage)),
      (success) async {
        await loadImages(projectId);
      },
    );
  }
}
