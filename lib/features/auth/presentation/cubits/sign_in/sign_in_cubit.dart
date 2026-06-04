import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/repo/auth_repo.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.authRepo) : super(SignInInitial());
  final AuthRepo authRepo;

  void signIn(String email, String password) async {
    emit(SignInLoading());
    final result = await authRepo.signIn(email, password);
    result.fold(
      (l) => emit(SignInFailure(l.errMessage)),
      (r) => emit(SignInSuccess()),
    );
  }
}
