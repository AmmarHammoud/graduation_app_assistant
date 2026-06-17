import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entity/user_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';


part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final   UpdateProfileUsecase updateProfileUsecase;

  ProfileCubit({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUsecase();
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> updateProfile(UserEntity user) async {
    emit(ProfileLoading());
    final result = await updateProfileUsecase(user);
    result.fold(
      (failure) => emit(ProfileError(failure.errMessage)),
      (updatedUser) => emit(ProfileLoaded(updatedUser)),
    );
  }
}
