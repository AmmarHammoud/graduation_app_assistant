import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'resend_code_state.dart';

class ResendCodeCubit extends Cubit<ResendCodeState> {
  ResendCodeCubit() : super(ResendCodeInitial());
}
